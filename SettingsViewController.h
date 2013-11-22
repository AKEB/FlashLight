//
//  SettingsViewController.h
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

@class AppDelegate_iPhone;

@interface SettingsViewController : UIViewController {
	AppDelegate_iPhone *delegate;
	
	UISlider *redSlider;
	UISlider *greenSlider;
	UISlider *blueSlider;
	
	UISwitch *flashButt;
	UILabel *flashLabel;
	
	UIView *viewPrev;
	
	
	
}
@property (nonatomic, retain) AppDelegate_iPhone *delegate;

@property (nonatomic, retain) IBOutlet UISlider *redSlider;
@property (nonatomic, retain) IBOutlet UISlider *greenSlider;
@property (nonatomic, retain) IBOutlet UISlider *blueSlider;
@property (nonatomic, retain) IBOutlet UIView *viewPrev;

@property (nonatomic, retain) IBOutlet UISwitch *flashButt;
@property (nonatomic, retain) IBOutlet UILabel *flashLabel;

-(IBAction) Main;
-(IBAction) ChangeColor;
-(void) SaveColor;


@end
