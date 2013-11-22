//
//  SettingsViewController.m
//  FlashLight
//
//  Created by AKEB on 8/26/10.
//  Copyright 2010 AKEB.RU. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController


@synthesize delegate;
@synthesize redSlider;
@synthesize greenSlider;
@synthesize blueSlider;
@synthesize viewPrev;
@synthesize flashLabel, flashButt;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	MRLogFunc(1);
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		
		
    }
    return self;
}

-(IBAction) Main {
	MRLogFunc(1);
	[self SaveColor];
	[delegate Main];
}


-(IBAction) ChangeColor {
	MRLogFunc(1);
	UIColor *backColor = [[UIColor alloc] initWithRed:redSlider.value green:greenSlider.value blue:blueSlider.value alpha:1.0];
	viewPrev.backgroundColor = backColor;
}


-(void) SaveColor {
	MRLogFunc(1);
	
	[[MRSettings sharedController] setFloat:redSlider.value forKey:@"Red"];
	[[MRSettings sharedController] setFloat:greenSlider.value forKey:@"Green"];
	[[MRSettings sharedController] setFloat:blueSlider.value forKey:@"Blue"];
	[[MRSettings sharedController] setBool:[flashButt isOn] forKey:@"Flash"];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	MRLogFunc(1);
    [super viewDidLoad];
	
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	if ([systemVersion intValue] >= 4) {
		#ifdef __IPHONE_4_0
		AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		if ([device hasFlash]){
			[flashButt setHidden:false];
			[flashLabel setHidden:false];
		}
		#endif
	}
	
	[redSlider setValue:[[MRSettings sharedController] floatForKey:@"Red"]];
	[greenSlider setValue:[[MRSettings sharedController] floatForKey:@"Green"]];
	[blueSlider setValue:[[MRSettings sharedController] floatForKey:@"Blue"]];
	[flashButt setOn:[[MRSettings sharedController] boolForKey:@"Flash"]];

	[self ChangeColor];
	
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	MRLogFunc(1);
    [super dealloc];
}


@end
