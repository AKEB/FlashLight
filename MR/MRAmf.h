//
//  MRAmf.h
//  Frameworks
//
//  Created by AKEB on 12/31/10.
//  Copyright 2010 AKEB.RU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MRConfig.h"
#import "MRDefine.h"
#import "MRLog.h"

@class MRLog;

typedef enum _AMF3Type
{
	kAMF3UndefinedType = 0x0,
	kAMF3NullType = 0x1,
	kAMF3FalseType = 0x2,
	kAMF3TrueType = 0x3,
	kAMF3IntegerType = 0x4,
	kAMF3DoubleType = 0x5,
	kAMF3StringType = 0x6,
	kAMF3XMLDocType = 0x7,
	kAMF3DateType = 0x8,
	kAMF3ArrayType = 0x9,
	kAMF3ObjectType = 0xA,
	kAMF3XMLType = 0xB,
	kAMF3ByteArrayType = 0xC
} AMF3Type;

@interface MRAmf : NSObject {
	NSMutableData *_data;
	id _object;
	uint8_t *_bytes;
	uint32_t _position;
	NSMutableArray *_stringTable;
	NSMutableArray *_objectTable;
	
	NSMutableArray *m_writeStack;
	NSObject *m_currentObjectToWrite;
}

@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) id object;

+(MRAmf *) AMFWithdata:(NSData *) BytesData;
+(MRAmf *) AMFWithObject:(id) customObject;

-(id) initWithData:(NSData *) BytesData;
-(id) initWithObject:(id) customObject;


-(NSString *) _stringReferenceAtIndex:(uint32_t)index;
-(id) _objectReferenceAtIndex:(uint32_t)index;
-(NSObject *) _decodeObjectWithType:(AMF3Type)type;


-(NSObject *) decodeObject;
-(double) decodeDouble;
-(uint8_t) decodeUnsignedChar;
-(uint32_t) decodeUnsignedInt29;
-(NSString *) decodeUTF;
-(NSString *) decodeUTFBytes:(uint32_t)length;
-(NSData *) decodeBytes:(uint32_t)length;
-(NSDate *) _decodeDate;
-(NSObject *) _decodeArray;
+(uint32_t) decodeInt:(const char* ) buf;

-(NSData *) encodeObject;


-(void) dealloc;
@end





@interface NSObject (iPhoneExtensions)
- (NSString *)className;
@end

