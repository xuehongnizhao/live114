//
//  ReplyTableViewCell.m
//  CardLeap
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "ReplyTableViewCell.h"
#import "RegexKitLite.h"
#import "OHAttributedLabel.h"
#import "CustomMethod.h"
#import "MarkupParser.h"
#import "NSAttributedString+Attributes.h"

@interface ReplyTableViewCell()
@property (strong, nonatomic) UIImageView *user_pic;
@property (strong, nonatomic) UILabel *user_name;
@property (strong, nonatomic) UIImageView *com_pic;
@property (strong, nonatomic) OHAttributedLabel *com_text;
@property (strong, nonatomic) OHAttributedLabel *reply_text;
@end

@implementation ReplyTableViewCell
static NSMutableDictionary *g_nsdicemojiDict ;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark----------布局
-(void)configureCell :(ReplyInfo*)info
{
    //回复用户头像
    [self.contentView addSubview:self.user_pic];
    [_user_pic sd_setImageWithURL:[NSURL URLWithString:info.user_pic] placeholderImage:[UIImage imageNamed:@"user"]];
    [_user_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_user_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.f];
    [_user_pic autoSetDimension:ALDimensionWidth toSize:30.0f];
    [_user_pic autoSetDimension:ALDimensionHeight toSize:30.0f];
    //帖子图片或者文字
    if (info.com_text.length == 0) {
        [self.contentView addSubview:self.com_pic];
        [_com_pic sd_setImageWithURL:[NSURL URLWithString:info.com_url] placeholderImage:[UIImage imageNamed:@"user"]];
        [_com_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_com_pic autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_com_pic autoSetDimension:ALDimensionHeight toSize:60.0f];
        [_com_pic autoSetDimension:ALDimensionWidth toSize:60.0f];
    }else{
        NSString *com_text_str = info.com_text;
        if (com_text_str.length >= 15) {
            com_text_str = [com_text_str substringToIndex:14];
            com_text_str = [NSString stringWithFormat:@"%@...",com_text_str];
        }
        g_nsdicemojiDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
        if (g_nsdicemojiDict == nil)
        {
            g_nsdicemojiDict = [NSMutableDictionary dictionary];
            
            g_nsdicemojiDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"]];
        }
        _com_text = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        _com_text.tag = 112;
        [_com_text setNeedsDisplay];
        NSString* text = [CustomMethod transformString:[[NSString alloc] initWithFormat:@"%@",com_text_str] emojiDic:g_nsdicemojiDict];
        //        text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
        MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
        NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup:text];
        [attString setFont:[UIFont systemFontOfSize:13]];
        [_com_text setBackgroundColor:[UIColor clearColor]];
        [_com_text setAttString:attString withImages:wk_markupParser.images];
        _com_text.frame = CGRectMake(250*LinPercent,10, 60,60);
        CGRect labelRect = _com_text.frame;
        labelRect.size.width = [_com_text sizeThatFits:CGSizeMake(60, CGFLOAT_MAX)].width;
        labelRect.size.height = [_com_text sizeThatFits:CGSizeMake(60, CGFLOAT_MAX)].height;
        _com_text.frame = labelRect;
        _com_text.textColor = UIColorFromRGB(0xa8a8aa);
        //_com_text.backgroundColor  =[UIColor grayColor];
        _com_text.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _com_text.layer.borderWidth = 1;
        _com_text.layer.masksToBounds = YES;
        _com_text.layer.cornerRadius = 4.0f;
        [_com_text.layer display];
        [self.contentView addSubview:_com_text];
    }
    //用户名
    [self.contentView addSubview:self.user_name];
    _user_name.text = info.user_name;
    [_user_name autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
    [_user_name autoSetDimension:ALDimensionHeight toSize:15.0f];
    [_user_name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_user_pic withOffset:8.0f];
    [_user_name autoSetDimension:ALDimensionWidth toSize:200.0f];
    //回复消息
    g_nsdicemojiDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
    if (g_nsdicemojiDict == nil)
    {
        g_nsdicemojiDict = [NSMutableDictionary dictionary];
        g_nsdicemojiDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"]];
    }
    _reply_text = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
    _reply_text.tag = 112;
    [_reply_text setNeedsDisplay];
    NSString* text = [CustomMethod transformString:[[NSString alloc] initWithFormat:@"%@",info.reply_text] emojiDic:g_nsdicemojiDict];
    //        text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup:text];
    [attString setFont:[UIFont systemFontOfSize:13]];
    [_reply_text setBackgroundColor:[UIColor clearColor]];
    [_reply_text setAttString:attString withImages:wk_markupParser.images];
    _reply_text.frame = CGRectMake(50,35, 300*LinPercent,100);
    CGRect labelRect = _reply_text.frame;
    labelRect.size.width = [_reply_text sizeThatFits:CGSizeMake(230, CGFLOAT_MAX)].width;
    labelRect.size.height = [_reply_text sizeThatFits:CGSizeMake(230, CGFLOAT_MAX)].height;
    _reply_text.frame = labelRect;
    _reply_text.textColor = UIColorFromRGB(0xa8a8aa);
    //_reply_text.backgroundColor  =[UIColor redColor];
    [_reply_text.layer display];
    [self.contentView addSubview:_reply_text];
}

-(UILabel *)user_name
{
    if (!_user_name) {
        _user_name = [[UILabel alloc] initForAutoLayout];
        _user_name.font = [UIFont systemFontOfSize:13.0f];
    }
    return _user_name;
}

-(UIImageView *)user_pic
{
    if (!_user_pic) {
        _user_pic = [[UIImageView alloc] initForAutoLayout];
        _user_pic.layer.masksToBounds = YES;
        _user_pic.layer.cornerRadius = 4.0f;
    }
    return _user_pic;
}

-(UIImageView *)com_pic
{
    if (!_com_pic) {
        _com_pic = [[UIImageView alloc] initForAutoLayout];
    }
    return _com_pic;
}

-(OHAttributedLabel *)com_text
{
    if (!_com_text) {
        _com_text = [[OHAttributedLabel alloc] initForAutoLayout];
    }
    return _com_text;
}

-(OHAttributedLabel *)reply_text
{
    if (!_reply_text) {
        _reply_text = [[OHAttributedLabel alloc] initForAutoLayout];
    }
    return _reply_text;
}
@end
