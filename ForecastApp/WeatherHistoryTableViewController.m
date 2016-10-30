//
//  WeatherHistoryTableViewController.m
//  ForecastApp
//
//  Created by Admin on 27/10/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import "WeatherHistoryTableViewController.h"
#import "DataManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "FAWeatherData+CoreDataClass.h"
#import "FABackAnimator.h"

@interface WeatherHistoryTableViewController () <UITableViewDelegate, UITableViewDataSource,  UINavigationControllerDelegate>

@property (strong, readwrite, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveBackTransition;

@end

@implementation WeatherHistoryTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fetchedResultsController = [FAWeatherData MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:nil ascending:NO];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
    [self.tableView.backgroundView setContentMode:UIViewContentModeCenter];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    
    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
    popRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:popRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.navigationController.delegate == self)
    {
        self.navigationController.delegate = nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveBackTransition;
}

//animation
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController*)fromVC toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPop)
    {
        return [[FABackAnimator alloc] init];
    }
    return nil;
}

#pragma mark UIGestureRecognizer handler

- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer
{
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.frame.size.width * 100.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.interactiveBackTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        [self.interactiveBackTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        if (progress > 0.5)
        {
            [self.interactiveBackTransition finishInteractiveTransition];
        }
        else
        {
            [self.interactiveBackTransition cancelInteractiveTransition];
        }
        self.interactiveBackTransition = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> info = self.fetchedResultsController.sections[section];
    return [info numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    FAWeatherData *weatherData = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:weatherData.dateCreated];
    
    [cell.detailTextLabel setText:dateString];
    
    NSDictionary *tempDict = weatherData.weatherData;
    NSString *conditions = [[tempDict objectForKey:@"weather"] [0] objectForKey:@"description"];
    NSString *tempString = [NSString stringWithFormat:@"%.0f°   %@", [[[tempDict objectForKey:@"main"] objectForKey:@"temp"] floatValue], [conditions capitalizedString]];
    
    [cell.textLabel setText:tempString];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
