//
//  NSDictionary+MRDictionary.m
//  AMFObject
//
//  Created by AKEB on 1/9/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import "NSDictionary+MRDictionary.h"
#import "MRLog.h"

@implementation NSDictionary (MRDictionary)


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
	for (id k in self) {
		id obj = [self objectForKey:k];
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
	for (id k in self) {
		id obj = [self objectForKey:k];
		if (![obj isKindOfClass:[NSDictionary class]]) continue;
		[hash setObject:obj forKey:[obj objectForKey:key]];
	}
	return hash;
}

@end
