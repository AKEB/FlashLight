/*
 *  MRDefine.h
 *  AMFObject
 *
 *  Created by AKEB on 1/5/11.
 *  Copyright 2011 AKEB.RU. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MRConfig.h"

// IPad
#define IS_DEVICE_IPAD [[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound
#define IS_DEVICE_IPOD [[UIDevice currentDevice].model rangeOfString:@"iPod"].location != NSNotFound

#define MRTrans(s) NSLocalizedString(s,@"")

#define MRRandom(min, max) ((float)((float) rand()/(float)RAND_MAX)*max+min)
#define MRRandomInt(min, max) ((int) min + arc4random() % (max-min+1))

#define array(...) [NSMutableArray arrayWithObjects:__VA_ARGS__,nil]
#define concat(...) [array(__VA_ARGS__) componentsJoinedByString:@""]
#define randRoll(a) a*1000000 >= MRRandomInt(1,1000000)

static NSString *declension(int a, NSString *str1, NSString *str2_4, NSString *str5) {
	if ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqual:@"ru"]) {
		int mod10 = a % 10;
		int mod100 = a % 100;
		if (((mod100 >= 10) && (mod100 <= 20)) || (mod10 > 4) || (mod10 == 0)) return str5;
		else if (mod10 > 1) return str2_4;
		return str1;
	} else {
		if (a == 1) return str1;
		else return str2_4;
	}
}

static BOOL is_array(id a) {
	if (!a) return NO;
	if ([a isKindOfClass:[NSArray class]]) return YES;
	return NO;
}
static BOOL is_dictionary(id a) {
	if (!a) return NO;
	if ([a isKindOfClass:[NSDictionary class]]) return YES;
	return NO;
}
static BOOL is_string(id a) {
	if (!a) return NO;
	if ([a isKindOfClass:[NSString class]]) return YES;
	return NO;
}

static NSString *implode(NSString *sep,NSArray *array) {
	return [array componentsJoinedByString:sep];
}
static NSArray *explode(NSString *sep,NSString *string) {
	return [string componentsSeparatedByString:sep];
}

static NSString *urlencode(NSString *url) {
	NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
								NULL, /* allocator */
								(CFStringRef)url,
								NULL, /* charactersToLeaveUnescaped */
								(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
								kCFStringEncodingUTF8);
	return escaped_value;
}

static NSString *buildRequest(NSDictionary *params, NSString *arrayName) {
	NSMutableArray *t = [[NSMutableArray alloc] initWithCapacity:[params count]];
	for (NSMutableString *key in [params keyEnumerator]) {
		id value = [params objectForKey:key];
		key = urlencode(key);
		if (arrayName) key = [NSMutableString stringWithFormat:@"%@[%@]",arrayName,key];
		NSString *text = ((is_dictionary(value)) ? buildRequest(value,key): [NSString stringWithFormat:@"%@=%@",key,urlencode(value)]);
		[t addObject:text];
	}
	return implode(@"&",t);
}

static NSString *buildUrl(NSString *url, NSDictionary *params) {
	NSURL *parsedURL = [NSURL URLWithString:url];
	NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString *strQuery = params ? buildRequest(params,nil) : @"";
	return [NSString stringWithFormat:@"%@%@%@", url, queryPrefix, strQuery];
}


