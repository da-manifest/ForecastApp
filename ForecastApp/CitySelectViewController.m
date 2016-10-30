//
//  CitySelectViewController.m
//  ForecastApp
//
//  Created by Admin on 29/10/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//
#define ALLOWED_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define CHARACTER_LIMIT 20

#import "CitySelectViewController.h"
#import "JSONController.h"
#import "FABackAnimator.h"

@interface CitySelectViewController () <UITextFieldDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cityNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveBackTransition;

@end

@implementation CitySelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.cityNameTextField setDelegate:self];
    [self updateTextLogic];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
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

//text logic
- (void)textChanged:(NSNotification *)sender
{
    if (sender.object != self.cityNameTextField) return;
    [self updateTextLogic];
}

- (void)updateTextLogic
{
    NSString *text = [self cityNameTextField].text;
    
    if (text.length == 0)
    {
        [[self buttonSearch] setEnabled:NO];
        [[self buttonSearch] setAlpha:0.2f];
    }
    
    else
    {
        [[self buttonSearch] setEnabled:YES];
        [[self buttonSearch] setAlpha:1.0f];
    }
}

- (IBAction)searchAction:(id)sender
{
    [[self buttonSearch] setEnabled:NO];
    [[self buttonSearch] setAlpha:0.2f];
    
    [self.cityNameTextField setEnabled:NO];
    
    JSONController *jsonController = [JSONController sharedJSONController];
    [jsonController getDataForCity:[self cityNameTextField].text];
    
    NSString *request = [self cityNameTextField].text;
    NSString *response = [jsonController.responseDict objectForKey:@"name"];
    if ((jsonController.error == YES) || ([request compare:response options:NSCaseInsensitiveSearch] != NSOrderedSame))
    {
        jsonController.responseDict = nil;
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Город не найден. Попробуйте изменить запрос или проверить подключение к интернету." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        [self.cityNameTextField setEnabled:YES];
        //NSLog(@"No city found");
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALLOWED_CHARACTERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
