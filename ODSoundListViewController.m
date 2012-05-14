//
//  ODSoundListViewController.m
//  OpenAlarm
//
//  Created by Methuz Kaewsai-kao on 5/14/55 BE.
//  Copyright (c) 2555 joinstick.net@gmail.com. All rights reserved.
//

#import "ODSoundListViewController.h"
#import "ODSound.h"
@interface ODSoundListViewController ()
{
    NSIndexPath *lastIndexPath;

}
@end

@implementation ODSoundListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        ODSound *s1 = [ODSound soundName:@"tap" andType:@"aif"];
        ODSound *s2 = [ODSound soundName:@"tap" andType:@"aif"];
        ODSound *s3 = [ODSound soundName:@"tap" andType:@"aif"];
        ODSound *s4 = [ODSound soundName:@"tap" andType:@"aif"];
        
        datasource = [NSArray arrayWithObjects:s1, s2, s3, s4, nil];
        selectedIndex=-1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datasource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    ODSound *currentSound = [datasource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = currentSound.name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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
    
    NSLog(@"selectedIndex >>>>>> %d",selectedIndex);
    
}

@end
