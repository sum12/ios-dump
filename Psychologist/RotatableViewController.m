//
//  RotatableViewController.m
//  Psychologist
//
//  Created by Sumit Jamgade on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RotatableViewController.h"
#import "SplitViewBarbuttonItemPresenter.h"

@implementation RotatableViewController


-(void) awakeFromNib 
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


-(id <SplitViewBarbuttonItemPresenter>) splitViewBarbuttonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarbuttonItemPresenter)]) {
        detailVC = nil;
    }
    NSLog(@"detailvc got");
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarbuttonItemPresenter]? UIInterfaceOrientationIsPortrait(orientation) :NO;
}

- (void) splitViewController:(UISplitViewController *)svc 
      willHideViewController:(UIViewController *)aViewController
           withBarButtonItem:(UIBarButtonItem *)barButtonItem 
        forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"back";
    [self splitViewBarbuttonItemPresenter].splitViewBarbuttonItem = barButtonItem;
    NSLog(@"changed the bar button in rotatbleviewcontroller");
}

-(void)splitViewController:(UISplitViewController *)svc
    willShowViewController:(UIViewController *)aViewController 
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarbuttonItemPresenter].splitViewBarbuttonItem = nil;
}
@end
