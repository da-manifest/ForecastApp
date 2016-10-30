//
//  LocationManagerController.m
//  ForecastApp
//
//  Created by Admin on 27/10/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import "LocationManagerController.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManagerController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LocationManagerController

- (void) getCurrentLocation
{
    @try
    {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        [self.locationManager startUpdatingLocation];
        [NSThread sleepForTimeInterval:2.0f]; //TODO:УБРАТЬ!!!
        _latitude = self.locationManager.location.coordinate.latitude;
        _longitude = self.locationManager.location.coordinate.longitude;
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception: %@", exception);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}


@end
