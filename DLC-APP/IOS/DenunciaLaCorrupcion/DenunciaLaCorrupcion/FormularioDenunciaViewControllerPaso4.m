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

#import "FormularioDenunciaViewControllerPaso4.h"
#import "FormularioDenunciaViewControllerPaso4a.h"
#import "FormularioDenunciaViewControllerPaso4b.h"

@interface FormularioDenunciaViewControllerPaso4 ()

@end

@implementation FormularioDenunciaViewControllerPaso4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Pasamos el contexto al siguiente paso
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"paso4a"])
    {
        FormularioDenunciaViewControllerPaso4a *paso4a = [segue destinationViewController];
        paso4a.contexto = _contexto;
        paso4a.denuncia = _denuncia;
    }
    else if([[segue identifier] isEqualToString:@"paso4b"])
    {
        FormularioDenunciaViewControllerPaso4b *paso4b = [segue destinationViewController];
        paso4b.contexto = _contexto;
        paso4b.denuncia = _denuncia;
    }
}


@end
