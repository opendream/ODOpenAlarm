//
//  ODAlartViewController.m
//  OpenAlarm
//
//  Created by Pirapa on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODAlertViewController.h"

@implementation ODAlertViewController

@synthesize delegate;
@synthesize alertMessege;
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIView *textBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120.0)];
        textBackground.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        alertMessege = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 280, 80)];
        alertMessege.backgroundColor = [UIColor clearColor];
        alertMessege.textColor = [UIColor whiteColor];
        alertMessege.textAlignment = UITextAlignmentCenter;
        alertMessege.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
        [textBackground addSubview:alertMessege];
        [self.view addSubview:textBackground];
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)hideView:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(alertViewDidStopAlarm:)]) {
        [self.delegate alertViewDidStopAlarm:self];
    }
}

@end
