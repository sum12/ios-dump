//
//  HappinessViewController.h
//  Happiness
//
//  Created by Sumit Jamgade on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarbuttonItemPresenter.h"



@interface HappinessViewController : UIViewController <SplitViewBarbuttonItemPresenter>

@property (nonatomic) int happiness; 

@end
