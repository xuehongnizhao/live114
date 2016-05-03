//
//  cateButton.m
//  CardLeap
//
//  Created by lin on 12/11/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "cateButton.h"

@implementation cateButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setUI :(cateModel*)model
{
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 4.0f;
    //self.layer.borderWidth = 1.0f;
    
    //[self.layer setBorderColor:[self colorWithHexString:color1].CGColor];
    //[self setBackgroundColor:[UIColor clearColor]];
    //[self setBackgroundImage:[UIImage imageNamed:@"user"]  forState:UIControlStateNormal];
    //[self colorWithHexString:color]
    
    /**
        制作纯色UIImage 设置button点击效果
     */
    NSString *color1 = [NSString stringWithFormat:@"%@",model.hightLightedColor.lowercaseString];
    CGSize imageSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[self colorWithHexString:color1] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
    
    NSString *color = [NSString stringWithFormat:@"%@", model.normalColor.lowercaseString];
    self.layer.shadowColor = [UIColor colorWithRed:246 green:245 blue:245 alpha:1.0].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.layer.shadowOpacity = 0.2;
    //添加各种乱七八糟的东西 --- 主标题 副标题 图片
//    UILabel *indexTitles = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 60, 30)];
//    indexTitles.layer.borderWidth=1;
//    indexTitles.text = model.cat_name;
//    indexTitles.textColor = [self colorWithHexString:color];
//    indexTitles.font = [UIFont systemFontOfSize:18.0];
//    [self addSubview:indexTitles];
//    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 80, 20)];
//    subTitle.layer.borderWidth = 1;
//    subTitle.text = model.cat_subHead;
//    subTitle.textColor = [UIColor lightGrayColor];
//    subTitle.font = [UIFont systemFontOfSize:11.0];
//    [self addSubview:subTitle];
    
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(110, 15, 30, 30)];
//    image.layer.borderWidth = 1;
//    [image sd_setImageWithURL:[NSURL URLWithString:model.cat_img] placeholderImage:[UIImage imageNamed:@"user"]];
//    [self addSubview:image];
//    self.tag = [model.cat_id intValue];
    
    //分类图片
    UIImageView *image = [[UIImageView alloc] initForAutoLayout];
    [self addSubview:image];
    [image autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f*LinHeightPercent];
    [image autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0f*LinHeightPercent];
    [image autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [image autoSetDimension:ALDimensionWidth toSize:30.0f*LinHeightPercent];
    [image sd_setImageWithURL:[NSURL URLWithString:model.cat_img] placeholderImage:[UIImage imageNamed:@"user"]];
    //主标题
    UILabel *indexTitles = [[UILabel alloc] initForAutoLayout];
    [self addSubview:indexTitles];
    indexTitles.text = model.cat_name;
    indexTitles.textColor = [self colorWithHexString:color];
    indexTitles.font = [UIFont systemFontOfSize:18.0*LinHeightPercent];
    [indexTitles autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
    [indexTitles autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
    [indexTitles autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:image withOffset:-2.0f];
    [indexTitles autoSetDimension:ALDimensionHeight toSize:18.0f*LinHeightPercent];
    //副标题
    UILabel *subTitle = [[UILabel alloc] initForAutoLayout];
    [self addSubview:subTitle];
    subTitle.text = model.cat_subHead;
    subTitle.font = [UIFont systemFontOfSize:12.0*LinHeightPercent];
    subTitle.textColor = UIColorFromRGB(addressTitle);
    [subTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:indexTitles withOffset:2.0f];
    [subTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
    [subTitle autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:image withOffset:-2.0f];
    [subTitle autoSetDimension:ALDimensionHeight toSize:11.0f*LinHeightPercent];
    
    self.tag = [model.cat_id intValue];
}

#define DEFAULT_VOID_COLOR [UIColor whiteColor]
- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
