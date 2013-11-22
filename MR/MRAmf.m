//
//  MRAmf.m
//  Frameworks
//
//  Created by AKEB on 12/31/10.
//  Copyright 2010 AKEB.RU. All rights reserved.
//

#import "MRLog.h"
#import "MRAmf.h"

NSString * NSStringFromAMF3Type(AMF3Type type) {
	switch (type) {
		case kAMF3UndefinedType:
			return @"AMF3UndefinedType";
		case kAMF3NullType:
			return @"AMF3NullType";
		case kAMF3FalseType:
			return @"AMF3FalseType";
		case kAMF3TrueType:
			return @"AMF3TrueType";
		case kAMF3IntegerType:
			return @"AMF3IntegerType";
		case kAMF3DoubleType:
			return @"AMF3DoubleType";
		case kAMF3StringType:
			return @"AMF3StringType";
		case kAMF3XMLDocType:
			return @"AMF3XMLDocType";
		case kAMF3DateType:
			return @"AMF3DateType";
		case kAMF3ArrayType:
			return @"AMF3ArrayType";
		case kAMF3ObjectType:
			return @"AMF3ObjectType";
		case kAMF3XMLType:
			return @"AMF3XMLType";
		case kAMF3ByteArrayType:
			return @"AMF3ByteArrayType";
	}
	return @"AMF3 Unknown type!";
}

@implementation MRAmf

@synthesize data   = _data,
			object = _object;

