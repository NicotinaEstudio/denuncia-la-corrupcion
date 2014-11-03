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


#import "FormularioDenunciaViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "Denuncia.h"
#import "FormularioDenunciaViewControllerPaso2.h"
#import "ServidoresPublicosTableViewController.h"

@interface FormularioDenunciaViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnMenu;
@property NSManagedObjectContext *contexto;
@property Denuncia *denuncia;

@end

@implementation FormularioDenunciaViewController

static BOOL moved = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customSetup];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
     _contexto = [appDelegate managedObjectContext];
    
    // Obtenemos la última denuncia para validar si se se envio o se quedó pendiente de enviar
    
    
    // Creamos una nueva denuncia
    _denuncia = [NSEntityDescription insertNewObjectForEntityForName : @"Denuncia"
                                                       inManagedObjectContext : _contexto];
    _denuncia.fechaAlta = [NSDate date];
    _denuncia.estatus = 0;
    
    // Guardamos la nueva denuncia
    NSError *error;
    if (![_contexto save:&error])
        NSLog(@"Whoops, no se ha podido guardar: %@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customSetup
{
    self.txtSpNombre.delegate = self;
    self.txtSpPuesto.delegate = self;
    self.txtSpLugarTrabajo.delegate = self;
    self.txtSpDomicilioDependencia.delegate = self;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.btnMenu setTarget: revealViewController];
        [self.btnMenu setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
}

// Validamos los campos antes de mandar a la siguiente pantalla
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"paso2"])
    {
        // Validación de formulario
        if (![self formularioValido])
            return NO;
    
        _denuncia.spNombre = _txtSpNombre.text;
        _denuncia.spPuesto = _txtSpPuesto.text;
        _denuncia.spLugarTrabajo = _txtSpLugarTrabajo.text;
        _denuncia.spDomicilioDependencia = _txtSpDomicilioDependencia.text;
    
        // Guardamos la nueva denuncia
        NSError *error;
        if (![_contexto save:&error])
            NSLog(@"No se ha podido actualiza la denuncia en el paso 1: %@", [error localizedDescription]);
        else
            NSLog(@"Paso 1 actualizado");
    }
    
    return YES;
}

// Pasamos el contexto y la denuncia al siguiente paso
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"paso2"])
    {
        FormularioDenunciaViewControllerPaso2 *paso2 = [segue destinationViewController];
        paso2.contexto = _contexto;
        paso2.denuncia = _denuncia;
    }
    else if ([[segue identifier] isEqualToString:@"servidoresPublicos"])
    {
        // Agregeamos el observadir para la sección de servidor público
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(seleccionServidorPublico:)
                                                     name:@"seleccionServidorPublico" object:nil];
        
        ServidoresPublicosTableViewController *spModal = [segue destinationViewController];
        spModal.contexto = _contexto;
    }
}

// Validación del formulario
-(BOOL) formularioValido
{
    if ([_txtSpNombre.text  isEqual: @""] || [_txtSpPuesto.text  isEqual: @""] || [_txtSpLugarTrabajo.text  isEqual: @""] || [_txtSpDomicilioDependencia.text  isEqual: @""])
    {
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error:"
                                                         message:@"Todos los campos son requeridos."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alerta show];
        return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(!moved) {
        [self animateViewToPosition:self.view directionUP:YES];
        moved = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if(moved) {
        [self animateViewToPosition:self.view directionUP:NO];
    }
    moved = NO;
    return YES;
}

-(void)animateViewToPosition:(UIView *)viewToMove directionUP:(BOOL)up {
    
    const int movementDistance = -100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    viewToMove.frame = CGRectOffset(viewToMove.frame, 0, movement);
    [UIView commitAnimations];
}

// Método para notificación de selección de servidor público
- (void) seleccionServidorPublico:(NSNotification *) notification
{
    NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
        
    _txtSpNombre.text = [usrDefaults valueForKey:@"spNombre"];
    _txtSpPuesto.text = [usrDefaults valueForKey:@"spCargo"];
    _txtSpLugarTrabajo.text = [usrDefaults valueForKey:@"spTrabajo"];
    _txtSpDomicilioDependencia.text = [usrDefaults valueForKey:@"spDomicilio"];
    
}
@end
