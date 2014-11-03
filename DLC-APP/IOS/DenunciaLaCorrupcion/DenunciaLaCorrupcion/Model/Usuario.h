//
//  Usuario.h
//  DenunciaLaCorrupcion
//
//  Created by Isaac Hernández Morfín on 21/10/14.
//  Copyright (c) 2014 Nicotina Estudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Usuario : NSManagedObject

@property (nonatomic, retain) NSString * correoElectronico;
@property (nonatomic, retain) NSNumber * esRegistrado;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSNumber * longitud;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * uid;

@end
