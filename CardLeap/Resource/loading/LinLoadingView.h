//
//  LinLoadingView.h
//  CardLeap
//
//  Created by lin on 12/19/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYAnimationIndicator.h"
@interface LinLoadingView : UIView

+(LinLoadingView*)shareInstances:(UIView*)view;
-(void)startAnimation;
-(void)stopWithAnimation :(NSString*)text;
@end
