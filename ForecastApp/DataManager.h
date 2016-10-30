//
//  DataManager.h
//  ForecastApp
//
//  Created by Admin on 27/10/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FAWeatherData+CoreDataClass.h"

@interface DataManager : NSObject

- (void) saveData:(NSDictionary *)dictionary dateCreated:(NSDate *)date;
- (FAWeatherData *) loadLastWeatherData;
@property (strong, nonatomic) FAWeatherData *data;

@end
