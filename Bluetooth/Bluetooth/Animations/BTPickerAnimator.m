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
    
    if ([toViewController isKindOfClass:[BTTemperaturePickerViewController class]]) {
        BTTemperaturePickerViewController *pickerViewController = (BTTemperaturePickerViewController *)toViewController;
        [pickerViewController.view setNeedsLayout];
        [pickerViewController.view layoutIfNeeded];
        
        CGFloat originalValue = pickerViewController.pickerContainer.layer.position.y;
        pickerViewController.pickerContainer.layer.position = CGPointMake(pickerViewController.pickerContainer.layer.position.x, originalValue + pickerViewController.pickerContainer.layer.bounds.size.height);
        POPSpringAnimation *translateAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        translateAnimation.fromValue = @(originalValue + pickerViewController.pickerContainer.layer.bounds.size.height);
        translateAnimation.toValue = @(originalValue);
        translateAnimation.springSpeed = 16.0;
        translateAnimation.dynamicsFriction = 28.0;
        [pickerViewController.pickerContainer.layer pop_addAnimation:translateAnimation forKey:@"PickerContainerTranslateAnimation"];
        
        pickerViewController.pickerContainer.layer.opacity = 0.0f;
        POPBasicAnimation *fadeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        fadeAnimation.fromValue = @(0);
        fadeAnimation.toValue = @(1);
        fadeAnimation.duration = [self transitionDuration:transitionContext] * 0.6f;
        [pickerViewController.pickerContainer.layer pop_addAnimation:fadeAnimation forKey:@"PickerContainerFadeAnimation"];
        
        CGSize scaleOrigin = CGSizeMake(2.0, 2.0);
        pickerViewController.topContainer.layer.transform = CATransform3DMakeScale(scaleOrigin.width, scaleOrigin.height, 1.0);
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:scaleOrigin];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.duration = [self transitionDuration:transitionContext];
        [pickerViewController.topContainer.layer pop_addAnimation:scaleAnimation forKey:@"TopContainerScaleAnimation"];
        
        pickerViewController.topContainer.layer.backgroundColor = [UIColor clearColor].CGColor;
        POPBasicAnimation *colorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
        colorAnimation.fromValue = [UIColor clearColor];
        colorAnimation.toValue = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        colorAnimation.duration = [self transitionDuration:transitionContext] * 0.8f;
        [pickerViewController.topContainer.layer pop_addAnimation:colorAnimation forKey:@"TopContainerColorTranslateAnimation"];
    }

    POPBasicAnimation *dummyAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
    dummyAnimation.fromValue = [UIColor clearColor];
    dummyAnimation.toValue = [UIColor clearColor];
    dummyAnimation.duration = [self transitionDuration:transitionContext];
    dummyAnimation.completionBlock = ^(POPAnimation *animtion, BOOL finished) {
        [transitionContext completeTransition:finished];
    };
    
    [containerView addSubview:toViewController.view];
    [toViewController.view.layer pop_addAnimation:dummyAnimation forKey:@"DummyAnimation"];
}

- (void)dismissingWithTransitionContext:(id < UIViewControllerContextTransitioning > )transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if ([fromViewController isKindOfClass:[BTTemperaturePickerViewController class]]) {
        BTTemperaturePickerViewController *pickerViewController = (BTTemperaturePickerViewController *)fromViewController;
        [pickerViewController.view setNeedsLayout];
        [pickerViewController.view layoutIfNeeded];
        
        POPBasicAnimation *translateAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        translateAnimation.fromValue = @(pickerViewController.pickerContainer.layer.position.y);
        translateAnimation.toValue = @(pickerViewController.pickerContainer.layer.position.y + pickerViewController.pickerContainer.layer.bounds.size.height);
        translateAnimation.duration = [self transitionDuration:transitionContext];
        [pickerViewController.pickerContainer.layer pop_addAnimation:translateAnimation forKey:@"PickerContainerTranslateAnimation"];
        
        CGSize scaleOrigin = CGSizeMake(3.0, 3.0);
        pickerViewController.topContainer.layer.transform = CATransform3DMakeScale(scaleOrigin.width, scaleOrigin.height, 1.0);
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:scaleOrigin];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(2.0, 2.0)];
        scaleAnimation.duration = [self transitionDuration:transitionContext];
        [pickerViewController.topContainer.layer pop_addAnimation:scaleAnimation forKey:@"TopContainerScaleAnimation"];
    }
    
    POPBasicAnimation *fadeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    fadeAnimation.fromValue = @(1);
    fadeAnimation.toValue = @(0);
    fadeAnimation.beginTime = CACurrentMediaTime() + 0.2f;
    fadeAnimation.duration = [self transitionDuration:transitionContext] - 0.2f;
    fadeAnimation.completionBlock = ^(POPAnimation *animtion, BOOL finished) {
        [transitionContext completeTransition:finished];
    };
    [fromViewController.view.layer pop_addAnimation:fadeAnimation forKey:@"FadeAnimation"];
}

@end
