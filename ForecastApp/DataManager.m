//
//  DataManager.m
//  ForecastApp
//
//  Created by Admin on 27/10/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import "DataManager.h"
#import "JSONController.h"
#import "FAWeatherData+CoreDataClass.h"
#import <MagicalRecord/MagicalRecord.h>

@interface DataManager ()

@property (strong, readwrite, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation DataManager

- (void) saveData:(NSDictionary *)dictionary dateCreated:(NSDate *)date
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        FAWeatherData *data = [FAWeatherData MR_createEntityInContext:localContext];
        data.weatherData = dictionary;
        data.dateCreated = date;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        NSLog(@"Saving done.");
    }];
}

- (FAWeatherData *) loadLastWeatherData
{
    _data = [FAWeatherData MR_findFirstOrderedByAttribute:@"dateCreated" ascending:NO];
    NSLog(@"Loading done.");
    return _data;
}

@end
