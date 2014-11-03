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
#import "AppDelegate.h"
#import "Denuncia.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import "Constantes.h"

@interface ViewController ()

@property (nonatomic) IBOutlet UIBarButtonItem *btnMenu;

@end

@implementation ViewController

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    [self customSetup];
    
    //[self pruebaServicio];
}

- (void)pruebaServicio
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *parametros = @{
                                 @"calle" : @"",
                                 @"causa" : @"Desacato a la autoridad de sus superiores jerárquicos",
                                 @"correoElectronico" : @"hola@nicotinaestudio.mx",
                                 @"delegacion" : @"",
                                 @"descripcion" : @"A\n",
                                 @"esAnonima" : @1,
                                 @"estatus" : @1,
                                 @"evidencias" : @"|6FF93E9A-3468-42E7-93BC-5F467A7EBFA1.jpg|6CE69B51-FEEA-400A-90AA-52F6B5158304.mp4|4610548A-970E-49D3-88FC-1DCF312C64D8.jpg",
                                 @"fraccionamiento" : @"",
                                 @"lada" : @"",
                                 @"latitud" : @0,
                                 @"longitud" : @0,
                                 @"lugarHechos" : @"a",
                                 @"nombre" : @"",
                                 @"numExterior" : @"",
                                 @"numInterior" : @"",
                                 @"spDomicilioDependencia" : @"AVENIDA HIDALGO 77 Col.GUERRERO CUAUHTEMOC, Distrito Federal México, C.P. 06300 ",
                                 @"spLugarTrabajo" : @"ADMINISTRACIÓN DE NORMATIVIDAD INTERNACIONAL 3 ",
                                 @"spNombre" : @"ARTURO ALEJANDRO  PEREZ  SANCHEZ ",
                                 @"spPuesto" : @"ADMINISTRACIÓN DE NORMATIVIDAD INTERNACIONAL 3 ",
                                 @"telefono" : @"",
                                 @"usuarioUID" : @"20a87f28b4f9a016882f449c936bfef92e7ee77640e605a6f18863e6475434fd",
                                 };
    
    NSLog(@"Diccionario: %@", parametros);
    
    [manager POST:WebServiceDLC parameters:parametros success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)customSetup
{
    // Configuración del side menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.btnMenu setTarget: self.revealViewController];
        [self.btnMenu setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}
@end
