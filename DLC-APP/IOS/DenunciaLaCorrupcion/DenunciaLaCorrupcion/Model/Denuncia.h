//
//  Denuncia.h
//  DenunciaLaCorrupcion
//
//  Created by Isaac Hernández Morfín on 21/10/14.
//  Copyright (c) 2014 Nicotina Estudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Evidencia;

@interface Denuncia : NSManagedObject

@property (nonatomic, retain) NSString * calle;
@property (nonatomic, retain) NSString * correoElectronico;
@property (nonatomic, retain) NSString * delegacion;
@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSNumber * esAnonima;
@property (nonatomic, retain) NSNumber * estatus;
@property (nonatomic, retain) NSDate * fechaAlta;
@property (nonatomic, retain) NSString * fraccionamiento;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * lada;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSNumber * longitud;
@property (nonatomic, retain) NSString * lugarHechos;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * numExterior;
@property (nonatomic, retain) NSString * numInterno;
@property (nonatomic, retain) NSString * spDomicilioDependencia;
@property (nonatomic, retain) NSString * spLugarTrabajo;
@property (nonatomic, retain) NSString * spNombre;
@property (nonatomic, retain) NSString * spPuesto;
@property (nonatomic, retain) NSString * telefono;
@property (nonatomic, retain) NSString * usuarioUID;
@property (nonatomic, retain) NSString * causa;
@property (nonatomic, retain) NSSet *evidencia;
@end

@interface Denuncia (CoreDataGeneratedAccessors)

- (void)addEvidenciaObject:(Evidencia *)value;
- (void)removeEvidenciaObject:(Evidencia *)value;
- (void)addEvidencia:(NSSet *)values;
- (void)removeEvidencia:(NSSet *)values;

@end
