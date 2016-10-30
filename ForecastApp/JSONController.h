//
//  JSONController.h
//  ForecastApp
//
//  Created by Admin on 27/10/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONController : NSObject

- (void) getDataForLatitude:(float)latitude andLongitude:(float)longitude;
- (void) getDataForCity:(NSString *)cityName;
@property (nonatomic, retain) NSDictionary *responseDict;
@property (nonatomic) BOOL error;
+ (id) sharedJSONController;

@end
