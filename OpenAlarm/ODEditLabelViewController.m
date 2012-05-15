//
//  ODEditLabelViewController.m
//  OpenAlarm
//
//  Created by In|Ce Saiaram on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODEditLabelViewController.h"

@interface ODEditLabelViewController ()

@end

@implementation ODEditLabelViewController
@synthesize textLabel;
@synthesize delegate;
@synthesize currentName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.textLabel.text = currentName;
    
    self.textLabel.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textLabel becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.textLabel resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setTextLabel:nil];
    [super viewDidUnload];
}

- (void)save:(id)sender
{
    [self.delegate shouldSaveTextLabel:self withString:textLabel.text];

}

- (void)cancel:(id)sender
{
    [self.delegate shouldSaveTextLabel:self withString:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate shouldSaveTextLabel:self withString:textField.text];
    return YES;
}
@end
