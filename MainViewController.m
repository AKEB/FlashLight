//
//  MainViewController.m
//  FlashLight
//
//  Created by AKEB on 8/26/10.
//  Copyright 2010 AKEB.RU. All rights reserved.
//

#import "MainViewController.h"


#ifdef __IPHONE_4_1
#import <iAd/iAd.h>
#endif

@implementation MainViewController


@synthesize delegate;
@synthesize infoDark;
@synthesize infoLight;
@synthesize rootview;

#ifdef __IPHONE_4_0
@synthesize torchSession;
#endif

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	MRLogFunc(1);
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
       
    }
    return self;
}

-(IBAction) Setting {
	MRLogFunc(1);
	[delegate Setting];
	
}


	// This method requires adding #import <CommonCrypto/CommonDigest.h> to your source file.
- (NSString *)hashedISU {
	NSString *result = nil;
	NSString *isu = @"";//[UIDevice currentDevice].uniqueIdentifier;
	
	if(isu) {
		unsigned char digest[16];
		NSData *data = [isu dataUsingEncoding:NSASCIIStringEncoding];
		CC_MD5([data bytes], [data length], digest);
		
		result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				  digest[0], digest[1],
				  digest[2], digest[3],
				  digest[4], digest[5],
				  digest[6], digest[7],
				  digest[8], digest[9],
				  digest[10], digest[11],
				  digest[12], digest[13],
				  digest[14], digest[15]];
		result = [result uppercaseString];
	}
	return result;
}

- (void)reportAppOpenToAdMob {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // we're in a new thread here, so we need our own autorelease pool
																// Have we already reported an app open?
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
																		NSUserDomainMask, YES) objectAtIndex:0];
	NSString *appOpenPath = [documentsDirectory stringByAppendingPathComponent:@"admob_app_open"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:appOpenPath]) {
			// Not yet reported -- report now
		NSString *appOpenEndpoint = [NSString stringWithFormat:@"http://a.admob.com/f0?isu=%@&md5=1&app_id=%@",
									 [self hashedISU], MY_UNIT_ID];
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appOpenEndpoint]];
		NSURLResponse *response;
		NSError *error = nil;
		NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		if((!error) && ([(NSHTTPURLResponse *)response statusCode] == 200) && ([responseData length] > 0)) {
			[fileManager createFileAtPath:appOpenPath contents:nil attributes:nil]; // successful report, mark it as such
		}
	}
	[pool release];
}







#ifdef __IPHONE_4_1
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
		//NSLog(@"bannerView didFailToReceiveAdWithError");
	[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
	banner.frame = CGRectOffset(banner.frame, 0, 50);
	[UIView commitAnimations];
	
	bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
											self.view.frame.size.height -
											GAD_SIZE_320x50.height,
											GAD_SIZE_320x50.width,
											GAD_SIZE_320x50.height)];
	
		// Specify the ad's "unit identifier." This is your AdMob Publisher ID.
	bannerView_.adUnitID = MY_BANNER_UNIT_ID;
	
		// Let the runtime know which UIViewController to restore after taking
		// the user wherever the ad goes and add it to the view hierarchy.
	bannerView_.rootViewController = self;
	[rootview addSubview:bannerView_];
	
		// Initiate a generic request to load it with an ad.
	[bannerView_ loadRequest:[GADRequest request]];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
		//NSLog(@"bannerViewDidLoadAd");
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
		//NSLog(@"bannerViewActionDidFinish");
}
#endif

-(void) BannerLoad:(id)sender {
	NSLog(@"Banner Load");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#ifdef __IPHONE_4_1
	bann = [[ADBannerView alloc] init];
	[bann setFrame:CGRectMake(0, 0, 320, 50)];
	[bann setDelegate:self];
	[rootview addSubview:bann];
#else
	bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
											self.view.frame.size.height -
											GAD_SIZE_320x50.height,
											GAD_SIZE_320x50.width,
											GAD_SIZE_320x50.height)];
	
		// Specify the ad's "unit identifier." This is your AdMob Publisher ID.
	bannerView_.adUnitID = MY_BANNER_UNIT_ID;
	
		// Let the runtime know which UIViewController to restore after taking
		// the user wherever the ad goes and add it to the view hierarchy.
	bannerView_.rootViewController = self;
	[rootview addSubview:bannerView_];
	
		// Initiate a generic request to load it with an ad.
	[bannerView_ loadRequest:[GADRequest request]];
#endif
	[pool release];
}



