//
//  CateButtonView.m
//  CardLeap
//
//  Created by lin on 12/24/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "CateButtonView.h"

@interface CateButtonView()
{
    NSArray *_titleArray;
    NSArray *_tagArray;
    NSMutableArray *buttonArray;
    NSInteger myIndex;
}
@end

@implementation CateButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CateButtonView*)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray tagArray:(NSArray*)tagArray index:(NSInteger)index;
{
    if (self) {
        self = [[CateButtonView alloc] initWithFrame:frame];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0f;
        self.layer.borderColor = UIColorFromRGB(0xe34a51).CGColor;
        self.layer.borderWidth = 1;
        _titleArray = titleArray;
        _tagArray = tagArray;
        myIndex = index;
        buttonArray = [[NSMutableArray alloc] init];
        [self setButton];
    }
    return self;
}

-(void)setButton
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat width = (rect.size.width-10) / [_titleArray count];
//    UIImageView *imageNormal = [[UIImageView alloc] init];
//    [imageNormal setBackgroundColor:[UIColor whiteColor]];
//    UIImageView *hightlighterImage = [[UIImageView alloc] init];
//    [hightlighterImage setBackgroundColor:[UIColor redColor]];
    for (int i=0 ;i<[_titleArray count];i++) {
        NSString *title = [_titleArray objectAtIndex:i];
        NSInteger buttonTag = [[_tagArray objectAtIndex:i] integerValue];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width*i, 0, width, 30)];
        btn.tag = buttonTag;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
        [btn setTitleColor:UIColorFromRGB(0xe34a51) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xe34a51) forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor =UIColorFromRGB(0xe34a51).CGColor;
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [buttonArray addObject:btn];
        [self addSubview:btn];
    }

}

-(void)setIndex:(NSInteger)index
{
    //设置button点击
    UIButton *myBtn = [buttonArray objectAtIndex:myIndex];
    [myBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)clickAction :(UIButton*)sender
{
    for (UIButton *btn in buttonArray) {
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:UIColorFromRGB(0xe34a51) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xe34a51) forState:UIControlStateHighlighted];
    }
    [sender setBackgroundColor:UIColorFromRGB(0xe34a51)];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    NSInteger tag = sender.tag;
    NSLog(@"点击了分类id %ld",tag);
    [self.delegate chooseCateID:tag];
}
@end
