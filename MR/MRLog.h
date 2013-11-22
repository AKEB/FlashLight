//
//  MRLog.h
//  AMFObject
//
//  Created by AKEB on 1/5/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//


/*
 MRLog
 
 Подключение:
 
 MRLog *log = [MRLog sharedController];
 [self.view addSubview:log];
 [log openLog];
 
 */

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import "MRConfig.h"
#import "MRDefine.h"


/*
 MRLogFunc(1);
 MRLogFunc(3);
 MRLog(); === NSLog();
 MRLogError(); === NSLog();
*/

#if MRLogFuncDefine > 0 || MRLogFileFuncDefine > 0
	#define MRLogFunc(level) \
	do { \
		if(MRLogFuncDefine && level <= MRLogLevelDefine) { \
				NSLog(@"%s",__FUNCTION__); \
		} \
		if(MRLogFileFuncDefine && level <= MRLogFileLevelDefine) { \
			[MRLog writeToFile:[NSString stringWithFormat:@"%s",__FUNCTION__]]; \
		} \
	} while (0) 
#else
	#define MRLogFunc(level) do {} while (0)
#endif

#if MRLogDefine > 0 || MRLogFileDefine > 0
	#define MRLog(...) \
	do { \
		if(MRLogDefine) { \
			NSLog(__VA_ARGS__); \
		} \
		if(MRLogFileDefine) { \
			[MRLog writeToFile:[NSString stringWithFormat:__VA_ARGS__]]; \
		} \
	} while (0) 
#else
	#define MRLog(...) do {} while (0)
#endif

#if MRLogErrorDefine > 0 || MRLogErrorFileDefine > 0
	#define MRLogError(...) \
	do { \
		if(MRLogErrorDefine) { \
			NSLog(@"ERROR: %@",[NSString stringWithFormat:__VA_ARGS__]); \
		} \
		if(MRLogErrorFileDefine) { \
			[MRLog writeToFile:[NSString stringWithFormat:@"ERROR: %@",[NSString stringWithFormat:__VA_ARGS__]]]; \
		} \
	} while (0) 
#else
	#define MRLogError(...) do {} while (0)
#endif

@class MRLogView, MRLogTableViewController;

@interface MRLog :  UIView{
	UINavigationController *navController;
}
+(MRLog *) sharedController;
+(void) writeToFile:(NSString *)log;
-(void) openLog;


@end

@interface MRLogTableViewController : UITableViewController {
	NSMutableArray *logsArray;
}

@end

@interface MRLogView : UIViewController <MFMailComposeViewControllerDelegate> {
	UINavigationController *navController;
}

@property (nonatomic, retain) UINavigationController *navController;

- (void)setLogFromName:(NSString *)logName;

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;
@end

