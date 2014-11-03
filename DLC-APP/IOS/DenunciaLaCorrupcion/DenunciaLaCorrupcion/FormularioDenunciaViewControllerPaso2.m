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


#import "FormularioDenunciaViewControllerPaso2.h"
#import "FormularioDenunciaViewControllerPaso3.h"

@interface FormularioDenunciaViewControllerPaso2 ()

@end

@implementation FormularioDenunciaViewControllerPaso2

static BOOL moved = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtSpDescripcion.delegate = self;
    self.txtSpLugarHechos.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Validamos los campos antes de mandar a la siguiente pantalla
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // Si va a cambiar al paso 3 actualizamos
    if ([identifier isEqualToString:@"paso3"])
    {
        // Validación de formulario
        if (![self formularioValido])
            return NO;
    
        _denuncia.lugarHechos = _txtSpLugarHechos.text;
        _denuncia.descripcion = _txtSpDescripcion.text;
        _denuncia.causa = _lblCausaDenuncia.text;
    
        // Guardamos la nueva denuncia
        NSError *error;
        if (![_contexto save:&error])
            NSLog(@"No se ha podido actualiza la denuncia en el paso 2: %@", [error localizedDescription]);
        else
            NSLog(@"Paso 2 actualizado");
    }
    
    return YES;
}

// Pasamos el contexto al siguiente paso
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"paso3"])
    {
        FormularioDenunciaViewControllerPaso3 *paso3 = [segue destinationViewController];
        paso3.contexto = _contexto;
        paso3.denuncia = _denuncia;
    }
    else
    {
        // Modal selección de causa de denuncia
        
        // Agregeamos el observadir para la sección de dnuncia
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(seleccionCausaNotificacion:)
                                                     name:@"seleccionCausaNotificacion" object:nil];
    }
}

// Validación del formulario
-(BOOL) formularioValido
{
    if ([_txtSpLugarHechos isEqual: @""] || [_txtSpDescripcion.text isEqual: @""] || [_lblCausaDenuncia isEqual: @"Haz click en el botón Seleccionar >"])
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

// Método para notificación de selección de causa de denuncia
- (void) seleccionCausaNotificacion:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"seleccionCausaNotificacion"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        // Actualizamos el label de la causa de la denuncia
        if(![[userInfo objectForKey:@"strCausaDenuncia"] isEqual:@""])
           _lblCausaDenuncia.text = [userInfo objectForKey:@"strCausaDenuncia"];
    }
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
@end
