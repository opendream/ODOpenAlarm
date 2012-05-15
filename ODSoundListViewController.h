//
//  ODSoundListViewController.h
//  OpenAlarm
//
//  Created by Methuz Kaewsai-kao on 5/14/55 BE.
//  Copyright (c) 2555 joinstick.net@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODSound;

@protocol ODSoundListViewControllerDelegate;

@interface ODSoundListViewController : UITableViewController
{
    __unsafe_unretained id <ODSoundListViewControllerDelegate> delegate;
    NSArray *datasource; //sound list
    NSInteger selectedIndex;
}

@property (unsafe_unretained) id <ODSoundListViewControllerDelegate> delegate;

- (ODSound *)selectedSound;

@end

@protocol ODSoundListViewControllerDelegate <NSObject>

- (void)soundController:(ODSoundListViewController *)controller didSelectSound:(ODSound *)sound;

@end