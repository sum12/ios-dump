//
//  FaceView.m
//  Happiness
//
//  Created by Sumit Jamgade on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView

#define DEFAULT_SCALE 0.90

@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

-(CGFloat)scale{
    if(!_scale) return DEFAULT_SCALE;
    else return _scale;
}

-(void)setScale:(CGFloat)scale{
    if(_scale != scale){
        _scale = scale;
        [self setNeedsDisplay];
    }
}

-(void) setup{
    self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setup];
    }
    return self;
}

-(void) awakeFromNib{
    [self setup];
}


-(void)pinch:(UIPinchGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateChanged ||
       gesture.state == UIGestureRecognizerStateEnded)
    {
        self.scale *= gesture.scale;
        gesture.scale=1;
    }
}


-(void)drawCircleAtPoint:(CGPoint)p havingRadius:(CGFloat)radius withContext:(CGContextRef)context{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    int size = self.bounds.size.height/2;
    if(size> self.bounds.size.width/2) size= self.bounds.size.width/2;
    size *= self.scale;
    
    CGPoint midpoint;
    midpoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midpoint.y = self.bounds.origin.y + self.bounds.size.height/2;

    [[UIColor blueColor] setStroke];
    CGContextSetLineWidth(context, 5.0);
    [self drawCircleAtPoint:midpoint havingRadius:size withContext:context];

#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_R 0.1

    CGPoint eyepoint = midpoint;
    eyepoint.x -= size*EYE_H;
    eyepoint.y -= size*EYE_V;
    [self drawCircleAtPoint:eyepoint havingRadius:(size*EYE_R) withContext:context];

    eyepoint.x += 2*size*EYE_H;
    [self drawCircleAtPoint:eyepoint havingRadius:(size*EYE_R) withContext:context];

    
#define MOUTH_H 0.45
#define MOUTH_V 0.45
#define MOUTH_SMILE 0.25

    CGPoint mouthStart = midpoint;
    CGPoint mouthCP1, mouthCP2, mouthEnd;
    mouthStart.y += MOUTH_V*size;
    mouthStart.x -= MOUTH_H*size;
    
    mouthEnd = mouthStart;
    mouthEnd.x += 2*MOUTH_H*size;
    
    mouthCP1 = mouthStart;
    mouthCP1.x += 2/3*MOUTH_H*size;
    
    mouthCP2= mouthEnd;
    mouthCP2.x -= 2/3*MOUTH_H*size;

    float smile = [self.dataSource smileForFaceView:self];
    if(smile < -1) smile = -1;
    if (smile>1) smile = 1;
    
    mouthCP1.y += smile*size*MOUTH_SMILE;
    mouthCP2.y += smile*size*MOUTH_SMILE;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP1.y, mouthEnd.x, mouthEnd.y);
    CGContextStrokePath(context);
    
}




@end











