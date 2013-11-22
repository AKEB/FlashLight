//
//  AppDelegate_iPhone.m
//  FlashLight
//
//  Created by AKEB on 8/26/10.
//  Copyright AKEB.RU 2010. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "MainViewController.h"
#import "SettingsViewController.h"

@implementation AppDelegate_iPhone

@synthesize window;
@synthesize viewController;
@synthesize settingsViewController;




#pragma mark -
#pragma mark Application lifecycle



-(void) CHECK_ON {
	MRLogFunc(1);
	[viewController toggleTorch:YES];
}

-(void) CHECK_OFF {
	MRLogFunc(1);
	[viewController toggleTorch:NO];
}

-(IBAction) Setting {
	MRLogFunc(1);
	
	[settingsViewController setDelegate:self];
	[window addSubview:settingsViewController.view];
}

-(IBAction) Main {
	MRLogFunc(1);
	
	[settingsViewController.view removeFromSuperview];
	[viewController ChangeColor];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	MRLogFunc(1);
	[super application:application didFinishLaunchingWithOptions:launchOptions];
	// Override point for customization after application launch.
	[viewController setDelegate:self];
	[window addSubview:viewController.view];
	
	[self CHECK_ON];
    [window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	MRLogFunc(1);
	[super applicationWillResignActive:application];
	[self CHECK_OFF];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	MRLogFunc(1);
	[super applicationDidEnterBackground:application];
	[self CHECK_OFF];
   
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	MRLogFunc(1);
	[super applicationWillEnterForeground:application];
	
	[self CHECK_ON];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	MRLogFunc(1);
	[super applicationDidBecomeActive:application];

	[self CHECK_ON];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	MRLogFunc(1);
	[super applicationWillTerminate:application];
	
	[self CHECK_OFF];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	MRLogFunc(1);
	[super applicationDidReceiveMemoryWarning:application];
	
	[self CHECK_OFF];
}


- (void)dealloc {
	MRLogFunc(1);
	[viewController release];
    [window release];
    [super dealloc];
}


@end
