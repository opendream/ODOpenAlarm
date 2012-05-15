//
//  ODEditLabelViewController.h
//  OpenAlarm
//
//  Created by In|Ce Saiaram on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ODEditLabelViewControllerDelegate;

@interface ODEditLabelViewController : UIViewController <UITextFieldDelegate> {
    __unsafe_unretained id <ODEditLabelViewControllerDelegate> delegate;
    
}

@property (unsafe_unretained) id <ODEditLabelViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *textLabel;
@property (weak, nonatomic) NSString *currentName;
@end

@protocol ODEditLabelViewControllerDelegate <NSObject>

- (void)shouldSaveTextLabel:(ODEditLabelViewController *)controller withString:(NSString *)text;

@end