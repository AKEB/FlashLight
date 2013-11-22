//
//  MRStats.m
//  AMFObject
//
//  Created by AKEB on 1/11/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import "MRStats.h"
#import "MRDefine.h"

@implementation MRStats

static MRStats *_sharedController = nil;

+(MRStats *) sharedController {
	@synchronized(_sharedController) {
		MRLogFunc(1);
		if (_sharedController == nil) {
			[[MRStats alloc] init];
		}
		return _sharedController;
	}
}

-(id) init {
	MRLogFunc(1);
	self = [super init];
	
	sendingBuffer = [[NSMutableArray alloc] init];
	
	[self restoreBuffer];
	
	_sharedController = self;
	
	if (MRSTAT) {
		NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
		[thread start];
	}
	
	return self;
}

-(void) addEvent:(MRStatEvents) eventInt SubEventId:(int)subEvent {
	MRLogFunc(1);
	if (MRSTAT) {
		NSNumber *eventId = [NSNumber numberWithInt:eventInt];
		NSNumber *subEventId = [NSNumber numberWithInt:subEvent];
		NSDate *date = [[[NSDate alloc] init] autorelease];
		NSDictionary *event = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:eventId,subEventId,date,nil] forKeys:[NSArray arrayWithObjects:@"id",@"subId",@"date",nil]];
		@synchronized(sendingBuffer) {
			[sendingBuffer addObject:event];
		}
	}
}

-(void) addEvent:(MRStatEvents) eventInt {
	MRLogFunc(1);
	if (MRSTAT) [self addEvent:eventInt SubEventId:0];
}

-(void) run {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[NSThread currentThread] setName:@"MRStats"];
	MRLogFunc(1);
	if (MRSTAT) [self runLoop];
	[pool release];
}

-(void) runLoop {
	MRLogFunc(1);
	if (MRSTAT) {
		NSNumber *eventID;
		NSNumber *subEventID;
		
		NSDate *date;
		NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
		NSString *uniqId = [[UIDevice currentDevice] uniqueIdentifier];
		BOOL good;
		@synchronized(sendingBuffer) {
			while ([sendingBuffer count] > 0) {
				id obj = [sendingBuffer safeObjectAtIndex:0];
				if (obj != nil) {
					good = NO;
					eventID = [obj objectForKey:@"id"];
					subEventID = [obj objectForKey:@"subId"];
					date = [obj objectForKey:@"date"];
					
					NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@?dev=%@&id=%@&version=%@&event_id=%d&time=%d&sub_event_id=%d",
													   MRSTATURL,
													   (IS_DEVICE_IPAD ? @"iPad" : (IS_DEVICE_IPOD ? @"iPod" : @"iPhone")),
													   uniqId,
													   systemVersion,
													   [eventID intValue],
													   (int)[date timeIntervalSince1970],
													   [subEventID intValue]
													   ]];
					
					NSString *result = [NSString stringWithContentsOfURL:url];
					good = [result rangeOfString:@"ok"].location != NSNotFound;
					if (good) {
						[sendingBuffer removeObjectAtIndex:0];
					}
				}
			}
		}
		sleep(60);
		[self runLoop];
	}
}

-(void) restoreBuffer {
	MRLogFunc(1);
	if (MRSTAT) {
		@synchronized(sendingBuffer) {
			NSArray *readArray = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/MRStats.xml",NSHomeDirectory()]];
			[sendingBuffer removeAllObjects];
			[sendingBuffer addObjectsFromArray:readArray];
		}
	}
}

-(void) saveBuffer {
	MRLogFunc(1);
	if (MRSTAT) {
		@synchronized(sendingBuffer) {
			[sendingBuffer writeToFile:[NSString stringWithFormat:@"%@/Documents/MRStats.xml",NSHomeDirectory()] atomically:YES];
		}
	}
}

-(void) dealloc {
	MRLogFunc(1);
	[self saveBuffer];
	@synchronized(sendingBuffer) {
		[sendingBuffer release];
	}
	_sharedController = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Управление приложением

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	MRLogFunc(1);
	if (MRSTAT) [self restoreBuffer];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	MRLogFunc(1);
	if (MRSTAT) [self restoreBuffer];
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	MRLogFunc(1);
	if (MRSTAT) {
		[self restoreBuffer];
		[self addEvent:MRStatEventLogin];
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {
	MRLogFunc(1);
	if (MRSTAT) {
		[self addEvent:MRStatEventLogout];
		[self saveBuffer];
	}
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	MRLogFunc(1);
	if (MRSTAT) {
		[self addEvent:MRStatEventLogout];
		[self saveBuffer];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	MRLogFunc(1);
	if (MRSTAT) {
		[self addEvent:MRStatEventLogout];
		[self saveBuffer];
	}
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	MRLogFunc(1);
}


- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
	MRLogFunc(1);
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
	MRLogFunc(1);
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame {
	MRLogFunc(1);
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {
	MRLogFunc(1);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	MRLogFunc(1);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	MRLogFunc(1);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	MRLogFunc(1);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	MRLogFunc(1);
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	MRLogFunc(1);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	MRLogFunc(1);
}


- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application {
	MRLogFunc(1);
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application {
	MRLogFunc(1);
}


@end
