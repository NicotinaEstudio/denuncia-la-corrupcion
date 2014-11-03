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

@interface FormularioDenunciaViewControllerPaso4a : ViewController

@property (weak, nonatomic) IBOutlet UITextField *txtNombre;
@property (weak, nonatomic) IBOutlet UITextField *txtCalle;
@property (weak, nonatomic) IBOutlet UITextField *txtNumeroExterior;
@property (weak, nonatomic) IBOutlet UITextField *txtNumeroInterior;
@property (weak, nonatomic) IBOutlet UITextField *txtColonia;
@property (weak, nonatomic) IBOutlet UITextField *txtMunicipio;
@property (weak, nonatomic) IBOutlet UITextField *txtLada;
@property (weak, nonatomic) IBOutlet UITextField *txtTelefono;
@property (weak, nonatomic) IBOutlet UITextField *txtCorreoElectronico;
@property NSManagedObjectContext *contexto;
@property Denuncia *denuncia;

- (IBAction)btnEnviar:(UIButton *)sender;

@end
