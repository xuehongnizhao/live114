//
//  ReviewLable.h
//  EnjoyDQ
//
//  Created by lin on 14-9-10.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewLable : UILabel <UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *review_web;
@property (strong, nonatomic) NSString *html;
-(void)setString :(NSString*)reviewText;
@end
