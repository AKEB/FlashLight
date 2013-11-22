//
//  MainViewController.h
//  FlashLight
//
//  Created by AKEB on 8/26/10.
//  Copyright 2010 AKEB.RU. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef __IPHONE_4_0
	#import <AVFoundation/AVFoundation.h>
#endif
#import "MR.h"

#ifdef __IPHONE_4_1
#import <iAd/iAd.h>
#endif
#import "GADBannerView.h"

@class AppDelegate_iPhone;

@interface MainViewController : UIViewController<ADBannerViewDelegate> {
	AppDelegate_iPhone *delegate;
	UIButton *infoDark;
	UIButton *infoLight;
	BOOL bannerIsVisible;
	UIView *rootview;
	int cnt;
	BOOL FlashON;
	BOOL curFlashOn;
#ifdef __IPHONE_4_0
	AVCaptureSession *torchSession;
#endif
	
#ifdef __IPHONE_4_1
	ADBannerView *bann;
#endif
	GADBannerView *bannerView_;
	
}
@property (nonatomic, retain) AppDelegate_iPhone *delegate;
@property (nonatomic, retain) IBOutlet UIButton *infoDark;
@property (nonatomic, retain) IBOutlet UIButton *infoLight;
@property (nonatomic, retain) IBOutlet UIView *rootview;
#ifdef __IPHONE_4_0
@property (nonatomic, retain) AVCaptureSession * torchSession;
#endif

-(NSString *)MD5:(NSString *)source;
-(IBAction) Setting;
-(void) ChangeColor;
-(void) Send:(id)sender;
- (void) toggleTorch:(BOOL)on;

@end