-(id) initWithData:(NSData *)BytesData {
	MRLogFunc(1);
	self = [super init];
	if (self) {
		_object = [NSNull null];
		_data = [BytesData retain];
		_bytes = [_data bytes];
		_position = 0;
		_objectTable = [[NSMutableArray alloc] initWithCapacity:1];
		_stringTable = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return self;
}

-(id) initWithObject:(id)customObject {
	MRLogFunc(1);
	self = [super init];
	if (self) {
		_data = [[NSMutableData alloc] initWithCapacity:1];
		_bytes = [_data bytes];
		_object = [customObject retain];
		_position = 0;
		_objectTable = [[NSMutableArray alloc] initWithCapacity:1];
		_stringTable = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return self;
}

-(NSString *) _stringReferenceAtIndex:(uint32_t)index {
	MRLogFunc(5);
	if ([_stringTable count] >= index) {
		return [_stringTable objectAtIndex:index];
	} 
	return [NSString string];
}

-(id) _objectReferenceAtIndex:(uint32_t)index {
	MRLogFunc(5);
	if ([_objectTable count] >= index) {
		return [_objectTable objectAtIndex:index];
	}
	return [NSNull null];
}
#pragma mark -
#pragma mark AMF Create


+(MRAmf *) AMFWithdata:(NSData *)BytesData {
	MRLogFunc(1);
	MRAmf *amf = [[MRAmf alloc] initWithData:BytesData];
	return [amf autorelease];
}

+(MRAmf *) AMFWithObject:(id) customObject {
	MRLogFunc(1);
	MRAmf *amf = [[MRAmf alloc] initWithObject:customObject];
	return [amf autorelease];
}

#pragma mark -
#pragma mark AMF decode

-(NSObject *) _decodeObjectWithType:(AMF3Type)type {
	MRLogFunc(5);
	id value = nil;
	switch (type)
	{
		case kAMF3StringType:
			value = [self decodeUTF];
			break;
			
		case kAMF3ObjectType:
			MRLogError(@"Unknown kAMF3ObjectType");
			//value = [self _decodeASObject];
			break;
			
		case kAMF3ArrayType:
			value = [self _decodeArray];
			break;
			
		case kAMF3FalseType:
			value = [NSNumber numberWithBool:NO];
			break;
			
		case kAMF3TrueType:
			value = [NSNumber numberWithBool:YES];
			break;
			
		case kAMF3IntegerType:
		{
			int32_t intValue = [self decodeUnsignedInt29];
			intValue = (intValue << 3) >> 3;
			value = [NSNumber numberWithInt:intValue];
			break;
		}
			
		case kAMF3DoubleType:
			value = [NSNumber numberWithDouble:[self decodeDouble]];
			break;
			
		case kAMF3UndefinedType:
			return [NSNull null];
			break;
			
		case kAMF3NullType:
			return [NSNull null];
			break;
			
		case kAMF3XMLType:
		case kAMF3XMLDocType:
			MRLogError(@"Unknown kAMF3XMLDocType");
			//value = [self _decodeXML];
			break;
			
		case kAMF3DateType:
			value = [self _decodeDate];
			break;
			
		case kAMF3ByteArrayType:
			MRLogError(@"Unknown kAMF3ByteArrayType");
			//value = [self _decodeByteArray];
			break;
			
		default:
			MRLogError(@"Unknown type");
			//[self _cannotDecodeType:"Unknown type"];
			break;
	}
	return value;
}

-(NSObject *) decodeObject {
	MRLogFunc(5);
	AMF3Type type = (AMF3Type)[self decodeUnsignedChar];
	return [self _decodeObjectWithType:type];
}

-(uint8_t) decodeUnsignedChar {
	MRLogFunc(5);
	return _bytes[_position++];
}

-(uint32_t) decodeUnsignedInt29 {
	MRLogFunc(5);
	uint32_t value;
	uint8_t ch = [self decodeUnsignedChar] & 0xFF;
	
	if (ch < 128) {
		return ch;
	}
	
	value = (ch & 0x7F) << 7;
	ch = [self decodeUnsignedChar] & 0xFF;
	if (ch < 128) {
		return value | ch;
	}
	
	
	value = (value | (ch & 0x7F)) << 7;
	ch = [self decodeUnsignedChar] & 0xFF;
	if (ch < 128) {
		return value | ch;
	}
	
	value = (value | (ch & 0x7F)) << 8;
	ch = [self decodeUnsignedChar] & 0xFF;
	return value | ch;
}

+(uint32_t) decodeInt:(const char* ) buf {
	MRLogFunc(5);
	
	uint32_t dataT;
	memcpy(&dataT, buf, 4);
	return ntohl(dataT);
}

-(NSString *) decodeUTF {
	MRLogFunc(5);
	uint32_t ref = [self decodeUnsignedInt29];
	if ((ref & 1) == 0) {
		ref = (ref >> 1);
		return [self _stringReferenceAtIndex:ref];
	}
	uint32_t length = ref >> 1;
	if (length == 0) {
		return [NSString string];
	}
	NSString *value = [self decodeUTFBytes:length];
	[_stringTable addObject:value];
	return value;
}

-(NSString *) decodeUTFBytes:(uint32_t)length {
	MRLogFunc(5);
	if (length == 0) {
		return [NSString string];
	}
	NSData *stringBytes = [self decodeBytes:length];
	NSString *result = [[NSString alloc] initWithData:stringBytes encoding:NSUTF8StringEncoding];
	if (result == nil) {
		result = [[NSString alloc] initWithData:stringBytes encoding:NSISOLatin1StringEncoding];
	}
	return [result autorelease];
}

-(NSData *) decodeBytes:(uint32_t)length {
	MRLogFunc(5);
	NSData *subdata = [_data subdataWithRange:(NSRange){_position, length}];
	_position += length;
	return subdata;
}

-(double) decodeDouble {
	MRLogFunc(5);
	uint8_t data[8];
	data[7] = _bytes[_position++];
	data[6] = _bytes[_position++];
	data[5] = _bytes[_position++];
	data[4] = _bytes[_position++];
	data[3] = _bytes[_position++];
	data[2] = _bytes[_position++];
	data[1] = _bytes[_position++];
	data[0] = _bytes[_position++];
	return *((double *)data);
}

-(NSDate *) _decodeDate {
	MRLogFunc(5);
	uint32_t ref = [self decodeUnsignedInt29];
	if ((ref & 1) == 0) {
		ref = (ref >> 1);
		return [self _objectReferenceAtIndex:ref];
	}
	NSTimeInterval time = [self decodeDouble];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:(time / 1000)];
	[_objectTable addObject:date];
	return date;
}

-(NSObject *) _decodeArray {
	MRLogFunc(5);
	uint32_t ref = [self decodeUnsignedInt29];
	
	if ((ref & 1) == 0) {
		ref = (ref >> 1);
		return [self _objectReferenceAtIndex:ref];
	}
	
	uint32_t length = (ref >> 1);
	NSObject *array = nil;
	for (;;) {
		NSString *name = [self decodeUTF];
		if (name == nil || [name length] == 0) break;
		if (array == nil) {
			array = [NSMutableDictionary dictionary];
			[_objectTable addObject:array];
		}
		[(NSMutableDictionary *)array setObject:[self decodeObject] forKey:name];
	}
	
	if (array == nil) {
		array = [NSMutableArray array];
		[_objectTable addObject:array];
		for (uint32_t i = 0; i < length; i++) {
			[(NSMutableArray *)array addObject:[self decodeObject]];
		}
	} else {
		for (uint32_t i = 0; i < length; i++) {
			[(NSMutableDictionary *)array setObject:[self decodeObject] 
											 forKey:[NSNumber numberWithInt:i]];
		}
	}
	
	return array;
}


#pragma mark -
#pragma mark AMF encode

- (void)_ensureLength:(unsigned)length {
	MRLogFunc(5);
	[_data setLength:[_data length] + length];
	_bytes = [_data mutableBytes];
}

- (void)encodeUnsignedChar:(uint8_t)value {
	MRLogFunc(5);
	[self _ensureLength:1];
	_bytes[_position++] = value;
}

- (void)encodeDouble:(double)value {
	MRLogFunc(5);
	uint8_t *ptr = (void *)&value;
	[self _ensureLength:8];
	_bytes[_position++] = ptr[7];
	_bytes[_position++] = ptr[6];
	_bytes[_position++] = ptr[5];
	_bytes[_position++] = ptr[4];
	_bytes[_position++] = ptr[3];
	_bytes[_position++] = ptr[2];
	_bytes[_position++] = ptr[1];
	_bytes[_position++] = ptr[0];	
}

+(char*) encodeInt:(int)val {
	MRLogFunc(1);
	char *buf = (char *)malloc(4);
	uint32_t dataInt = htonl(val);
	memcpy(buf, &dataInt, 4);
	return buf;
}

- (void)encodeUnsignedInt29:(uint32_t)value {
	MRLogFunc(5);
	if (value < 0x80) {
		[self _ensureLength:1];
		_bytes[_position++] = value;
	} else if (value < 0x4000) {
		[self _ensureLength:2];
		_bytes[_position++] = ((value >> 7) & 0x7F) | 0x80;
		_bytes[_position++] = (value & 0x7F);
	} else if (value < 0x200000) {
		[self _ensureLength:3];
		_bytes[_position++] = ((value >> 14) & 0x7F) | 0x80;
		_bytes[_position++] = ((value >> 7) & 0x7F) | 0x80;
		_bytes[_position++] = (value & 0x7F);
	} else {
		[self _ensureLength:4];
		_bytes[_position++] = ((value >> 22) & 0x7F) | 0x80;
		_bytes[_position++] = ((value >> 15) & 0x7F) | 0x80;
		_bytes[_position++] = ((value >> 8) & 0x7F) | 0x80;
		_bytes[_position++] = (value & 0xFF);
	}
}

- (void)_encodeNumber:(NSNumber *)value {
	MRLogFunc(5);
	if ([[value className] isEqualToString:@"NSCFBoolean"]) {
		[self encodeUnsignedChar:([value boolValue] ? kAMF3TrueType : kAMF3FalseType)];
	} else if (strcmp([value objCType], "f") == 0 || strcmp([value objCType], "d") == 0) {
		[self encodeUnsignedChar:kAMF3DoubleType];
		[self encodeDouble:[value doubleValue]];
	} else {
		[self encodeUnsignedChar:kAMF3IntegerType];
		[self encodeUnsignedInt29:[value intValue]];
	}
}

- (void)encodeDataObject:(NSData *)value {
	[_data appendData:value];
	_bytes = [_data mutableBytes];
	_position = [_data length];
}

- (void)_encodeString:(NSString *)value omitType:(BOOL)omitType {
	if (!omitType) {
		[self encodeUnsignedChar:kAMF3StringType];
	}
	if (value == nil || [value length] == 0) {
		[self encodeUnsignedChar:((0 << 1) | 1)];
		return;
	}
	if ([_stringTable containsObject:value]) {
//		[self encodeUnsignedInt29:([_stringTable indexOfObject:value] << 1)];
//		return;
	}
	[_stringTable addObject:value];
	NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
	[self encodeUnsignedInt29:(([data length] << 1) | 1)];
	[self encodeDataObject:data];
}

- (void)_encodeDate:(NSDate *)value {
	[self encodeUnsignedChar:kAMF3DateType];
	if ([_objectTable indexOfObjectIdenticalTo:value] != NSNotFound) {
//		[self encodeUnsignedInt29:([_objectTable indexOfObject:value] << 1)];
//		return;
	}
	[_objectTable addObject:value];
	[self encodeUnsignedInt29:((0 << 1) | 1)];
	[self encodeDouble:([value timeIntervalSince1970] * 1000)];
}

- (void)_encodeNull {
	[self encodeUnsignedChar:kAMF3NullType];
}

- (void)_setCollectionWriteContext:(NSObject *)obj {
	if (m_writeStack == nil) m_writeStack = [[NSMutableArray alloc] init];
	[m_writeStack addObject:obj];
	m_currentObjectToWrite = obj;
}

- (void)_restoreCollectionWriteContext {
	[m_writeStack removeLastObject];
	m_currentObjectToWrite = [m_writeStack lastObject];
}


- (void)_encodeArray:(NSArray *)value {
	[self encodeUnsignedChar:kAMF3ArrayType];
	if ([_objectTable indexOfObjectIdenticalTo:value] != NSNotFound) {
//		[self encodeUnsignedInt29:([_objectTable indexOfObject:value] << 1)];
//		return;
	}
	[_objectTable addObject:value];
	[self encodeUnsignedInt29:(([value count] << 1) | 1)];
	[self encodeUnsignedChar:((0 << 1) | 1)];
	for (NSObject *obj in value) {
		[self encodeObject:obj];
	}
}

- (void)_encodeMixedArray:(NSDictionary *)value {
	[self encodeUnsignedChar:kAMF3ArrayType];
	if ([_objectTable indexOfObjectIdenticalTo:value] != NSNotFound) {
//		[self encodeUnsignedInt29:([_objectTable indexOfObject:value] << 1)];
//		return;
	}
	[_objectTable addObject:value];
	NSMutableArray *numericKeys = [[[NSMutableArray alloc] init] autorelease];
	NSMutableArray *stringKeys = [[[NSMutableArray alloc] init] autorelease];
	for (id key in value) {
		if ([key isKindOfClass:[NSString class]]) [stringKeys addObject:key];
		else if ([key isKindOfClass:[NSNumber class]]) [numericKeys addObject:key];
		else [NSException raise:NSInternalInconsistencyException 
						format:@"Cannot encode dictionary with key of class %@", [key className]];
	}
	[self encodeUnsignedInt29:(([numericKeys count] << 1) | 1)];
	for (NSString *key in stringKeys) {
		[self _encodeString:key omitType:YES];
		[self encodeObject:[value objectForKey:key]];
	}
	[self encodeUnsignedChar:((0 << 1) | 1)];
	for (NSNumber *key in numericKeys) {
		[self encodeObject:[value objectForKey:key]];
	}
}


- (void)_encodeDictionary:(NSDictionary *)value {
	[self _encodeMixedArray:value];
}


- (void)encodeObject:(NSObject *)value {
	MRLogFunc(5);
	if ([value isKindOfClass:[NSNumber class]]) {
		[self _encodeNumber:(NSNumber *)value];
		
	} else if ([value isKindOfClass:[NSString class]]) {
		[self _encodeString:(NSString *)value omitType:NO];
		
	} else if ([value isKindOfClass:[NSDate class]]) {
		[self _encodeDate:(NSDate *)value];
		
	} else if ([value isKindOfClass:[NSNull class]] || value == nil) {
		[self _encodeNull];
		
	} else if ([value isKindOfClass:[NSArray class]]) {
		[self _setCollectionWriteContext:value];
		[self _encodeArray:(NSArray *)value];
		[self _restoreCollectionWriteContext];
	
	} else if ([value isKindOfClass:[NSDictionary class]]) {	
		[self _setCollectionWriteContext:value];
		[self _encodeDictionary:(NSDictionary *)value];
		[self _restoreCollectionWriteContext];
	}
}

-(NSData *) encodeObject {
	MRLogFunc(5);
	[self encodeObject:_object];
	return _data;
}

-(void) dealloc {
	MRLogFunc(1);
	if (_data != nil && [_data retainCount] > 0) [_data release];
	if (_stringTable != nil) [_stringTable release];
	if (_objectTable != nil) [_objectTable release];
	[super dealloc];
}

@end


@implementation NSObject (iPhoneExtensions)

- (NSString *)className {
	return NSStringFromClass([self class]);
}

@end

