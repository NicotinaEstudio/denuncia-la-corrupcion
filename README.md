
README Denuncia La Corrupción
============

El presente proyecto es un prototipo funcional para la final del Reto **#DenunciaLaCorrupcion** y es desarrollado por [Nicotina Estudio](http://www.nicotinaestudio.com). 

##Descripción
**Denuncia La Corrupción** es una aplicación móvil que permite a los ciudadanos hacer denuncias de servidores publicos de forma fácil, rápida y segura.

##Tecnología

La APP móvil de este protitipo está desarrollada para iPhone (IOS 7 y 8). Utilizamos Ccocoapods como manejador de dependencias para manter el código más limpio y fácil de utilizar.

En su Backend **Denuncia La Corrupción** está desarrollado con Java utilizando el framework Spring MVC, una base de datos PostgreSQL, se utliza Heroku como servidor de aplicaciones, Amazon S3 para el alamacenamiento de las fotografías y video y Amazon SNS para las notificaciones PUSH.

##Funcionamiento
**Denuncia La Corrupción** realiza la denuncia del servidor público mediante la aplicación móvil de forma sencilla, seleccionando de una lista al servidor público que se va a denunciar, seleccionando de una lista la causa por la que se va a denuncias al servidor público y adjuntando evidencias (imagen, video y audio). La denuncia se puede hacer de forma anónima o agregando sus dados personales.

Desde el administrador (Backend) se da seguimiento a la denuncia pudiendo el admisnitrador del sistema agregar anotaciones y cambiar el estatus de la misma enviandocele automáticamente notifiacciones al usuario mediate Notificaciones Push y correo electrónico sobre el cambio de estatus de su denuncia.

Al darce de alta una denuncia se genera un código QR el cual puede ser escaneado desde la APP de denuncia la corrupción para darle seguimiento a la denuncia de forma rápida.

##Dependencias
**IOS**
- AFNetworking
- AWSiOSSDKv2
- AWSCognitoSync
- SWRevealViewController 2.3.0
- BlurryModalSegue
- Google-Maps-iOS-SDK

**BACKEND**
- Spring MVC 4.1.1.RELEASE
- Hibernate 3.6.10.Final
- PostgreSQL 9.1-901-1.jdbc4
- jackson JSON processor 2.3.0
- Amazon AWS 1.9.2
- Zxing
- Maven

##Instalación / Configuración 
La forma más fácil es importa este repositorio desde el IDE eclipse mediante el plugin de heroku disponible en la siguiente URL: [http://eclipse-plugin.herokuapp.com](http://eclipse-plugin.herokuapp.com)

Para publicar el sitio en Heroku:
Como todas las dependencias se encuentran en el archívo pom.xml solo se requieren dos pasos para publicar la APP en Heroku.
- Crear una APP en heroku ($heroku create)
- Publicar hacia la APP ($git push heroku master)

##Screenshots
![alt tag](#)

##Demo
- [http://denuncia-la-corrupcion.herokuapp.com](http://denuncia-la-corrupcion.herokuapp.com)

##¿Preguntas o problemas? 
Mantenemos la conversación del proyecto en nuestra página de problemas [issues] (https://github.com/NicotinaEstudio/denuncia-la-corrupcion/issues). Si usted tiene cualquier otra pregunta, nos puede contactar por correo <soporte@nicotinaestudio.mx>.

##Contribuye
Para contribuir en el proyecto **Catalogarte** haga click en el siguiente enlace ([Contribuir](#))

##Empresa

**Nuestra Misión**

> *Solucionar de forma creativa e innovadora problemas sociales y empresariales que sobrepasen sus expectativas y generen experiencias excepcionales. por [Nicotina Estudio](http://www.nicotinaestudio.com)*

##Licencia

 Copyright 2014 Nicotina Estudio

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
