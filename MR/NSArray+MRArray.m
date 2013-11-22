//
//  NSDictionary+MRDictionary.m
//  AMFObject
//
//  Created by AKEB on 1/9/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import "NSArray+MRArray.h"
#import "MRLog.h"

@implementation NSArray (MRArray)


-(NSDictionary *) getHash {
	MRLogFunc(1);
	return [self getHashWithKey:@"id" andValue:@"title"];
}

-(NSDictionary *) getHashWithKey:(NSString *)key {
	MRLogFunc(1);
	return [self getHashWithKey:key andValue:@"title"];
}

-(NSDictionary *) getHashWithKey:(NSString *)key andValue:(NSString *)value {
	MRLogFunc(1);
	NSMutableDictionary *hash = [[[NSMutableDictionary alloc] initWithCapacity:[self count]] autorelease];
	for (int i=0; i<[self count]; i++) {
		id obj = [self objectAtIndex:i];
		if (![obj isKindOfClass:[NSDictionary class]]) continue;
		[hash setObject:[obj objectForKey:value] forKey:[obj objectForKey:key]];
	}
	return hash;
}

-(NSDictionary *) makeHash {
	MRLogFunc(1);
	return [self makeHashWithKey:@"id"];
}

-(NSDictionary *) makeHashWithKey:(NSString *)key {
	MRLogFunc(1);
	NSMutableDictionary *hash = [[[NSMutableDictionary alloc] initWithCapacity:[self count]] autorelease];
	for (int i=0; i<[self count]; i++) {
		id obj = [self objectAtIndex:i];
		if (![obj isKindOfClass:[NSDictionary class]]) continue;
		[hash setObject:obj forKey:[obj objectForKey:key]];
	}
	return hash;
	
}



-(id) nextObject {
	MRLogFunc(4);
	int index = [[MRIndex sharedController] indexForObject:self];
	index++;
	return [self safeObjectAtIndex:index];
}

-(id) safeObjectAtIndex:(NSUInteger)index
{
	MRLogFunc(4);
	if ([self count] <= index) return Nil; 
	id o = [self objectAtIndex:index];
	[[MRIndex sharedController] setIndex:index forObject:self];
	return o;
}

-(int) nextInt {
	MRLogFunc(4);
	id o = [self nextObject];
	if (o && o != [NSNull null]) {
		return [o intValue];
	}
	return 0;
}

-(float) nextFloat {
	MRLogFunc(4);
	id o = [self nextObject];
	if (o && o != [NSNull null]) {
		return [o floatValue];
	}
	return 0.0;
}

-(double) nextDouble {
	MRLogFunc(4);
	id o = [self nextObject];
	if (o && o != [NSNull null]) {
		return [o doubleValue];
	}
	return 0.0;
}

-(BOOL) nextBool {
	MRLogFunc(4);
	id o = [self nextObject];
	if (o && o != [NSNull null]) {
		return [o boolValue];
	}
	return NO;
}


-(int) intAtIndex:(NSUInteger)index {
	MRLogFunc(4);
	id o = [self safeObjectAtIndex:index];
	if (o && o != [NSNull null]) {
		return [o intValue];
	}
	return 0;
}

-(float) floatAtIndex:(NSUInteger)index {
	MRLogFunc(4);
	id o = [self safeObjectAtIndex:index];
	if (o && o != [NSNull null]) {
		return [o floatValue];
	}
	return 0.0;
}

-(double) doubleAtIndex:(NSUInteger)index {
	MRLogFunc(4);
	id o = [self safeObjectAtIndex:index];
	if (o && o != [NSNull null]) {
		return [o doubleValue];
	}
	return 0.0;
}

-(BOOL) boolAtIndex:(NSUInteger)index {
	MRLogFunc(4);
	id o = [self safeObjectAtIndex:index];
	if (o && o != [NSNull null]) {
		return [o boolValue];
	}
	return NO;
}

-(void) setCurrentIndex:(int)value {
	MRLogFunc(4);
	[[MRIndex sharedController] setIndex:value forObject:self];
}

-(int) currentIndex {
	MRLogFunc(4);
	return [[MRIndex sharedController] indexForObject:self];
}


-(void) dealloc {
	MRLogFunc(4);
	[[MRIndex sharedController] removeIndexForObject:self];
	[super dealloc];
}


@end



@implementation MRIndex

static MRIndex *_sharedController = nil;

+(MRIndex *) sharedController {
	MRLogFunc(4);
	if (_sharedController == nil)
		[[MRIndex alloc] init];
	
	return _sharedController;
}

-(id) init {
	MRLogFunc(4);
	indexes = [NSMutableDictionary dictionaryWithCapacity:1];
	[indexes retain];
	
	self = [super init];
	_sharedController = self;
	
	return self;
}

-(void) setIndex:(int)index forObject:(id) object {
	MRLogFunc(4);
	[indexes setObject:[NSString stringWithFormat:@"%d",index] forKey:[NSString stringWithFormat:@"%p",object]];
}

-(int) indexForObject:(id) object {
	MRLogFunc(4);
	id o = [indexes objectForKey:[NSString stringWithFormat:@"%p",object]];
	if (o) return [o intValue];
	return -1;
}

-(void) addIndexForObject:(id) object {
	MRLogFunc(4);
	int index = [self indexForObject:object];
	index++;
	[self setIndex:index forObject:object];
}

-(void) removeIndexForObject:(id) object {
	MRLogFunc(4);
	if (!object) return;
	[indexes setObject:@"" forKey:[NSString stringWithFormat:@"%p",object]];
	[indexes removeObjectForKey:[NSString stringWithFormat:@"%p",object]];
}

-(void) log {
	MRLogFunc(4);
	MRLog(@"%@",[indexes description]);
}

@end
