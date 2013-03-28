//
//  AppDelegate.m
//  GfanSDKDemo
//
//  Created by Emck on 2/1/13.
//  Copyright (c) 2013 mAPPn. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];      // Hidden StatusBar

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    return YES;
}


//------------------------GfanSDK for iOS------------- Add -----
// 支付宝支付后的回调,接入时必须复制到正式项目
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GfanSDKAliPayNotification" object:url];
	return YES;
}
//------------------------GfanSDK for iOS------------- End -----


- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end