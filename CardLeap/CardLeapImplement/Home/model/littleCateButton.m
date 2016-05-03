//
//  littleCateButton.m
//  CardLeap
//
//  Created by lin on 12/11/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "littleCateButton.h"

@implementation littleCateButton
@synthesize title = _title;
@synthesize btn = _btn;
@synthesize delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = [[littleCateButton alloc] init];
    }
    return self;
}
-(void)setUI :(littleCateModel*)model
{
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = 20.0f;
    _btn.tag = [model.cat_id intValue];
    UIImageView *image = [[UIImageView alloc] init];
    [image sd_setImageWithURL:[NSURL URLWithString:model.cat_img] placeholderImage:[UIImage imageNamed:@"user"]];
    [_btn setImage:image.image forState:UIControlStateNormal];
    [_btn setImage:image.image forState:UIControlStateHighlighted];
    [_btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 15, 15)];
    _title.text = model.cat_name;
    _title.textColor = [UIColor lightGrayColor];
    [self addSubview:_title];
}

-(void)click:(UIButton*)sender
{
    NSInteger tag = sender.tag;
    [delegate clickAction:tag];
}
@end
