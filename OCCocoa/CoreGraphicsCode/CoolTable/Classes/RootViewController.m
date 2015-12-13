//
//  RootViewController.m
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "RootViewController.h"
#import "CustomCellBackground.h"
#import "CustomHeader.h"
#import "CustomFooter.h"

@implementation RootViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Core Graphics 101";
    self.thingsToLearn = [NSMutableArray arrayWithObjects:@"Drawing Rects", @"Drawing Gradients", @"Drawing Arcs", nil];
    self.thingsLearned = [NSMutableArray arrayWithObjects:@"Table Views", @"UIKit", @"Objective-C", nil];
    
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}



#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Things We'll Learn";
    } else {
        return @"Things Already Covered";
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CustomHeader *header = [[[CustomHeader alloc] init] autorelease];        
    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    if (section == 1) {
        header.lightColor = [UIColor colorWithRed:147.0/255.0 green:105.0/255.0 blue:216.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:72.0/255.0 green:22.0/255.0 blue:137.0/255.0 alpha:1.0];
    }
    return header;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[[CustomFooter alloc] init] autorelease];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _thingsToLearn.count;
    } else {
        return _thingsLearned.count;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundView = [[[CustomCellBackground alloc] init] autorelease];
        cell.selectedBackgroundView = [[[CustomCellBackground alloc] init] autorelease];
        ((CustomCellBackground *)cell.selectedBackgroundView).selected = YES;
    }
    
	// Configure the cell.
    NSString *entry;
    if (indexPath.section == 0) {
        entry = [_thingsToLearn objectAtIndex:indexPath.row];
        ((CustomCellBackground *)cell.backgroundView).lastCell = indexPath.row == _thingsToLearn.count - 1;
        ((CustomCellBackground *)cell.selectedBackgroundView).lastCell = indexPath.row == _thingsToLearn.count - 1;
    } else {
        entry = [_thingsLearned objectAtIndex:indexPath.row];
        ((CustomCellBackground *)cell.backgroundView).lastCell = indexPath.row == _thingsLearned.count - 1;
        ((CustomCellBackground *)cell.selectedBackgroundView).lastCell = indexPath.row == _thingsLearned.count - 1;
    }        
    cell.textLabel.text = entry;
    cell.textLabel.backgroundColor = [UIColor clearColor];    
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.thingsToLearn = nil;
    self.thingsLearned = nil;
}


- (void)dealloc {
    [_thingsToLearn release];
    _thingsToLearn = nil;
    [_thingsLearned release];
    _thingsLearned = nil;
    [super dealloc];
}


@end

