//
//  ODAlartViewController.h
//  OpenAlarm
//
//  Created by Pirapa on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODAlertViewController : UIViewController {
}

@property(strong, nonatomic) UILabel *alertMessege;
@property(strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)hideView:(id)sender;
@end
