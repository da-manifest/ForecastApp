//
//  LocationManagerController.h
//  ForecastApp
//
//  Created by Admin on 27/10/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManagerController : NSObject

- (void) getCurrentLocation;
@property (nonatomic) float latitude, longitude;

@end
