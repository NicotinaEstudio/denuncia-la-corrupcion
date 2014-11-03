/**
 * Copyright 2014 Nicotina Estudio
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/


#import "FormularioDenunciaViewControllerPaso3.h"
#import "FormularioDenunciaViewControllerPaso4.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "S3.h"
#import "Constantes.h"
#import "Evidencia.h"

@interface FormularioDenunciaViewControllerPaso3 ()

@property (nonatomic, strong) NSURL *testFileURL1;
@property (nonatomic, strong) NSURL *testFileURL2;
@property (nonatomic, strong) NSURL *testFileURL3;
@property (nonatomic, strong) NSURL *fileURL1;
@property (nonatomic, strong) NSURL *fileURL2;
@property (nonatomic, strong) NSURL *fileURL3;

@property (nonatomic, strong) AWSS3TransferManagerUploadRequest *uploadRequest1;
@property (nonatomic, strong) AWSS3TransferManagerUploadRequest *uploadRequest2;
@property (nonatomic, strong) AWSS3TransferManagerUploadRequest *uploadRequest3;

@property (nonatomic) uint64_t file1Size;
@property (nonatomic) uint64_t file2Size;
@property (nonatomic) uint64_t file3Size;

@property (nonatomic) uint64_t file1AlreadyUpload;
@property (nonatomic) uint64_t file2AlreadyUpload;
@property (nonatomic) uint64_t file3AlreadyUpload;

@property NSString *nombreImagen1;
@property NSString *nombreImagen2;
@property NSString *nombreVideo;

@end

@implementation FormularioDenunciaViewControllerPaso3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self cleanProgress];
    
    _arrImagenes = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Pasamos el contexto al siguiente paso
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"paso4"])
    {
        FormularioDenunciaViewControllerPaso4 *paso4 = [segue destinationViewController];
        paso4.contexto = _contexto;
        paso4.denuncia = _denuncia;
    }
}

// Carga de Imagen
- (IBAction)btnFotografia:(UIButton *)sender
{
    // Solo dos fotografías para prototipo
    if([self.arrImagenes count] == 2)
        return;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

// Carga video
- (IBAction)btnVideo:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)btnSubirArchivos:(UIButton *)sender
{
    // Subimos evidencias a Amazon
    
    // Nombre único para imagenes
    _nombreImagen1 = [NSString stringWithFormat:@"%@%@", [[NSUUID UUID] UUIDString], @".jpg"];
    _nombreImagen2 = [NSString stringWithFormat:@"%@%@", [[NSUUID UUID] UUIDString], @".jpg"];
    _nombreVideo = [NSString stringWithFormat:@"%@%@", [[NSUUID UUID] UUIDString], @".mp4"];
    
    NSData *imageData1 = UIImageJPEGRepresentation(self.imgEvidencia.image, 1);
    NSString *filePath1 = [NSTemporaryDirectory() stringByAppendingPathComponent:_nombreImagen1];
    [imageData1 writeToFile:filePath1 atomically:YES];
    
    NSData *imageData2 = UIImageJPEGRepresentation(self.imgEvidencia2.image, 1);
    NSString *filePath2 = [NSTemporaryDirectory() stringByAppendingPathComponent:_nombreImagen2];
    [imageData2 writeToFile:filePath2 atomically:YES];
    
    NSError *error = nil;
    NSData *dataVideo = [NSData dataWithContentsOfFile:self.pathVideo options:nil error:&error];
    
    self.fileURL1 = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:_nombreImagen1]];
    self.fileURL2 = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:_nombreImagen2]];
    
    self.file1Size = [imageData1 length];
    self.file2Size = [imageData2 length];
    self.file3Size = [dataVideo length];
    
    self.lblEstatus.text = StatusLabelUploading;
    [self cleanProgress];
    
    __weak typeof(self) weakSelf = self;
    
    self.uploadRequest1 = [AWSS3TransferManagerUploadRequest new];
    self.uploadRequest1.bucket = S3BucketName;
    self.uploadRequest1.key = _nombreImagen1;
    self.uploadRequest1.contentType = @"image/jpeg";
    self.uploadRequest1.body = self.fileURL1;
    self.uploadRequest1.uploadProgress =  ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend){
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSelf.file1AlreadyUpload = totalBytesSent;
            [weakSelf updateProgress];
        });
    };
    
    self.uploadRequest2 = [AWSS3TransferManagerUploadRequest new];
    self.uploadRequest2.bucket = S3BucketName;
    self.uploadRequest1.contentType = @"image/jpeg";
    self.uploadRequest2.key = _nombreImagen2;
    self.uploadRequest2.body = self.fileURL2;
    self.uploadRequest2.uploadProgress =  ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend){
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSelf.file2AlreadyUpload = totalBytesSent;
            [weakSelf updateProgress];
        });
    };
    
     self.uploadRequest3 = [AWSS3TransferManagerUploadRequest new];
     self.uploadRequest3.bucket = S3BucketName;
     self.uploadRequest3.key = _nombreVideo;
     self.uploadRequest3.body = self.fileURL3;
     self.uploadRequest3.uploadProgress =  ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend){
     dispatch_sync(dispatch_get_main_queue(), ^{
     weakSelf.file3AlreadyUpload = totalBytesSent;
     [weakSelf updateProgress];
     });
     };
    
    
    [self uploadFiles];
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    NSString *tipoMedia = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *imgOriginal, *imgEditada, *imgAUsar;
    
    // Imagen seleccionada desde el album
    if (CFStringCompare ((CFStringRef) tipoMedia, kUTTypeImage, 0) == kCFCompareEqualTo)
    {
        imgEditada = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
        imgOriginal = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        
        if (imgEditada)
            imgAUsar = imgEditada;
        else
            imgAUsar = imgOriginal;
        
        NSString *URL = [((NSURL *)[info objectForKey:UIImagePickerControllerReferenceURL]) path];
        
        NSURL *picURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        
        NSString *stringUrl = picURL.absoluteString;
        
        NSURL *asssetURL = [NSURL URLWithString:URL];
        
        if([self.arrImagenes count] == 0)
        {
            self.imgEvidencia.image = imgAUsar;
            self.fileURL1 = picURL;
        }
        else
        {
            self.imgEvidencia2.image = imgAUsar;
            self.fileURL2 = picURL;
        }
        
        // Agregamos el path de la imagen selecionada al array de imagenes
        [self.arrImagenes addObject:imgAUsar];
    }
    
    // Video seleccionado desde la galería
    if (CFStringCompare ((CFStringRef) tipoMedia, kUTTypeMovie, 0) == kCFCompareEqualTo)
    {
        NSString *videoPath = [[info objectForKey: UIImagePickerControllerMediaURL] path];
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        
        if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
        {
            
            NSString *filePath3 = [NSTemporaryDirectory() stringByAppendingPathComponent:_nombreImagen1];
            
            AVAssetExportSession *exportSesion = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                                 presetName:AVAssetExportPresetPassthrough];
            
            //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            //NSString *outputURL = paths[0];
            NSFileManager *manager = [NSFileManager defaultManager];
            //[manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
            //outputURL = [outputURL stringByAppendingPathComponent:@"output.mp4"];
            NSString *outputURL = [NSTemporaryDirectory() stringByAppendingPathComponent:@"output.mp4"];
            self.fileURL3 = [NSURL URLWithString:outputURL];
            self.pathVideo = outputURL;
            
            // Remove Existing File
            [manager removeItemAtPath:outputURL error:nil];
            
            exportSesion.outputURL = [NSURL fileURLWithPath:outputURL];
            NSLog(@"videopath of your mp4 file = %@",outputURL);  // PATH OF YOUR .mp4 FILE
            exportSesion.outputFileType = AVFileTypeMPEG4;
            
            
            //exportSesion.outputURL = [NSURL fileURLWithPath:videoPath];
            //NSLog(@"Path del video mp4 = %@",videoPath);
            //NSLog(@"Path del video nuevo mp4 = %@",videoPathNuevo);
            //exportSesion.outputFileType = AVFileTypeMPEG4;
            
            [exportSesion exportAsynchronouslyWithCompletionHandler:^{
                
                switch ([exportSesion status])
                {
                    case AVAssetExportSessionStatusFailed:
                        NSLog(@"Exportación fallida: %@", [[exportSesion error] localizedDescription]);
                        break;
                    case AVAssetExportSessionStatusCancelled:
                        NSLog(@"Exportación cancelada");
                        break;
                    case AVAssetExportSessionStatusCompleted:
                        
                        NSLog(@"Exportación completa");
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //post the notification!
                        });
                        break;
                        
                }
            }];
        }
    }
    
    [picker dismissModalViewControllerAnimated:YES];
    //self.btnCreateBlobWithSAS.enabled = YES;
}

- (void) AVSEExportCommandCompletionNotification:(NSNotification*)notification
{
    NSError *error = nil;
    NSData *dataVideo = [NSData dataWithContentsOfFile:self.pathVideo options:nil error:&error];
}

// Validamos los campos antes de mandar a la siguiente pantalla
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}

- (void) cleanProgress
{
    self.pbImagen1.progress = 0;
    self.pbImagen2.progress = 0;
    self.pbVideo.progress = 0;
    
    self.file1AlreadyUpload = 0;
    self.file2AlreadyUpload = 0;
    self.file3AlreadyUpload = 0;
}

- (void)updateProgress
{
    if (self.file1AlreadyUpload <= self.file1Size)
    {
        self.pbImagen1.progress = (float)self.file1AlreadyUpload / (float)self.file1Size;
    }
    
    if (self.file2AlreadyUpload <= self.file2Size)
    {
        self.pbImagen2.progress = (float)self.file2AlreadyUpload / (float)self.file2Size;
    }
    
    if (self.file3AlreadyUpload <= self.file3Size)
    {
        self.pbVideo.progress = (float)self.file3AlreadyUpload / (float)self.file3Size;
    }
}

- (void) uploadFiles
{
    self.btnSiguientePaso.enabled = NO;
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    __block int uploadCount = 0;
    
    [[transferManager upload:self.uploadRequest1] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        if (task.error != nil) {
            if( task.error.code != AWSS3TransferManagerErrorCancelled
               &&
               task.error.code != AWSS3TransferManagerErrorPaused
               )
            {
                self.lblEstatus.text = StatusLabelFailed;
                NSLog(@"error %@", task.error);
            }
        } else {
            self.uploadRequest1 = nil;
            uploadCount ++;
            
            if(3 == uploadCount){
                self.lblEstatus.text = StatusLabelCompleted;
                self.btnSiguientePaso.enabled = YES;
                [self guardaEvidencias];
            }
        }
        return nil;
    }];
    
    [[transferManager upload:self.uploadRequest2] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        if (task.error != nil) {
            if( task.error.code != AWSS3TransferManagerErrorCancelled
               &&
               task.error.code != AWSS3TransferManagerErrorPaused
               )
            {
                self.lblEstatus.text = StatusLabelFailed;
            }
        } else {
            self.uploadRequest2 = nil;
            uploadCount ++;
            
            if(3 == uploadCount){
                self.lblEstatus.text = StatusLabelCompleted;
                self.btnSiguientePaso.enabled = YES;
                [self guardaEvidencias];
            }
        }
        return nil;
    }];
    
    
    [[transferManager upload:self.uploadRequest3] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        if (task.error != nil) {
            if( task.error.code != AWSS3TransferManagerErrorCancelled
               &&
               task.error.code != AWSS3TransferManagerErrorPaused
               )
            {
                self.lblEstatus.text = StatusLabelFailed;
            }
        } else {
            self.uploadRequest3 = nil;
            uploadCount ++;
            if(3 == uploadCount){
                self.lblEstatus.text = StatusLabelCompleted;
                self.btnSiguientePaso.enabled = YES;
                [self guardaEvidencias];
            }
        }
        return nil;
    }];
}

-(void) guardaEvidencias
{
    // Guardamos la evidencia en la base de datos local
    Evidencia *evidencia1 = [NSEntityDescription insertNewObjectForEntityForName:@"Evidencia"
                                                         inManagedObjectContext:_contexto];
    Evidencia *evidencia2 = [NSEntityDescription insertNewObjectForEntityForName:@"Evidencia"
                                                          inManagedObjectContext:_contexto];
    Evidencia *evidencia3 = [NSEntityDescription insertNewObjectForEntityForName:@"Evidencia"
                                                          inManagedObjectContext:_contexto];
    evidencia1.archivo = _nombreImagen1;
    evidencia2.archivo = _nombreImagen2;
    evidencia3.archivo = _nombreVideo;
    
    [_denuncia addEvidenciaObject:evidencia1];
    [_denuncia addEvidenciaObject:evidencia2];
    [_denuncia addEvidenciaObject:evidencia3];
    
    NSError *error;
    if (![_contexto save:&error])
        NSLog(@"No se ha podido agregar la evidencia.: %@", [error localizedDescription]);
    else
    {
        NSLog(@"Evidencia guardada.");
        // Enviamos al paso 4
        [self performSegueWithIdentifier:@"paso4" sender:self];
    }
}
@end
