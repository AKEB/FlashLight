//
//  MRRequest.m
//  AMFObject
//
//  Created by AKEB on 1/12/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import "MRRequest.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global 

static NSString* kUserAgent = @"MRUserAgent";
static NSString* kStringBoundary = @"863be5d6a805f282194406c5aefa6d77";
static const int kGeneralErrorCode = 10000;

static const NSTimeInterval kTimeoutInterval = 180.0;

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MRRequest

@synthesize delegate     = _delegate,
url          = _url,
httpMethod   = _httpMethod,
params       = _params,
connection   = _connection,
responseText = _responseText,
typeResult   = _typeResult,
data         = _data,
lenght       = _lenght;

//////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (MRRequest*)getRequestWithData:(NSData *) data
						   lenght:(NSUInteger) lenght
						 delegate:(id<MRRequestDelegate>)delegate
					   requestURL:(NSString *) url
					   typeResult:(NSString *) type {
	MRLogFunc(1);
	MRRequest* request    = [[[MRRequest alloc] init] autorelease];
	request.delegate      = delegate; 
	request.url           = [url retain];
	request.httpMethod    = @"POST";
	request.data          = [data retain];
	request.lenght        = lenght;
	request.typeResult    = [type retain];
	request.connection    = nil;
	request.responseText  = nil;
	
	return request;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// private

/**
 * Generate get URL
 */
- (NSString*)generateGetURL {
	MRLogFunc(1);
	NSURL* parsedURL = [NSURL URLWithString:_url];
	NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
	
	NSMutableArray* pairs = [NSMutableArray array];
	for (NSString* key in [_params keyEnumerator]) {
		if (([[_params valueForKey:key] isKindOfClass:[UIImage class]]) 
			||([[_params valueForKey:key] isKindOfClass:[NSData class]])) {
			if ([_httpMethod isEqualToString:@"GET"]) {
				MRLog(@"can not use GET to upload a file");      
			}
			continue;
		} 
		
		NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																					  NULL, /* allocator */
																					  (CFStringRef)[_params objectForKey:key],
																					  NULL, /* charactersToLeaveUnescaped */
																					  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																					  kCFStringEncodingUTF8);
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
		[escaped_value release];
	}
	NSString* params = [pairs componentsJoinedByString:@"&"];
	
	return [NSString stringWithFormat:@"%@%@%@", _url, queryPrefix, params];
}

/**
 * Body append for POST method
 */
- (void)utfAppendBody:(NSMutableData*)body data:(NSString*)data {
	MRLogFunc(1);
	[body appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}

/**
 * Generate body for POST method
 */
- (NSMutableData *)generatePostBody {
	MRLogFunc(1);
	NSMutableData *body = [NSMutableData data];
	NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary];
	NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
	
	[self utfAppendBody:body data:[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]];
	
	for (id key in [_params keyEnumerator]) {
		
		if (([[_params valueForKey:key] isKindOfClass:[UIImage class]]) 
			||([[_params valueForKey:key] isKindOfClass:[NSData class]])) {
			
			[dataDictionary setObject:[_params valueForKey:key] forKey:key];
			continue;
			
		}
		
		[self utfAppendBody:body
					   data:[NSString 
							 stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", 
							 key]];
		[self utfAppendBody:body data:[_params valueForKey:key]];
		
		[self utfAppendBody:body data:endLine];   
	}
	
	if ([dataDictionary count] > 0) {
		for (id key in dataDictionary) {
			NSObject *dataParam = [dataDictionary valueForKey:key];
			if ([dataParam isKindOfClass:[UIImage class]]) {
				NSData* imageData = UIImagePNGRepresentation((UIImage*)dataParam);
				[self utfAppendBody:body
							   data:[NSString stringWithFormat:
									 @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]];
				[self utfAppendBody:body
							   data:[NSString stringWithString:@"Content-Type: image/png\r\n\r\n"]];
				[body appendData:imageData];
			} else {
				NSAssert([dataParam isKindOfClass:[NSData class]], 
						 @"dataParam must be a UIImage or NSData");
				[self utfAppendBody:body
							   data:[NSString stringWithFormat:
									 @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]];
				[self utfAppendBody:body
							   data:[NSString stringWithString:@"Content-Type: content/unknown\r\n\r\n"]];
				[body appendData:(NSData*)dataParam];
			}
			[self utfAppendBody:body data:endLine];          
			
		}
	}
	
	return body;
}

