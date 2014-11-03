//
//  ServidorPublico.h
//  DenunciaLaCorrupcion
//
//  Created by Isaac Hernández Morfín on 29/10/14.
//  Copyright (c) 2014 Nicotina Estudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ServidorPublico : NSManagedObject

@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * cargo;
@property (nonatomic, retain) NSString * trabajo;
@property (nonatomic, retain) NSString * domicilio;

@end
