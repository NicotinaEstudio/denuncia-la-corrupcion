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

#import "FormularioDenunciaViewControllerPaso4b.h"
#import "AFNetworking.h"
#import "Evidencia.h"
#import "Constantes.h"

@interface FormularioDenunciaViewControllerPaso4b ()

- (IBAction)btnEnviar:(UIButton *)sender;

@end

@implementation FormularioDenunciaViewControllerPaso4b

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnEnviar:(UIButton *)sender {
    
    // Validación de formulario
    if (![self formularioValido])
        return;
    
    NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
    NSString *usuarioUID = [usrDefaults valueForKey:@"usuarioUID"]; // Obtenemos el Id único del usuario
    
    _denuncia.correoElectronico = _txtCorreoElectronico.text;
    _denuncia.usuarioUID = usuarioUID;
    
    _denuncia.nombre = @"";
    _denuncia.calle = @"";
    _denuncia.fraccionamiento = @"";
    _denuncia.delegacion = @"";
    _denuncia.lada = @"";
    _denuncia.telefono = @"";
    _denuncia.numExterior = @"";
    _denuncia.numInterno = @"";
    _denuncia.esAnonima = @YES;
    
    // Guardamos la nueva denuncia
    NSError *error;
    if (![_contexto save:&error])
        NSLog(@"No se ha podido actualiza la denuncia en el paso 2: %@", [error localizedDescription]);
    else
        NSLog(@"Paso 4 actualizado");
    
    // Enviamos la denuncia al servicio REST
    [self enviarDenuncia];
}

// Validación del formulario
-(BOOL) formularioValido
{
    if ([_txtCorreoElectronico.text  isEqual: @""])
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

-(void) enviarDenuncia
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //[manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    //[manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSLog(@"Denuncia: %@", _denuncia);
    
    //NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //[format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
    //NSDate *now = [NSDate date];
    
    // Concatenamos las evidencias
    NSString *strEvidencias = @"";
    for (Evidencia *ev in _denuncia.evidencia)
    {
        strEvidencias = [NSString stringWithFormat:@"%@|%@", strEvidencias, ev.archivo];
    }
    
    NSDictionary *parametros = @{
                                 @"spNombre" : _denuncia.spNombre,
                                 @"spPuesto" : _denuncia.spPuesto,
                                 @"spLugarTrabajo" : _denuncia.spLugarTrabajo,
                                 @"spDomicilioDependencia" : _denuncia.spDomicilioDependencia,
                                 @"lugarHechos" : _denuncia.lugarHechos,
                                 @"descripcion" : _denuncia.descripcion,
                                 @"nombre" : _denuncia.nombre,
                                 @"calle" : _denuncia.calle,
                                 @"fraccionamiento" : _denuncia.fraccionamiento,
                                 @"delegacion" : _denuncia.delegacion,
                                 @"lada" : _denuncia.lada,
                                 @"telefono" : _denuncia.telefono,
                                 @"numExterior" : _denuncia.numExterior,
                                 @"numInterior" : _denuncia.numInterno,
                                 @"esAnonima" : @YES, // Denuncia anonima
                                 @"estatus" : @1,
                                 @"correoElectronico" : _denuncia.correoElectronico,
                                 @"longitud" : _denuncia.longitud,
                                 @"latitud" : _denuncia.latitud,
                                 @"evidencias" : strEvidencias,
                                 @"usuarioUID" : _denuncia.usuarioUID,
                                 @"causa" : _denuncia.causa,
                                 };
    
    NSLog(@"Diccionario: %@", parametros);
    
    [manager POST:WebServiceDLC parameters:parametros success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self finalizaDenuncia];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void) finalizaDenuncia
{
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"¡GRACIAS POR TU DENUNCIA!"
                                                     message:@"Puedes consultar el estatus de esta en la sección de Mis Denuncias."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    
    [alerta show];
    
    // Enviamos al home
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
