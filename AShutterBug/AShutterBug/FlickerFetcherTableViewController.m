//
//  FlickerFetcherTableViewController.m
//  ShutterBug
//
//  Created by sumit jamgade on 1/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FlickerFetcherTableViewController.h"
#import "FlickrFetcher.h"

@interface FlickerFetcherTableViewController()

@property (nonatomic) int selectedIndex;
@property (nonatomic,strong) NSDictionary * dict;

@end



@implementation FlickerFetcherTableViewController

@synthesize data = _data;
@synthesize selectedIndex = _selectedIndex;
@synthesize dict = _dict;


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
    dispatch_queue_t downloadQueue = dispatch_queue_create("FlickrDownloader", NULL);
    dispatch_async(downloadQueue, ^{
        
        if ([titleOfTab isEqualToString:@"Top Places"]) {
            data = [FlickrFetcher topPlaces];
        }
        else if ([titleOfTab isEqualToString:@"Top Photos"]){
            data = [FlickrFetcher recentGeoreferencedPhotos];
        }
        else{
            data = [FlickrFetcher photosInPlace:self.dict maxResults:10];
            NSLog([data description]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
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
    if ([self.navigationItem.title isEqualToString:@"PhotosByPlace"]) {
        CellIdentifier =@"Flickr Photo new";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        NSLog(@"creating with subtitle");
    }
    
    
    if ([self.navigationItem.title isEqualToString:@"Top Places"]) {
        NSDictionary* placeData = [self.data objectAtIndex:indexPath.row];
        NSArray * placeArray = [[placeData valueForKey:@"_content"]componentsSeparatedByString:@","];
        cell.textLabel.text = [placeArray objectAtIndex:0];
        cell.detailTextLabel.text = [placeArray componentsJoinedByString:@","];
    }
    else if([self.navigationItem.title isEqualToString:@"Top Photos"]) {
        //get data from NSUserDefaults
    }
    else if ([self.navigationItem.title isEqualToString:@"PhotosByPlace"]) {
        NSDictionary * photo = [self.data objectAtIndex:indexPath.row];
        NSString * title = [photo objectForKey:FLICKR_PHOTO_TITLE];
        NSString * subtitle = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        if (title) {
            cell.textLabel.text = title;
            cell.detailTextLabel.text = subtitle;
        }
        else if(subtitle){
            cell.textLabel.text =subtitle;
            cell.detailTextLabel.text = @"tsting";
        }
        else{
            cell.textLabel.text = @"<Unknown>";
            cell.detailTextLabel.text = @"<Unkown>";
        }
        NSLog(CellIdentifier);
    }
    return cell;
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PlaceToPhotoSegue"])
    {
        FlickerFetcherTableViewController * dVC = (FlickerFetcherTableViewController*)segue.destinationViewController;
        dVC.dict = [[self.data objectAtIndex:self.selectedIndex] copy];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
}

@end
