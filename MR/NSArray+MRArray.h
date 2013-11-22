//
//  NSArray+MRArray.h
//  AMFObject
//
//  Created by AKEB on 1/9/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRConfig.h"
#import "MRDefine.h"
#import "MRLog.h"

@class MRIndex;

@interface NSArray (MRArray)


-(NSDictionary *) getHash;
-(NSDictionary *) getHashWithKey:(NSString *)key;
-(NSDictionary *) getHashWithKey:(NSString *)key andValue:(NSString *)value;

-(NSDictionary *) makeHash;
-(NSDictionary *) makeHashWithKey:(NSString *)key;


-(int) currentIndex;
-(void) setCurrentIndex:(int)value;

-(id) safeObjectAtIndex:(NSUInteger)index;
-(id) nextObject;

-(double) nextDouble;
-(float) nextFloat;
-(int) nextInt;
-(BOOL) nextBool;

-(double) doubleAtIndex:(NSUInteger)index;
-(float) floatAtIndex:(NSUInteger)index;
-(int) intAtIndex:(NSUInteger)index;
-(BOOL) boolAtIndex:(NSUInteger)index;



-(void) dealloc;


@end

@interface MRIndex : NSObject {
	NSMutableDictionary *indexes;
}

+(MRIndex *) sharedController;
-(id) init;

-(int) indexForObject:(id) object;
-(void) addIndexForObject:(id) object;
-(void) setIndex:(int)index forObject:(id) object;
-(void) removeIndexForObject:(id) object;
-(void) log;

@end