//
//  FaceView.h
//  Happiness
//
//  Created by Sumit Jamgade on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceView;

@protocol FaceViewDataScource

-(float) smileForFaceView:(FaceView *)sender;

@end


@interface FaceView : UIView

@property (nonatomic) CGFloat scale;

-(void)pinch:(UIPinchGestureRecognizer *)gesture;

@property (nonatomic, weak) id <FaceViewDataScource> dataSource;

@end
