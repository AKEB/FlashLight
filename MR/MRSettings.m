//
//  MRSettings.m
//  AMFObject
//
//  Created by AKEB on 1/11/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import "MRSettings.h"


@implementation MRSettings

static MRSettings *_sharedController = nil;

+(MRSettings *) sharedController {
	@synchronized(_sharedController) {
		MRLogFunc(1);
		if (_sharedController == nil) {
			[[MRSettings alloc] init];
		}
		return _sharedController;
	}
}

-(id) init {
	MRLogFunc(1);
	self = [super init];
	_sharedController = self;
	@synchronized(_settings) {
		_settings = [[NSMutableDictionary alloc] initWithCapacity:1];
		[_settings retain];
	}
	if (self) {
		[self copySettings];
	}
	
	return self;
}

-(void) copySettings {
	MRLogFunc(1);
	BOOL success;
	NSError *error;
	
	NSString *homePath = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
	NSString *writableSettingsPath = [homePath stringByAppendingPathComponent:MRSettingsFile];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:writableSettingsPath];
	if (!success) {
		NSString *defaultSettingsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:MRSettingsFile];
		success = [fileManager copyItemAtPath:defaultSettingsPath toPath:writableSettingsPath error:&error];
	}
	if (success) {
		[self loadSettings];
	}
}

-(void) loadSettings {
	MRLogFunc(1);
	NSString *homePath = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
	NSString *writableSettingsPath = [homePath stringByAppendingPathComponent:MRSettingsFile];
	@synchronized(_settings) {
		_settings = [NSMutableDictionary dictionaryWithContentsOfFile:writableSettingsPath];
		[_settings retain];
	}
}

-(void) saveSettings {
	MRLogFunc(1);
	NSString *homePath = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
	NSString *writableSettingsPath = [homePath stringByAppendingPathComponent:MRSettingsFile];
	@synchronized(_settings) {
		[_settings writeToFile:writableSettingsPath atomically:YES];
	}
}

-(void) dealloc {
	MRLogFunc(1);
	[self saveBuffer];
	@synchronized(_settings) {
		[_settings release];
	}
	_sharedController = nil;
	[super dealloc];
}

-(NSString *) description {
	MRLogFunc(1);
	return [_settings description];
}


- (id)objectForKey:(NSString *)defaultName {
	MRLogFunc(1);
	return [_settings objectForKey:defaultName];
}

- (void)setObject:(id)value forKey:(NSString *)defaultName {
	MRLogFunc(1);
	@synchronized(_settings) {
		[_settings setObject:value forKey:defaultName];
	}
	[self saveSettings];
}

- (void)removeObjectForKey:(NSString *)defaultName {
	MRLogFunc(1);
	@synchronized(_settings) {
		[_settings removeObjectForKey:defaultName];
	}
	[self saveSettings];
}


- (NSString *)stringForKey:(NSString *)defaultName {
	MRLogFunc(1);
	return [NSString stringWithString:[self objectForKey:defaultName]];
}

- (NSArray *)arrayForKey:(NSString *)defaultName {
	MRLogFunc(1);
	return [NSArray arrayWithArray:[self objectForKey:defaultName]];
}

- (NSDictionary *)dictionaryForKey:(NSString *)defaultName {
	MRLogFunc(1);
	return [NSDictionary dictionaryWithDictionary:[self objectForKey:defaultName]];
}

- (NSData *)dataForKey:(NSString *)defaultName {
	MRLogFunc(1);
	return [NSData dataWithData:[self objectForKey:defaultName]];
}

- (NSDate *)dateForKey:(NSString *)defaultName {
	MRLogFunc(1);
	return [NSDate dateWithTimeInterval:0 sinceDate:[self objectForKey:defaultName]];
}

- (int)intForKey:(NSString *)defaultName {
	MRLogFunc(1);
	return [[self objectForKey:defaultName] intValue];
}

- (NSInteger)integerForKey:(NSString *)defaultName {
	MRLogFunc(1);
	return [[self objectForKey:defaultName] integerValue];
}

- (float)floatForKey:(NSString *)defaultName {
	MRLogFunc(1);
	return [[self objectForKey:defaultName] floatValue];
}

- (double)doubleForKey:(NSString *)defaultName {
	MRLogFunc(1);
	return [[self objectForKey:defaultName] doubleValue];
}

- (BOOL)boolForKey:(NSString *)defaultName {
	MRLogFunc(1);
	return [[self objectForKey:defaultName] boolValue];
}

- (NSURL *)URLForKey:(NSString *)defaultName {
	MRLogFunc(1);
	return [NSURL URLWithString:[self stringForKey:defaultName]];
}



- (void) setString:(NSString *)value forKey:(NSString *)defaultName {
	MRLogFunc(1);
	[self setObject:value forKey:defaultName];
}

- (void) setArray:(NSArray *)value forKey:(NSString *)defaultName {
	MRLogFunc(1);
	[self setObject:value forKey:defaultName];
}

- (void) setDictionary:(NSDictionary *)value forKey:(NSString *)defaultName {
	MRLogFunc(1);
	[self setObject:value forKey:defaultName];
}

- (void) setData:(NSData *)value forKey:(NSString *)defaultName {
	MRLogFunc(1);
	[self setObject:value forKey:defaultName];
}

- (void) setDate:(NSDate *)value forKey:(NSString *)defaultName {
	MRLogFunc(1);
	[self setObject:value forKey:defaultName];
}

- (void) setInt:(int)value forKey:(NSString *)defaultName {
	MRLogFunc(1);
	[self setObject:[NSNumber numberWithInt:value] forKey:defaultName];
}

- (void) setInteger:(NSInteger)value forKey:(NSString *)defaultName {
	MRLogFunc(1);
	[self setObject:[NSNumber numberWithInteger:value] forKey:defaultName];
}

- (void) setFloat:(float)value forKey:(NSString *)defaultName {
	MRLogFunc(1);
	[self setObject:[NSNumber numberWithFloat:value] forKey:defaultName];
}

- (void) setDouble:(double)value forKey:(NSString *)defaultName {
	MRLogFunc(1);
	[self setObject:[NSNumber numberWithDouble:value] forKey:defaultName];
}

- (void) setBool:(BOOL)value forKey:(NSString *)defaultName {
	MRLogFunc(1);
	[self setObject:[NSNumber numberWithBool:value] forKey:defaultName];
}

- (void) setURL:(NSURL *)value forKey:(NSString *)defaultName {
	MRLogFunc(1);
	[self setObject:[value absoluteString] forKey:defaultName];
}

@end
