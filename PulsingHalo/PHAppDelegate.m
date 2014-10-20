//
//  PHAppDelegate.m
//  PulsingHalo
//
//  Created by QinMingChuan on 14-9-2.
//  Copyright (c) 2014年 413132340@qq.com. All rights reserved.
//

#import "PHAppDelegate.h"
#import "PHPulsingHaloLayer.h"

@implementation PHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:self.window.bounds];
    aLabel.numberOfLines = 0;
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.text = @"点我\n或者拖动";
    [self.window addSubview:aLabel];
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [clearButton setTitle:@"clearn" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [clearButton addTarget:self action:@selector(clearn) forControlEvents:UIControlEventTouchUpInside];
    clearButton.center = CGPointMake(self.window.bounds.size.width - 50, 40);
    [self.window addSubview:clearButton];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)clearn
{
    NSArray *sublayers = [self.window.layer.sublayers mutableCopy];
    for(PHPulsingHaloLayer *obj in sublayers)
    {
        if([obj isKindOfClass:[PHPulsingHaloLayer class]] && obj.superlayer == self.window.layer)
        {
            [obj closeAnimation];
            [obj removeFromSuperlayer];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint tPoint = [touch locationInView:self.window];
    
    [self addLaberWithPoint:tPoint count:0];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint tPoint = [touch locationInView:self.window];
    
    [self addLaberWithPoint:tPoint count:1];
}

- (void)addLaberWithPoint:(CGPoint)tPoint count:(NSInteger)count
{
    PHPulsingHaloLayer *layer = [[PHPulsingHaloLayer alloc] init];
    layer.animationDuration = 0.5;
    layer.radius = 30;
    layer.animationTimes = count;
    layer.position = tPoint;
    [self.window.layer addSublayer:layer];
    [layer beginAnimationAfterDelay:0];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
