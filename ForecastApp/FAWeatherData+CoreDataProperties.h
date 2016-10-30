//
//  FAWeatherData+CoreDataProperties.h
//  ForecastApp
//
//  Created by Admin on 27/10/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import "FAWeatherData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FAWeatherData (CoreDataProperties)

+ (NSFetchRequest<FAWeatherData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *dateCreated;
@property (nullable, nonatomic, retain) NSObject *weatherData;

@end

NS_ASSUME_NONNULL_END
