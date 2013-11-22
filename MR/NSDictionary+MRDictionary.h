//
//  NSDictionary+MRDictionary.h
//  AMFObject
//
//  Created by AKEB on 1/9/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRConfig.h"
#import "MRDefine.h"
#import "MRLog.h"

@interface NSDictionary (MRDictionary)


-(NSDictionary *) getHash;
-(NSDictionary *) getHashWithKey:(NSString *)key;
-(NSDictionary *) getHashWithKey:(NSString *)key andValue:(NSString *)value;

-(NSDictionary *) makeHash;
-(NSDictionary *) makeHashWithKey:(NSString *)key;



@end
