//
//  PHPulsingHaloLayer.m
//  PulsingHalo
//
//  Created by QinMingChuan on 14-9-2.
//  Copyright (c) 2014年 413132340@qq.com. All rights reserved.
//

#import "PHPulsingHaloLayer.h"

#define kAnimationKey @"pulsingHalo"

@interface PHPulsingHaloLayer()

@property (strong) CAAnimationGroup *animationGroup;

@end

@implementation PHPulsingHaloLayer

- (void)dealloc
{
    [self removeAnimationForKey:kAnimationKey];
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.contentsScale = [UIScreen mainScreen].scale;
        self.opacity = 0;
        
        // default
        self.radius = 60;
        self.animationDuration = 2;
        self.pulseInterval = 0;
        self.backgroundColor = [[UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1] CGColor];
    }
    return self;
}

- (void)beginAnimationAfterDelay:(NSTimeInterval)afterDelay
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [self setupAnimationGroup];
    });
    
    if(afterDelay == 0)
    {
        [self beginMyAnimation];
    }
    else
    {
        [self performSelector:@selector(beginMyAnimation) withObject:nil afterDelay:afterDelay];
    }
}

- (void)beginMyAnimation
{
    if(!self.animationGroup)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            
            [self setupAnimationGroup];
            
            if(self.pulseInterval != INFINITY)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    [self addAnimation:self.animationGroup forKey:kAnimationKey];
                });
            }
        });
    }
    else
    {
        if(self.pulseInterval != INFINITY) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [self addAnimation:self.animationGroup forKey:kAnimationKey];
            });
        }
    }
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    
    CGPoint tempPos = self.position;
    
    CGFloat diameter = self.radius * 2;
    
    self.bounds = CGRectMake(0, 0, diameter, diameter);
    self.cornerRadius = self.radius;
    self.position = tempPos;
}

//关闭动画
- (void)closeAnimation
{
    [self removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginMyAnimation) object:nil];
}

- (void)setupAnimationGroup
{
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    self.animationGroup = [CAAnimationGroup animation];
    self.animationGroup.duration = self.animationDuration + self.pulseInterval;
    self.animationGroup.repeatCount = self.animationTimes > 0 ? self.animationTimes : INFINITY;
    self.animationGroup.removedOnCompletion = NO;
    self.animationGroup.timingFunction = defaultCurve;
    self.animationGroup.delegate = self;
    
    //关键帧动画 放大
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.duration = self.animationDuration;
    scaleAnimation.values = @[@0.9, @1.2, @1.5];
    scaleAnimation.keyTimes = @[@0, @0.5, @1];
//    scaleAnimation.values = @[@0, @0.4, @1.5];
//    scaleAnimation.keyTimes = @[@0, @0.2, @1];
    scaleAnimation.removedOnCompletion = NO;
    
    //关键帧动画 透明度和时间复合
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = self.animationDuration;
    opacityAnimation.values = @[@1, @0.8,@0.6,@0.4,@0.2, @0];
    opacityAnimation.keyTimes = @[@0, @0.2, @0.4,@0.6,@0.8,@1];
//    opacityAnimation.values = @[@1, @1, @0.3, @0];
//    opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @1];
    opacityAnimation.removedOnCompletion = NO;
    
    NSArray *animations = @[scaleAnimation, opacityAnimation];
    
    self.animationGroup.animations = animations;
    
    [self setNeedsDisplay];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag)
    {
        [self removeAnimationForKey:kAnimationKey];
        [self removeFromSuperlayer];
    }
}

@end
