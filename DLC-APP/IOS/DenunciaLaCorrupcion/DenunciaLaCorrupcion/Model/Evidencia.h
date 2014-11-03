//
//  Evidencia.h
//  DenunciaLaCorrupcion
//
//  Created by Isaac Hernández Morfín on 21/10/14.
//  Copyright (c) 2014 Nicotina Estudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Denuncia;

@interface Evidencia : NSManagedObject

@property (nonatomic, retain) NSString * archivo;
@property (nonatomic, retain) NSNumber * estatus;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * tipo;
@property (nonatomic, retain) Denuncia *denuncia;

@end
