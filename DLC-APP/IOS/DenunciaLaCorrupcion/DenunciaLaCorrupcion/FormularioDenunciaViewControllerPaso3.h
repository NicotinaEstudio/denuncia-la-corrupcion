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


#import "ViewController.h"
#import "Denuncia.h"

@interface FormularioDenunciaViewControllerPaso3 : ViewController <UIImagePickerControllerDelegate>
{
   
}

@property NSManagedObjectContext *contexto;
@property (weak, nonatomic) IBOutlet UIImageView *imgEvidencia;
@property (weak, nonatomic) IBOutlet UIImageView *imgEvidencia2;
@property (weak, nonatomic) IBOutlet UILabel *lblVideo;
@property (weak, nonatomic) IBOutlet UIProgressView *pbImagen1;
@property (weak, nonatomic) IBOutlet UIProgressView *pbImagen2;
@property (weak, nonatomic) IBOutlet UIProgressView *pbVideo;
@property Denuncia *denuncia;
@property (nonatomic, strong) NSMutableArray *arrImagenes;
@property (nonatomic, strong) NSString *pathVideo;
@property (weak, nonatomic) IBOutlet UILabel *lblEstatus;
@property (weak, nonatomic) IBOutlet UIButton *btnSiguientePaso;

- (IBAction)btnFotografia:(UIButton *)sender;
- (IBAction)btnVideo:(UIButton *)sender;
- (IBAction)btnSubirArchivos:(UIButton *)sender;


@end
