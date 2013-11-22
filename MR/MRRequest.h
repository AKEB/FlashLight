//
//  MRRequest.h
//  AMFObject
//
//  Created by AKEB on 1/12/11.
//  Copyright 2011 AKEB.RU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MRConfig.h"
#import "MRDefine.h"
#import "MRLog.h"
#import "MRAmf.h"

@protocol MRRequestDelegate;

@interface MRRequest : NSObject {
	id<MRRequestDelegate> _delegate;
	NSString*             _url;
	NSString*             _httpMethod;
	NSMutableDictionary*  _params;
	NSURLConnection*      _connection;
	NSMutableData*        _responseText;
	NSString*			  _typeResult;
	NSData*				  _data;
	NSUInteger            _lenght;
	
}
@property(nonatomic,assign) id<MRRequestDelegate> delegate;
@property(nonatomic,copy) NSString* url;
@property(nonatomic,copy) NSString* httpMethod;
@property(nonatomic,assign) NSMutableDictionary* params;
@property(nonatomic,copy) NSData* data;
@property(nonatomic) NSUInteger lenght;
@property(nonatomic,assign) NSURLConnection*  connection;
@property(nonatomic,assign) NSMutableData* responseText;
@property(nonatomic,assign) NSString* typeResult;

+ (MRRequest*)getRequestWithData:(NSData *) data
						   lenght:(NSUInteger) lenght
						 delegate:(id<MRRequestDelegate>)delegate
					   requestURL:(NSString *) url
					   typeResult:(NSString *) type;


- (BOOL) loading;
- (void) connect;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MRRequestDelegate <NSObject>

@optional

- (void)requestLoading:(MRRequest*)request;
- (void)request:(MRRequest*)request didReceiveResponse:(NSURLResponse*)response;
- (void)request:(MRRequest*)request didFailWithError:(NSError*)error;
- (void)request:(MRRequest*)request didLoad:(id)result;

@end
