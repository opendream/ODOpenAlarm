//
//  ODAlartViewController.h
//  OpenAlarm
//
//  Created by Pirapa on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ODAlertViewControllerDelegate;

@interface ODAlertViewController : UIViewController {
    __unsafe_unretained id <ODAlertViewControllerDelegate> delegate;
}

@property(unsafe_unretained) id <ODAlertViewControllerDelegate> delegate;
@property(strong, nonatomic) UILabel *alertMessege;
@property(strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)hideView:(id)sender;

@end

@protocol ODAlertViewControllerDelegate <NSObject>
@optional
- (void)alertViewDidStopAlarm:(ODAlertViewController *)controller;
@end
