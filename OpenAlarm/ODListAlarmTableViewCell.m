//
//  ODListAlarmTableViewCell.m
//  OpenAlarm
//
//  Created by Pirapa on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODListAlarmTableViewCell.h"

@implementation ODListAlarmTableViewCell

@synthesize timeLabel;
@synthesize detailLabel;
@synthesize imageViewInCell, alarmSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        [super layoutSubviews];
        
        imageViewInCell = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x + 5, self.frame.origin.y, 70, 70)];
        [self.contentView addSubview:imageViewInCell];
        
        imageViewInCell.image = [UIImage imageNamed:@"Icon.png"];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 + 20,self.frame.origin.y + 10, 100, 20)];
        timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:timeLabel];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 + 20,self.frame.origin.y + 30, 100, 20)];
        detailLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:detailLabel];
        
//        alarmSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(detailLabel.frame.origin.x + 120,self.frame.origin.y + 20, 30, 30)];
//        [self addSubview:alarmSwitch];
        
        self.shouldIndentWhileEditing = YES;    
    } 
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    NSLog(@"Edit in cell %@",editing == YES ? @"YES" : @"NO");
    if (editing) {
        [self setEditingAccessoryType:UITableViewCellEditingStyleDelete];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect f = self.imageViewInCell.frame;
            f.origin.x = 100;
            imageViewInCell.frame = f;
        }];
    } else {
        [self setEditingAccessoryType:UITableViewCellEditingStyleNone];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect f = self.imageViewInCell.frame;
            f.origin.x = 5;
            imageViewInCell.frame = f;
        }];        
    }
}

- (void)layoutSubviews
{

}

@end
