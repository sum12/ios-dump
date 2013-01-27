//
//  FlickerFetcherTableViewController.m
//  ShutterBug
//
//  Created by sumit jamgade on 1/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FlickerFetcherTableViewController.h"
#import "FlickrFetcher.h"

@implementation FlickerFetcherTableViewController



@synthesize data = _data;


- (void) setPhotos:(NSMutableArray *)data
{
    _data =data;
    NSLog(@"relload data");
    [self.tableView reloadData];
}

- (IBAction)refresh:(id)sender {
    __block NSArray* data;
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    NSString * titleOfTab = [self.navigationItem.title copy];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:spinner];
    dispatch_queue_t downloadQueue = dispatch_queue_create("FlicrkrDownloader", NULL);
    dispatch_async(downloadQueue, ^{
        
        if ([titleOfTab isEqualToString:@"Top Places"]) {
            data = [FlickrFetcher topPlaces];
        }
        else{
            data = [FlickrFetcher recentGeoreferencedPhotos];
        }dispatch_async(dispatch_get_main_queue(), ^{
            self.data = data;
            [self.tableView reloadData];
            self.navigationItem.rightBarButtonItem = sender;
            NSLog(@"%d",[self.data count]);
        });
    });
    dispatch_release(downloadQueue);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    if ([self.navigationItem.title isEqualToString:@"Top Places"]) {
        NSDictionary* placeData = [self.data objectAtIndex:indexPath.row];
        NSArray * placeArray = [[placeData valueForKey:@"_content"]componentsSeparatedByString:@","];
        cell.textLabel.text = [placeArray objectAtIndex:0];
        cell.detailTextLabel.text = [placeArray componentsJoinedByString:@","];
    }
    else
    {
        NSDictionary * photo = [self.data objectAtIndex:indexPath.row];
        cell.textLabel.text = [photo objectForKey:FLICKR_PHOTO_TITLE];
        cell.detailTextLabel.text = [photo objectForKey:FLICKR_PHOTO_OWNER];
    }
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
}

@end
