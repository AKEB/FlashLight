//
//  AppDelegate_iPhone.h
//  FlashLight
//
//  Created by AKEB on 8/26/10.
//  Copyright AKEB.RU 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MR.h"


@class MainViewController;
@class SettingsViewController;

@interface AppDelegate_iPhone : MRAppDelegate {
    UIWindow *window;
	MainViewController *viewController;
	SettingsViewController *settingsViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *viewController;
@property (nonatomic, retain) IBOutlet SettingsViewController *settingsViewController;

-(IBAction) Setting;
-(IBAction) Main;
@end

