//
//  HappinessViewController.m
//  Happiness
//
//  Created by Sumit Jamgade on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HappinessViewController.h"
#import "FaceView.h"

@interface HappinessViewController() <FaceViewDataScource>

@property (nonatomic,weak) IBOutlet FaceView *faceview;
@property (nonatomic,weak) IBOutlet UIToolbar *toolbar;

@end


@implementation HappinessViewController

@synthesize happiness = _happiness;
@synthesize faceview = _faceview;
@synthesize splitViewBarbuttonItem = _splitViewBarbuttonItem;
@synthesize toolbar = _toolbar;

- (void)setSplitViewBarbuttonItem:(UIBarButtonItem *)splitViewBarbuttonItem
{
    if(splitViewBarbuttonItem != _splitViewBarbuttonItem)
    {
        NSMutableArray  *toolbarItems = [self.toolbar.items mutableCopy];
        if(_splitViewBarbuttonItem) {NSLog(@"underscore is not nil");[toolbarItems removeObject:_splitViewBarbuttonItem];}
        if(splitViewBarbuttonItem) {NSLog(@"non inderscore is not nil");[toolbarItems addObject:splitViewBarbuttonItem];}
        self.toolbar.items = toolbarItems;
        _splitViewBarbuttonItem  = splitViewBarbuttonItem;
        NSLog(@"changed the bar item in hvc");
    }
}


-(void) setHappiness:(int)happiness
{
    _happiness = happiness;
    [self.faceview setNeedsDisplay];
    NSLog(@"called wirh happiness %d",happiness);
}


-(void)setFaceview:(FaceView *)faceview
{
    _faceview = faceview;
    [self.faceview addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self.faceview action:@selector(pinch:)]];
    [self.faceview addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)]];
    self.faceview.dataSource = self;
}


-(float)smileForFaceView:(FaceView *)sender
{
    return (self.happiness - 50.0)/50.0;
}

-(void)panGestureRecognizer:(UIPanGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateChanged ||
       gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint translation = [gesture translationInView:self.faceview];
        self.happiness += translation.y/2;
        [gesture setTranslation:CGPointZero inView:self.faceview];
    }
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
@end