-(void) ChangeColor {
	MRLogFunc(1);
	
	float red = [[MRSettings sharedController] floatForKey:@"Red"];
	float green = [[MRSettings sharedController] floatForKey:@"Green"];
	float blue = [[MRSettings sharedController] floatForKey:@"Blue"];
	FlashON = [[MRSettings sharedController] boolForKey:@"Flash"];
	
	UIColor *backColor = [[UIColor alloc] 
						  initWithRed: red 
						  green: green 
						  blue: blue 
						  alpha:1.0];
	self.view.backgroundColor = backColor;
	if (red + green + blue >= 1.5) {
		[infoDark setHidden:false];
		[infoLight setHidden:true];
	} else {
		[infoDark setHidden:true];
		[infoLight setHidden:false];
	}
	[self toggleTorch:true];
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	MRLogFunc(1);
	
	[super viewDidLoad];
	[self ChangeColor];
	
	[self performSelectorInBackground:@selector(reportAppOpenToAdMob) withObject:nil];
	
	[self performSelectorInBackground:@selector(BannerLoad:) withObject:nil];
	[self performSelectorInBackground:@selector(Send:) withObject:nil];
}

- (void) toggleTorch:(BOOL)on {
	MRLogFunc(1);
	
	if (!FlashON) on = false;
	
	if (on && curFlashOn) return;
	if (!on && !curFlashOn) return;
	
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	
	MRLog(@"%d",[systemVersion intValue]);
	if ([systemVersion intValue] < 4) return;
	
	#ifdef __IPHONE_4_0
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	
	if ([device hasFlash]){
		MRLog(@"Device HasFlash");
		if (on && !curFlashOn) {
			[self setTorchSession:nil];
			MRLog(@"It's currently off.. turning on now.");
			MRLog(@"1");
			AVCaptureDeviceInput *flashInput = [AVCaptureDeviceInput deviceInputWithDevice:device error: nil];
			MRLog(@"2");
			AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
			MRLog(@"3");
			AVCaptureSession *session = [[AVCaptureSession alloc] init];
			MRLog(@"4");
			[session beginConfiguration];
			MRLog(@"5");
			[device lockForConfiguration:nil];
			MRLog(@"6");
			[device setTorchMode:AVCaptureTorchModeOn];
			MRLog(@"7");
			[device setFlashMode:AVCaptureFlashModeOn];
			MRLog(@"8");
			[session addInput:flashInput];
			MRLog(@"9");
			[session addOutput:output];
			MRLog(@"10");
			[device unlockForConfiguration];
			MRLog(@"11");
			[output release];
			MRLog(@"12");
			[session commitConfiguration];
			MRLog(@"13");
			[session startRunning];
			MRLog(@"14");
			[self setTorchSession:session];
			MRLog(@"15");
			[session release];
			curFlashOn = true;
			MRLog(@"OK");
			
		}
		if (!on && curFlashOn) {
			MRLog(@"It's currently on.. turning off now.");
			[torchSession stopRunning];
			curFlashOn = false;
		}
	}
	#endif
	MRLog(@"toggleTorch END");
}	


-(NSString *)MD5:(NSString *)source {
	const char *src = [source UTF8String];
	unsigned char result[16];
	CC_MD5(src, strlen(src), result);
	
	NSString *ret = [[[NSString alloc] initWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
					  result[0], result[1], result[2], result[3],
					  result[4], result[5], result[6], result[7],
					  result[8], result[9], result[10], result[11],
					  result[12], result[13], result[14], result[15]
					  ] autorelease];
	NSString *Out = [ret lowercaseString];
	return Out;
}

-(void) Send:(id)sender {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	MRLogFunc(1);
	
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	NSString *uniqId = [[UIDevice currentDevice] uniqueIdentifier];
	NSString *StringForHash = [NSString stringWithFormat:@"%@app_id=3version=210system=%@uniqid=%@",@"Akeb45657Secret234d",systemVersion,uniqId];
	NSString *hash = [self MD5:StringForHash];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.akeb.ru/pub/iPhoneApi.php?action=add_user&version=210&app_id=3&system=%@&uniqid=%@&hash=%@",systemVersion,uniqId,hash]];
	[NSString stringWithContentsOfURL:url];
	[pool release];
}

- (void)didReceiveMemoryWarning {
	MRLogFunc(1);
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	MRLogFunc(1);
    [super viewDidUnload];
	
	if (bannerView_)  [bannerView_ release];
	if (bann)  [bann release];
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	MRLogFunc(1);
    [super dealloc];
}

@end
