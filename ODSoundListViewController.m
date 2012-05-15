//
//  ODSoundListViewController.m
//  OpenAlarm
//
//  Created by Methuz Kaewsai-kao on 5/14/55 BE.
//  Copyright (c) 2555 joinstick.net@gmail.com. All rights reserved.
//

#import "ODSoundListViewController.h"
#import "ODSound.h"
#import "ODAlarmServices.h"

@interface ODSoundListViewController () {
    NSIndexPath *lastIndexPath;
}
@end

@implementation ODSoundListViewController

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        ODSound *s1 = [ODSound soundName:@"Basso" andType:@"aiff"];
        ODSound *s2 = [ODSound soundName:@"Blow" andType:@"aiff"];
        ODSound *s3 = [ODSound soundName:@"Glass" andType:@"aiff"];
        ODSound *s4 = [ODSound soundName:@"tap" andType:@"aif"];
        
        datasource = [NSArray arrayWithObjects:s1, s2, s3, s4, nil];
        selectedIndex=-1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backToCameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                        target:self action:@selector(back)];
    self.navigationItem.LeftBarButtonItem = backToCameraButton;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *saveToDB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                              target:self action:@selector(doneButton)];
    self.navigationItem.rightBarButtonItem = saveToDB;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButton
{
    if ([self.delegate respondsToSelector:@selector(soundController:didSelectSound:)]) {
        [self.delegate soundController:self didSelectSound:[self selectedSound]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datasource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    ODSound *currentSound = [datasource objectAtIndex:indexPath.row];
    cell.textLabel.text = currentSound.name;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* newCell = [tableView cellForRowAtIndexPath:indexPath]; 
    int newRow = [indexPath row]; 
    int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1; 
    
    if(newRow != oldRow) 
    { 
        newCell.accessoryType = UITableViewCellAccessoryCheckmark; 
        UITableViewCell* oldCell = [tableView cellForRowAtIndexPath:lastIndexPath]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        lastIndexPath = indexPath; 
        selectedIndex = indexPath.row;
    } else {
        if (newCell.accessoryType == UITableViewCellAccessoryCheckmark){
            newCell.accessoryType = UITableViewCellAccessoryNone;
            selectedIndex = -1;
            lastIndexPath = indexPath;
        }else {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            lastIndexPath = indexPath;
            selectedIndex = indexPath.row;
        }
    }
    
    
    ODSound *sound = [datasource objectAtIndex:indexPath.row];
    
    if (sound != nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[sound name] forKey:kSoundName];
        [userDefaults setObject:[sound type] forKey:kSoundType];
        [userDefaults synchronize];
    }
    
    [[ODAlarmServices sharedAlarmServices] alertWithSound:[sound name] withSoundType:[sound type]];
}

- (ODSound *)selectedSound
{
    if (selectedIndex < [datasource count]) {
        return [datasource objectAtIndex:selectedIndex];
    }
    return nil;
}

@end
