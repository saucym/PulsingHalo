//
//  PHPulsingHaloLayer.h
//  PulsingHalo
//  脉冲动画层
//  Created by QinMingChuan on 14-9-2.
//  Copyright (c) 2014年 413132340@qq.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PHPulsingHaloLayer : CALayer

@property (nonatomic) CGFloat radius;                   //半径大小 default:60pt
@property (nonatomic) NSTimeInterval animationDuration; //持续时间 default:3s
@property (nonatomic) NSTimeInterval pulseInterval;     //暂停时间 default is 0s

@property (nonatomic) NSInteger animationTimes;//重复次数 0表示无限次 default 0

//! @brief 开始动画并指定延迟开始时间
- (void)beginAnimationAfterDelay:(NSTimeInterval)afterDelay;

//! @brief 关闭动画
- (void)closeAnimation;

@end
