//
//  MRAppDelegate.m
//  AMFObject
//
//  Created by AKEB on 1/11/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import "MRAppDelegate.h"
#import "MRLog.h"

@implementation MRAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	MRLogFunc(1);
	//[[MRSettings sharedController] loadSettings];
	[[MRStats sharedController] applicationDidFinishLaunching:application];
	
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	MRLogFunc(1);
	//[[MRSettings sharedController] loadSettings];
	[[MRStats sharedController] application:application didFinishLaunchingWithOptions:launchOptions];
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	MRLogFunc(1);
	//[[MRSettings sharedController] loadSettings];
	[[MRStats sharedController] applicationDidBecomeActive:application];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	MRLogFunc(1);
	//[[MRSettings sharedController] saveSettings];
	[[MRStats sharedController] applicationWillResignActive:application];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	MRLogFunc(1);
	//[[MRSettings sharedController] saveSettings];
	[[MRStats sharedController] applicationDidReceiveMemoryWarning:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	MRLogFunc(1);
	//[[MRSettings sharedController] saveSettings];
	[[MRStats sharedController] applicationWillTerminate:application];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	MRLogFunc(1);
	[[MRStats sharedController] applicationSignificantTimeChange:application];
}

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
	MRLogFunc(1);
	[[MRStats sharedController] application:application willChangeStatusBarOrientation:newStatusBarOrientation duration:duration];
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
	MRLogFunc(1);
	[[MRStats sharedController] application:application didChangeStatusBarOrientation:oldStatusBarOrientation];
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame {
	MRLogFunc(1);
	[[MRStats sharedController] application:application willChangeStatusBarFrame:newStatusBarFrame];
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {
	MRLogFunc(1);
	[[MRStats sharedController] application:application didChangeStatusBarFrame:oldStatusBarFrame];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	MRLogFunc(1);
	[[MRStats sharedController] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	MRLogFunc(1);
	[[MRStats sharedController] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	MRLogFunc(1);
	[[MRStats sharedController] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	MRLogFunc(1);
	[[MRStats sharedController] application:application didReceiveLocalNotification:notification];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	MRLogFunc(1);
	[[MRStats sharedController] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	MRLogFunc(1);
	[[MRStats sharedController] applicationWillEnterForeground:application];
}


- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application {
	MRLogFunc(1);
	[[MRStats sharedController] applicationProtectedDataWillBecomeUnavailable:application];
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application {
	MRLogFunc(1);
	[[MRStats sharedController] applicationProtectedDataDidBecomeAvailable:application];
}

- (void)dealloc {
	MRLogFunc(1);
	//[[MRSettings sharedController] saveSettings];
	[[MRSettings sharedController] dealloc];
	[[MRStats sharedController] dealloc];
	[super dealloc];
}

@end
