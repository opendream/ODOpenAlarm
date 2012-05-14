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

#define CELL_HEIGHT 70

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        imageViewInCell = [[UIImageView alloc] initWithFrame:CGRectMake(50, CELL_HEIGHT / 2 - 50 / 2, 50, 50)];
        [self.contentView addSubview:imageViewInCell];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 + 20,self.frame.origin.y + 10, 100, 20)];
        timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:timeLabel];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 + 20,self.frame.origin.y + 30, 100, 20)];
        detailLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:detailLabel];
        
        alarmSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, CELL_HEIGHT / 2 - 30 / 2, 100, 30)];
        [alarmSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.contentView addSubview:alarmSwitch];
        
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormat setDateFormat:@"HH : mm"];
        
        self.shouldIndentWhileEditing = NO; 
        self.clearsContextBeforeDrawing = YES;
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

- (void)layoutSubviews
{
    imageViewInCell.image = [UIImage imageNamed:@"Icon.png"];
    
    timeLabel.text = [dateFormat stringFromDate:[alarm fireDate]];
    detailLabel.text = [alarm title];
    
    [alarmSwitch setOn:[alarm enable].boolValue];
}

@end
