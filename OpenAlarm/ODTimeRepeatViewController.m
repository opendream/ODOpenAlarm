//
//  ODTimeRepeatViewController.m
//  OpenAlarm
//
//  Created by Pirapa on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ODTimeRepeatViewController.h"

@interface ODTimeRepeatViewController ()

@end

@implementation ODTimeRepeatViewController

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
    repeatTimeTableView.dataSource = self;
    repeatTimeTableView.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//#pragma mark - PickerView
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return 10;
//}
//
//

//
//- (NSString *)pickerView:(UITableView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    switch (row) {
//        case 0:
//            return @"Everyday";
//            break;
//        case 1:
//            return @"Every Weekday";
//            break;
//        case 2:
//            return @"Every Weekend";
//            break;
//        case 3:
//            return @"Every Sunday";
//            break;
//        case 4:
//            return @"Every Monday";
//            break;
//        case 5:
//            return @"Every Tuesday";
//            break;
//        case 6:
//            return @"Every Wednesday";
//            break;
//        case 7:
//            return @"Every Thursday";
//            break;
//        case 8:
//            return @"Every Friday";
//            break;
//        case 9:
//            return @"Every Saturday";
//            break;
//        default:
//            return @"else";
//            break;
//    }
//}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60.0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UILabel *choiceRepeat; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
                
        choiceRepeat = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        [cell addSubview:choiceRepeat];
        
               
    }
       
    switch (indexPath.row) {
        case 0:
            choiceRepeat.text = @"Everyday";
            break;
        case 1:
            choiceRepeat.text = @"Every Weekday";
            break;
        case 2:
            choiceRepeat.text = @"Every Weekend";
            break;
        case 3:
            choiceRepeat.text = @"Every Sunday";
            break;
        case 4:
            choiceRepeat.text = @"Every Monday";
            break;
        case 5:
            choiceRepeat.text = @"Every Tuesday";
            break;
        case 6:
            choiceRepeat.text = @"Every Wednesday";
            break;
        case 7:
            choiceRepeat.text = @"Every Thursday";
            break;
        case 8:
            choiceRepeat.text = @"Every Friday";
            break;
        case 9:
            choiceRepeat.text = @"Every Saturday";
            break;
        default:
            choiceRepeat.text = @"else";
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ODTimeRepeatViewController *timeRepeat = [[ODTimeRepeatViewController alloc] init];
        [self.navigationController pushViewController:timeRepeat animated:YES];
    } else if (indexPath.row == 1) {
        ODTimeRepeatViewController *timeRepeat = [[ODTimeRepeatViewController alloc] init];
        [self.navigationController pushViewController:timeRepeat animated:YES];
    } else if (indexPath.row == 2) {
        ODTimeRepeatViewController *timeRepeat = [[ODTimeRepeatViewController alloc] init];
        [self.navigationController pushViewController:timeRepeat animated:YES];
    }
    
}




@end