- (NSMutableData *)generatePostData {
	MRLogFunc(1);
	NSMutableData *body = [NSMutableData dataWithBytes:[_data bytes] length:_lenght];
	return body;
}

/**
 * Formulate the NSError
 */
- (id) formError:(NSInteger)code userInfo:(NSDictionary *) errorData {
	MRLogFunc(1);
	return [NSError errorWithDomain:@"facebookErrDomain" code:code userInfo:errorData];
	
}

/*
 * private helper function: call the delegate function when the request fail with Error 
 */
- (void)failWithError:(NSError*)error {
	MRLogFunc(1);
	if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
		[_delegate request:self didFailWithError:error];
	}
}

/*
 * private helper function: handle the response data 
 */
- (void)handleResponseData:(NSData*)data {
	MRLogFunc(1);
	NSError* error = nil;
	id result;
	if ([[self typeResult] isEqual:@"TEXT"]) {
		result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	} else if ([[self typeResult] isEqual:@"AMF"]) {
		MRAmf *amf = [MRAmf AMFWithdata:data];
		result = [amf decodeObject];
	} else {
		result = data;
	}
	if (error) {
		[self failWithError:error];
	} else if ([_delegate respondsToSelector:@selector(request:didLoad:)]) {
		[_delegate request:self didLoad:result];
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// public

/**
 * @return boolean - whether this request is processing
 */
- (BOOL)loading {
	MRLogFunc(1);
	return !!_connection;
}

/**
 * make the Facebook request
 */
- (void)connect {
	MRLogFunc(1);
	if ([_delegate respondsToSelector:@selector(requestLoading:)]) {
		[_delegate requestLoading:self];
	}
	
	NSString* url = [self generateGetURL];
	NSMutableURLRequest* request = 
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
							cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                        timeoutInterval:kTimeoutInterval];
	[request setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
	
	
	[request setHTTPMethod:self.httpMethod];
	if ([self.httpMethod isEqualToString: @"POST"]) {  
		if (_lenght) {
			[request setHTTPBody:[NSData dataWithBytes:[_data bytes] length:_lenght]];
		} else {
			NSString* contentType = [NSString
									 stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
			[request setValue:contentType forHTTPHeaderField:@"Content-Type"];
			
			[request setHTTPBody:[self generatePostBody]];
		}
	}
	
	_connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self]  retain];
	
}

/**
 * Free internal structure
 */
- (void)dealloc {
	MRLogFunc(1);
	[_connection cancel];
	[_data release];
	[_connection release];
	[_responseText release];
	[_url release];
	[_httpMethod release];
	[_params release];
	[super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// NSURLConnectionDelegate

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
	MRLogFunc(1);
	_responseText = [[NSMutableData alloc] init];
	
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
	if ([_delegate respondsToSelector:@selector(request:didReceiveResponse:)]) {    
		[_delegate request:self didReceiveResponse:httpResponse];
	}
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
	MRLogFunc(1);
	[_responseText appendData:data];
}

- (NSCachedURLResponse*)connection:(NSURLConnection*)connection
				 willCacheResponse:(NSCachedURLResponse*)cachedResponse {
	MRLogFunc(1);
	return nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection {
	MRLogFunc(1);
	[self handleResponseData:_responseText];
	
	[_responseText release];
	_responseText = nil;
	[_connection release];
	_connection = nil;
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
	MRLogFunc(1);
	[self failWithError:error];
	
	[_responseText release];
	_responseText = nil;
	[_connection release];
	_connection = nil;
}

@end

