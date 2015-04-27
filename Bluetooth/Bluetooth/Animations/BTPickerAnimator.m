//
//  BTPickerAnimator.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/27/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTPickerAnimator.h"
#import "BTTemperaturePickerViewController.h"

@interface BTPickerAnimator ()

@end

@implementation BTPickerAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.presenting) {
        [self presentingWithTransitionContext:transitionContext];
    } else {
        [self dismissingWithTransitionContext:transitionContext];
    }
}

- (void)presentingWithTransitionContext:(id < UIViewControllerContextTransitioning >)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    toViewController.view.frame = containerView.bounds;
    
    toViewController.view.layer.opacity = 0;
    [containerView addSubview:toViewController.view];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.springSpeed = 16;
    scaleAnimation.completionBlock = ^(POPAnimation *animtion, BOOL finished) {
        [transitionContext completeTransition:finished];
    };
    
    POPBasicAnimation *fadeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    fadeAnimation.fromValue = @(0);
    fadeAnimation.toValue = @(1);
    fadeAnimation.duration = [self transitionDuration:transitionContext] * 0.7f;
    
    [toViewController.view.layer pop_addAnimation:scaleAnimation forKey:@"ScaleAnimation"];
    [toViewController.view.layer pop_addAnimation:fadeAnimation forKey:@"FadeAnimation"];
}

- (void)dismissingWithTransitionContext:(id < UIViewControllerContextTransitioning > )transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    POPBasicAnimation *translateAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
    translateAnimation.fromValue = @(0);
    translateAnimation.toValue = @([transitionContext containerView].bounds.size.height * 0.7f);
    translateAnimation.duration = [self transitionDuration:transitionContext];
    translateAnimation.completionBlock = ^(POPAnimation *animation, BOOL finished) {
        [transitionContext completeTransition:finished];
    };
    
    POPBasicAnimation *fadeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    fadeAnimation.fromValue = @(1);
    fadeAnimation.toValue = @(0);
    fadeAnimation.duration = [self transitionDuration:transitionContext];
    [fromViewController.view.layer pop_addAnimation:translateAnimation forKey:@"TranslateAnimation"];
    [fromViewController.view.layer pop_addAnimation:fadeAnimation forKey:@"FadeAnimation"];
    
    UIView *blurView = [[transitionContext containerView] viewWithTag:0];
    if (blurView) {
        POPBasicAnimation *fadeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        fadeAnimation.fromValue = @(1);
        fadeAnimation.toValue = @(0);
        fadeAnimation.duration = [self transitionDuration:transitionContext] - 0.2f;
        fadeAnimation.beginTime = CACurrentMediaTime() + 0.2f;
        [blurView.layer pop_addAnimation:fadeAnimation forKey:@"BlurViewFadeAnimation"];
    }
}

@end
