//
//  JSONController.m
//  ForecastApp
//
//  Created by Admin on 27/10/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import "JSONController.h"
#import <UIKit/UIKit.h>

@implementation JSONController

- (void) getDataForLatitude:(float)latitude andLongitude:(float)longitude
{
    @try
    {
        NSString *url_string = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=metric&appid=11642b38f918ea6ae6702f239388c89d", latitude, longitude];
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
        NSError *errorJson = nil;
        _responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
        _error = NO;
    }
    @catch (NSException *exception)
    {
        _error = YES;
        NSLog(@"Exception: %@", exception);
    }
}

- (void) getDataForCity:(NSString *)cityName
{
    @try
    {
        NSString *url_string = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/weather?q=%@&units=metric&appid=11642b38f918ea6ae6702f239388c89d", cityName];
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
        NSError *errorJson = nil;
        _responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
        _error = NO;
    }
    @catch (NSException *exception)
    {
        _error = YES;
        NSLog(@"Exception: %@", exception);
    }
    
    //NSLog(@"responseDict=%@",_responseDict);
}

+ (id) sharedJSONController
{
    static JSONController *sharedJSONController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedJSONController = [[self alloc] init];
    });
    return sharedJSONController;
}

- (id) init
{
    if (self = [super init])
    {
        _responseDict = nil;
    }
    return self;
}

- (void) dealloc
{

}

@end
