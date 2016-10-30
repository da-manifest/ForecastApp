//
//  WeatherViewController.m
//  ForecastApp
//
//  Created by Admin on 27/10/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import "WeatherViewController.h"
#import "LocationManagerController.h"
#import "JSONController.h"
#import "DataManager.h"
#import "FAAnimator.h"

@interface WeatherViewController () <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cityName;
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UILabel *conditions;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescription;
@property (strong, nonatomic) JSONController *jsonController;
@property (strong, nonatomic) LocationManagerController *locationManagerController;

@end

@implementation WeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.jsonController = [JSONController sharedJSONController];
    
    //get weather data for current location
    self.locationManagerController = [[LocationManagerController alloc] init];
    [self.locationManagerController getCurrentLocation];
    if ((self.locationManagerController.latitude == 0) && (self.locationManagerController.longitude == 0))
    {
        self.jsonController.responseDict = nil;
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Не удалось определить текущее местоположение. Включите геолокацию и перезапустите приложение." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self.jsonController getDataForLatitude:self.locationManagerController.latitude andLongitude:self.locationManagerController.longitude];
    
    if (self.jsonController.responseDict == nil)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Не удалось связаться с сервером. Проверьте подключение к интернету." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    //local notification
    DataManager *dataManager = [[DataManager alloc] init];
    [self checkChangeBetweenCurrentTemperature:self.jsonController.responseDict andPreviousTemperature:[dataManager loadLastWeatherData]];
    
    //saving weather data
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    [dataManager saveData:self.jsonController.responseDict dateCreated:date];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //UI update
    if (self.jsonController.responseDict != nil)
    {  
    [_cityName setTitle: [self.jsonController.responseDict objectForKey:@"name"] forState:UIControlStateNormal];
        NSString *capitalizedStr = [[self.jsonController.responseDict objectForKey:@"weather"] [0] objectForKey:@"description"];
        _weatherDescription.text = [capitalizedStr capitalizedString];
        _currentTemp.text = [NSString stringWithFormat:@"%.0f°", [[[self.jsonController.responseDict objectForKey:@"main"] objectForKey:@"temp"] floatValue]];
        _conditions.text = [NSString stringWithFormat:@"%.0f %%   %.0f m/s",
                        [[[self.jsonController.responseDict objectForKey:@"main"] objectForKey:@"humidity"] floatValue],
                        [[[self.jsonController.responseDict objectForKey:@"wind"] objectForKey:@"speed"] floatValue]];
    }
    NSLog(@"%@", _jsonController.responseDict);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
    if (self.navigationController.delegate == self)
    {
        self.navigationController.delegate = nil;
    }
}

- (void) checkChangeBetweenCurrentTemperature: (NSDictionary *)currentWeatherData andPreviousTemperature: (FAWeatherData *)previousWeatherData
{
    float currentTemp, previousTemp;
    
    NSDictionary *tempDict = previousWeatherData.weatherData;
    previousTemp = [[[tempDict objectForKey:@"main"] objectForKey:@"temp"] floatValue];
    NSLog(@"previousTemp: %f", previousTemp);

    tempDict = currentWeatherData;
    currentTemp = [[[tempDict objectForKey:@"main"] objectForKey:@"temp"] floatValue];
    NSLog(@"currentTemp: %f", currentTemp);

    if ((previousTemp > currentTemp) && (fabsf(currentTemp - previousTemp) > 3)) {
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        localNotification.alertBody = [NSString stringWithFormat:@"Текущая температура изменилась с %.0f° до %.0f°", previousTemp, currentTemp];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

//animated transition
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController*)fromVC toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush)
    {
        return [[FAAnimator alloc] init];
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
