//
//  MRStats.h
//  AMFObject
//
//  Created by AKEB on 1/11/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MRConfig.h"
#import "MRDefine.h"
#import "MRLog.h"

enum {
	MRStatEventLogin = 1,
	MRStatEventLogout = 2,
	MRStatEventGameFinish = 3,
	MRStatEventBannerStart = 4,
	MRStatEventBannerEnd = 5,
	MRStatEventBannerOther = 6,
	MRStatEventBannerClick = 7,
	MRStatEventLevelUp = 8
};
typedef NSUInteger MRStatEvents;


@interface MRStats : NSObject {
	NSMutableArray *sendingBuffer;
}

+(MRStats *) sharedController;

-(id) init;
-(void) addEvent:(MRStatEvents) eventInt SubEventId:(int)subEvent;
-(void) addEvent:(MRStatEvents) eventInt;
-(void) run;
-(void) runLoop;
-(void) restoreBuffer;
-(void) saveBuffer;
-(void) dealloc;



- (void)applicationDidFinishLaunching:(UIApplication *)application;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (void)applicationSignificantTimeChange:(UIApplication *)application;
- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration;
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation;
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame;
- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application;
- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application;

@end
