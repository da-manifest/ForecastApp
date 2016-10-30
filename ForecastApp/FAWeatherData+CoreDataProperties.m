//
//  FAWeatherData+CoreDataProperties.m
//  ForecastApp
//
//  Created by Admin on 27/10/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import "FAWeatherData+CoreDataProperties.h"

@implementation FAWeatherData (CoreDataProperties)

+ (NSFetchRequest<FAWeatherData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FAWeatherData"];
}

@dynamic dateCreated;
@dynamic weatherData;

@end
