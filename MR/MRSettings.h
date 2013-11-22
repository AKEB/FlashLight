//
//  MRSettings.h
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

@class NSArray, NSData, NSDictionary, NSMutableDictionary, NSString, NSURL;

#define MRSettingsFile @"MRSettings.plist"

@interface MRSettings : NSObject {
	NSMutableDictionary *_settings;
}


+(MRSettings *) sharedController;
-(id) init;
-(void) copySettings;
-(void) dealloc;
-(void) loadSettings;
-(void) saveSettings;

- (id)objectForKey:(NSString *)defaultName;
- (void)setObject:(id)value forKey:(NSString *)defaultName;
- (void)removeObjectForKey:(NSString *)defaultName;

- (NSString *)stringForKey:(NSString *)defaultName;
- (NSArray *)arrayForKey:(NSString *)defaultName;
- (NSDictionary *)dictionaryForKey:(NSString *)defaultName;
- (NSData *)dataForKey:(NSString *)defaultName;
- (NSDate *)dateForKey:(NSString *)defaultName;
- (int)intForKey:(NSString *)defaultName;
- (NSInteger)integerForKey:(NSString *)defaultName;
- (float)floatForKey:(NSString *)defaultName;
- (double)doubleForKey:(NSString *)defaultName;
- (BOOL)boolForKey:(NSString *)defaultName;
- (NSURL *)URLForKey:(NSString *)defaultName;

- (void) setString:(NSString *)value forKey:(NSString *)defaultName;
- (void) setArray:(NSArray *)value forKey:(NSString *)defaultName;
- (void) setDictionary:(NSDictionary *)value forKey:(NSString *)defaultName;
- (void) setData:(NSData *)value forKey:(NSString *)defaultName;
- (void) setDate:(NSDate *)value forKey:(NSString *)defaultName;
- (void) setInt:(int)value forKey:(NSString *)defaultName;
- (void) setInteger:(NSInteger)value forKey:(NSString *)defaultName;
- (void) setFloat:(float)value forKey:(NSString *)defaultName;
- (void) setDouble:(double)value forKey:(NSString *)defaultName;
- (void) setBool:(BOOL)value forKey:(NSString *)defaultName;
- (void) setURL:(NSURL *)value forKey:(NSString *)defaultName;

@end
