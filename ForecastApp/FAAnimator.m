//
//  FAAnimator.m
//  ForecastApp
//
//  Created by Admin on 30/10/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import "FAAnimator.h"

@implementation FAAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController   = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    
    CGRect endPos = toViewController.view.frame;
    
    CGRect startPos = fromViewController.view.frame;
    startPos.origin.x =  - startPos.size.width;
    toViewController.view.frame = startPos;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.9 options:0 animations:^{
        toViewController.view.frame = endPos;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
