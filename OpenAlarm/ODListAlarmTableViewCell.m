//
//  ODListAlarmTableViewCell.m
//  OpenAlarm
//
//  Created by Pirapa on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODListAlarmTableViewCell.h"

@interface ODListAlarmTableViewCell()
{
    NSDateFormatter *dateFormat;
}
@end

@implementation ODListAlarmTableViewCell

@synthesize imageViewInCell, alarmSwitch;
@synthesize alarm;

#define CELL_HEIGHT 92

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
              
        imageViewInCell = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, CELL_HEIGHT)];
        imageViewInCell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageViewInCell.image = [UIImage imageNamed:@"bg.png"];
        [self.contentView addSubview:imageViewInCell];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x + self.frame.size.width*1/10, self.bounds.size.height / 2 + 25 / 2 , 100, 25)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont fontWithName:@"Gill Sans" size:24];
        detailLabel.shadowColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
        detailLabel.shadowOffset = CGSizeMake(1, 2);
        [self.contentView addSubview:detailLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x + self.frame.size.width*2/3, self.bounds.size.height / 2 + 25 / 2 , 100, 25)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont fontWithName:@"Gill Sans" size:24]; 
        timeLabel.shadowColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
        timeLabel.shadowOffset = CGSizeMake(1, 2);
        [self.contentView addSubview:timeLabel];
        
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormat setDateFormat:@"HH:mm"];
        
        self.shouldIndentWhileEditing = NO; 
        self.clearsContextBeforeDrawing = YES;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } 
    return self;
}

- (void)switchChanged:(id)sender
{
    [alarm setEnable:[NSNumber numberWithBool:[(UISwitch *)sender isOn]]];
    
    NSLog(@"ODListAlarmTableViewCell.m - switchChanged %@, sender class %@", sender, [sender class]);
    
    NSLog(@"Alarm enable flag : %@", alarm.enable.boolValue == YES ? @"YES" : @"NO");
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//}

/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        [self setEditingAccessoryType:UITableViewCellEditingStyleDelete];
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect f = self.imageViewInCell.frame;
//            f.origin.x = 50;
//            imageViewInCell.frame = f;
//        }];
    } else {
        [self setEditingAccessoryType:UITableViewCellEditingStyleNone];
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect f = self.imageViewInCell.frame;
//            f.origin.x = 20;
//            imageViewInCell.frame = f;
//        }];        
    }
}
 */

- (void)layoutSubviews
{
    timeLabel.text = [dateFormat stringFromDate:[alarm fireDate]];
    detailLabel.text = [alarm title];
    [alarmSwitch setOn:[alarm enable].boolValue];
}

@end
