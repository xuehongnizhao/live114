//
//  ImageViewMgrController.m
//  EnjoyDQ
//
//  Created by lin on 14-9-3.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import "CellViewMgrController.h"
#import "LinFriendCircleInfo.h"
#import "RegexKitLite.h"
#import "OHAttributedLabel.h"
#import "CustomMethod.h"
#import "MarkupParser.h"
#import "NSAttributedString+Attributes.h"
#import "ReviewLable.h"
#import "UserModel.h"

@interface CellViewMgrController()<OHAttributedLabelDelegate,UIAlertViewDelegate>
{
    NSArray *FriendCircleList;
    //===========
    OHAttributedLabel *t_OHAttributedLabel;
    
    MarkupParser *wk_markupParser;
    //===========
    UIWebView * t_ReviewName;//用户名加载的webview
    
    BOOL isFirst;
}
@end

@implementation CellViewMgrController
@synthesize delegate;
@synthesize heightsOfCells = _heightsOfCells;
@synthesize textHeights = _textHeights;
@synthesize comPicHeights = _comPicHeights;
@synthesize reviewListHeights = _reviewListHeights;
static NSMutableDictionary* g_nsdicemojiDict = nil;

-(id)initWithDictionary :(NSArray*)array
{
    NSLog(@"%@",self);
    if (!self) {
        self = [[CellViewMgrController alloc] init];
    }
    FriendCircleList = [[NSArray alloc] initWithArray:array];
    _heightsOfCells = [[NSMutableArray alloc] init];
    _textHeights = [[NSMutableArray alloc] init];
    _comPicHeights = [[NSMutableArray alloc] init];
    _reviewListHeights = [[NSMutableArray alloc] init];
    isFirst = YES;
    //计算cell的高度
    for (LinFriendCircleInfo *info in array) {
        CGFloat height = 0;
        //头像的高度 创建事件Lable的高度
        height += 80;
        //正文的高度
        NSString *com_text = info.com_text;
        int textHeight = 0;
        g_nsdicemojiDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
        if (g_nsdicemojiDict == nil)
        {
            g_nsdicemojiDict = [NSMutableDictionary dictionary];
            
            g_nsdicemojiDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"]];
            [[NSUserDefaults standardUserDefaults] setObject:g_nsdicemojiDict forKey:@"FaceMap"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (t_OHAttributedLabel)
        {
            [t_OHAttributedLabel removeFromSuperview];
        }
        OHAttributedLabel*  textLabelEx ;
        textLabelEx = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        textLabelEx.tag = 112;
        [textLabelEx setNeedsDisplay];
        NSString* text = [CustomMethod transformString:[[NSString alloc] initWithFormat:@"%@",com_text] emojiDic:g_nsdicemojiDict];
        //        text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
        wk_markupParser = [[MarkupParser alloc] init];
        NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup:text];
        [attString setFont:[UIFont systemFontOfSize:13]];
        textLabelEx.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:93/255.0 alpha:1.0];
        [textLabelEx setBackgroundColor:[UIColor clearColor]];
        [textLabelEx setAttString:attString withImages:wk_markupParser.images];
        [textLabelEx setBackgroundColor:[UIColor grayColor]];
        textLabelEx.frame = CGRectMake(67, 30, 220, 100);
        CGRect labelRect = textLabelEx.frame;
        labelRect.size.width = [textLabelEx sizeThatFits:CGSizeMake(250, CGFLOAT_MAX)].width;
        labelRect.size.height = [textLabelEx sizeThatFits:CGSizeMake(250, CGFLOAT_MAX)].height;
        textLabelEx.frame = labelRect;
        [textLabelEx.layer display];
        [CustomMethod drawImage:textLabelEx];
        textHeight = textLabelEx.frame.size.height;
        if(com_text.length > 0){
            [_textHeights addObject:[NSNumber numberWithInt:textHeight]];
        }else{
            textHeight = 0;
            [_textHeights addObject:[NSNumber numberWithInt:textHeight]];
        }
        
        height += (textHeight);
        //图片高度
        NSArray *com_pic = info.com_pic;
        NSLog(@"图片列表为%@",com_pic);
        int numberOfPic = 0;
        for (NSString *pic in com_pic) {
            if (pic.length > 0) {
                numberOfPic++;
            }
        }
        int picHeight = 0;
        if (numberOfPic <= 1) {
            picHeight = numberOfPic*130;
            height += picHeight;
        }else if(numberOfPic <= 4){
            int lines = numberOfPic/2;
            if (numberOfPic%2) {
                lines++;
            }
            picHeight = 105*lines;
            height += picHeight;
        }else{
            int line = numberOfPic/3;
            if (numberOfPic%3) {
                line++;
            }
            picHeight = 80*line;
            height += picHeight;
        }
        [_comPicHeights addObject:[NSNumber numberWithInt:picHeight]];
        //语音
        NSLog(@"语音为%@",info.com_voice);
        if (info.com_voice != nil && info.com_voice.length > 1) {
            height += 40;
        }
        //回复列表的高度
        NSArray *review_list = info.com_list;
        int reviewHeight = 0;
        if ([review_list count]>0) {
            for (NSDictionary *dic in review_list) {
                //用户名高度
                NSString *user_name = [Base64Tool fuckNULL:[dic objectForKey:@"user_name"]];
                NSString *user_back_name = [Base64Tool fuckNULL:[dic objectForKey:@"return_user_name"]];
                //回复内容高度
                NSString *com_text = [dic objectForKey:@"rev_text"];
                NSLog(@"我的回复内容是-----%@",com_text);
                g_nsdicemojiDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
                if (g_nsdicemojiDict == nil)
                {
                    g_nsdicemojiDict = [NSMutableDictionary dictionary];
                    
                    g_nsdicemojiDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"]];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:g_nsdicemojiDict forKey:@"FaceMap"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
                if (t_OHAttributedLabel)
                {
                    [t_OHAttributedLabel removeFromSuperview];
                }
                textLabelEx = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
                textLabelEx.tag = 112;
                [textLabelEx setNeedsDisplay];
//                NSLog(@"回复列表的内容是什么 %@",com_text);
//                NSString *temp = [NSString stringWithFormat:@"%@ %@",user_name,com_text];
//                NSLog(@"合并之后的回复内容是什么%@",temp);
//                if (user_back_name!=nil && user_back_name.length > 0) {
//                    temp = [NSString stringWithFormat:@"%@回复 %@:",temp,user_back_name];
//                }
                int blank_length;//留白长度
                blank_length = [self length_str:user_name];
                if (user_back_name!=nil && user_back_name.length>0) {
                    blank_length += [self length_str:user_back_name]+3;
                    blank_length+=3;
                }else{
                    blank_length+=2;
                }
                
                for (int i=0;i<blank_length;i++) {
                    //com_text = [NSString stringWithFormat:@"%@%@",@"   ",com_text];
                }
                
                NSString *tempUserName = user_name;
                if (user_back_name!=nil && user_back_name.length>0) {
                    tempUserName = [NSString stringWithFormat:@"%@回复%@: ",tempUserName,user_back_name];
                }else{
                    tempUserName = [NSString stringWithFormat:@"%@: ",tempUserName];
                }
                com_text = [NSString stringWithFormat:@"%@ %@",tempUserName,com_text];
                
                NSString* text = [CustomMethod transformString:[[NSString alloc] initWithFormat:@"%@",com_text] emojiDic:g_nsdicemojiDict];
                //        text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
                NSLog(@"%@",text);
                wk_markupParser = [[MarkupParser alloc] init];
                NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup:text];
                [attString setFont:[UIFont systemFontOfSize:13]];
                textLabelEx.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:93/255.0 alpha:1.0];
                [textLabelEx setBackgroundColor:[UIColor clearColor]];
                [textLabelEx setAttString:attString withImages:wk_markupParser.images];
                //[textLabelEx setBackgroundColor:[UIColor grayColor]];
                textLabelEx.frame = CGRectMake(67, 30, 230, 100);
                CGRect labelRect = textLabelEx.frame;
                labelRect.size.width = [textLabelEx sizeThatFits:CGSizeMake(230, CGFLOAT_MAX)].width;
                labelRect.size.height = [textLabelEx sizeThatFits:CGSizeMake(230, CGFLOAT_MAX)].height;
                textLabelEx.frame = labelRect;
                [textLabelEx.layer display];
                [CustomMethod drawImage:textLabelEx];
                int height = textLabelEx.frame.size.height;
                NSLog(@"高度为%d",height);
                reviewHeight += textLabelEx.frame.size.height;
            }
            //背景块上下空出10
            reviewHeight += 20;
            height += reviewHeight;
        }
        [_reviewListHeights addObject:[NSNumber numberWithInt:reviewHeight]];
        //装入数组
        [_heightsOfCells addObject:[NSNumber numberWithFloat:height]];
    }
    NSLog(@"cell的高度都是多少 %@",_heightsOfCells);
    return self;
}

-(UIView*)ImageLayout :(int)indexPath
{
    CGFloat height = [[_heightsOfCells objectAtIndex:indexPath] floatValue];
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    //控件
    UILabel *userName = nil;
    UIImageView *user_pic = nil;
    UIImageView *com_image_view = nil;
    UIView * LinTest2 = nil;
    UILabel *user_name_label = nil;
    UILabel *user_review_lable = nil;
    UILabel *timeLable = nil;
    UIImageView *timeImageView = nil;
    UIImageView *messageImageView = nil;
    //添加用户头像 用户名
    LinFriendCircleInfo *info = [[LinFriendCircleInfo alloc] init];
    info = [FriendCircleList objectAtIndex:indexPath];
    userName = [[UILabel alloc] initWithFrame:CGRectMake(68*LinPercent, 10, 222, 21)];
    [userName setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];//格式
    userName.textColor = UIColorFromRGB(0x0e0e0e);
    userName.text = info.user_nickname;
    [cellView addSubview:userName];
    //用户头像
    user_pic = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40*LinPercent, 40*LinHeightPercent)];
    [user_pic sd_setImageWithURL:[NSURL URLWithString:info.user_pic] placeholderImage:[UIImage imageNamed:@"user"]];
    user_pic.layer.masksToBounds = YES;
    user_pic.layer.cornerRadius = 4;
    user_pic.layer.borderWidth = 0.5;
    user_pic.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
    [cellView addSubview:user_pic];
    //距离or推荐
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(220*LinPercent, 10, 90*LinHeightPercent, 21)];
    lable.textColor = [UIColor lightGrayColor];
    lable.font = [UIFont systemFontOfSize:11.0f];
    lable.textAlignment = NSTextAlignmentRight;
    if ([info.is_top isEqualToString:@"1"]) {
        lable.text = @"推荐";
        lable.textColor = [UIColor greenColor];
    }else{
        lable.text = [NSString stringWithFormat:@"%@",info.distance];
    }
    [cellView addSubview:lable];
    //帖子正文
    NSString *com_text = info.com_text;
    if (t_OHAttributedLabel)
    {
        [t_OHAttributedLabel removeFromSuperview];
    }
    if (com_text.length > 0) {
        //t_OHAttributedLabel = [cell.contentView viewWithTag:112];
        //内容 FaceMap
        g_nsdicemojiDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
        if (g_nsdicemojiDict == nil)
        {
            g_nsdicemojiDict = [NSMutableDictionary dictionary];
            g_nsdicemojiDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"]];
            [[NSUserDefaults standardUserDefaults] setObject:g_nsdicemojiDict forKey:@"FaceMap"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        OHAttributedLabel*  textLabelEx ;
        textLabelEx = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        textLabelEx.tag = 112;
        [textLabelEx setNeedsDisplay];
        NSString* text = [CustomMethod transformString:[[NSString alloc] initWithFormat:@"%@",com_text] emojiDic:g_nsdicemojiDict];
        //        text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
        wk_markupParser = [[MarkupParser alloc] init];
        NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup:text];
        [attString setFont:[UIFont systemFontOfSize:13]];
        [textLabelEx setBackgroundColor:[UIColor clearColor]];
        [textLabelEx setAttString:attString withImages:wk_markupParser.images];
        //[textLabelEx setBackgroundColor:[UIColor grayColor]];
        textLabelEx.frame = CGRectMake(67*LinPercent, 40, 220, [[_textHeights objectAtIndex:indexPath] intValue]);
        CGRect labelRect = textLabelEx.frame;
        labelRect.size.width = [textLabelEx sizeThatFits:CGSizeMake(250, CGFLOAT_MAX)].width;
        labelRect.size.height = [textLabelEx sizeThatFits:CGSizeMake(250, CGFLOAT_MAX)].height;
        textLabelEx.frame = labelRect;
        [textLabelEx.layer display];
        textLabelEx.textColor = UIColorFromRGB(0x838486);
        [CustomMethod drawImage:textLabelEx];
        textLabelEx.userInteractionEnabled = YES;
        textLabelEx.enabled = YES;
        //
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        //[textLabelEx addGestureRecognizer:longPressGestureRecognizer];
        UIView *copyView = [[UIView alloc] initWithFrame:CGRectMake(textLabelEx.frame.origin.x, textLabelEx.frame.origin.y, textLabelEx.frame.size.width, textLabelEx.frame.size.height)];
        copyView.tag = indexPath;
        textLabelEx.frame = CGRectMake(0, 0, textLabelEx.frame.size.width, textLabelEx.frame.size.height);
        [copyView addSubview:textLabelEx];
        [copyView setBackgroundColor:[UIColor clearColor]];
        copyView.userInteractionEnabled = YES;
        [cellView addSubview:copyView];
        [copyView addGestureRecognizer:longPressGestureRecognizer];//添加收拾 复制
        //[cellView  addSubview:textLabelEx];
    }
    //图片 分多种格式 一张  四张以下  多余四张
    NSArray *com_pic = info.com_pic;
    int count_pic = [self count_pic:com_pic];
    int pic_y = 0;
    if ([[_textHeights objectAtIndex:indexPath] intValue] == 0) {
        pic_y = 40;
    }else{
        pic_y = 45 + [[_textHeights objectAtIndex:indexPath] intValue];
    }
    if (count_pic >0) {
        if (count_pic == 1) {
            //一张大图
            //截取图片
//            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[com_pic objectAtIndex:0]]];
            com_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(67*LinPercent, pic_y, 130, 130)];
            com_image_view.layer.borderWidth = 0.5;
            com_image_view.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
            [com_image_view sd_setImageWithURL:[NSURL URLWithString:[com_pic objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"user"]];
            [cellView addSubview:com_image_view];
        }else if(count_pic <= 4){
            //四张以内 田格显示
            for (int i=0;i<count_pic;i++) {
                int lines = i / 2;
                int col = i % 2;
                com_image_view = nil;
                com_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(68*LinPercent+col*105, pic_y+lines*105, 100, 100)];
                [com_image_view sd_setImageWithURL:[NSURL URLWithString:[com_pic objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"user"]];
                com_image_view.layer.borderWidth = 0.5;
                com_image_view.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
                [cellView addSubview:com_image_view];
            }
        }else if(count_pic <= 9){
            for (int n=0; n<count_pic; n++) {
                int lines = n / 3;
                int col = n % 3;
                com_image_view = nil;
                com_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(68*LinPercent+col*78, pic_y+lines*78, 72, 72)];
                [com_image_view sd_setImageWithURL:[NSURL URLWithString:[com_pic objectAtIndex:n]] placeholderImage:[UIImage imageNamed:@"user"]];
                com_image_view.layer.borderWidth = 0.5;
                com_image_view.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
                [cellView addSubview:com_image_view];
            }
        }
    }
    //发布语音
    int voice_y = 0;
    UIImageView *image;
    if (info.com_voice != nil && info.com_voice.length > 1) {
        voice_y = pic_y + [[_comPicHeights objectAtIndex:indexPath] intValue]+5;
        image = [[UIImageView alloc] initWithFrame:CGRectMake(67*LinPercent, voice_y, 80, 30)];
        [image setImage:[UIImage imageNamed:@"issue_default@2x.png"]];
         [cellView addSubview:image];
    }
    //回复 回复框 + 回复内容
    //两个模块中间留5像素的空隙
    int review_y = 0;
    if ([[_textHeights objectAtIndex:indexPath] intValue] == 0) {
        review_y = 40;
    }else{
        review_y = 45 + [[_textHeights objectAtIndex:indexPath] intValue];
    }
    if ([[_comPicHeights objectAtIndex:indexPath] intValue] != 0) {
        review_y += [[_comPicHeights objectAtIndex:indexPath] intValue]+5;
    }
    if (image != nil) {
        review_y += 37;
    }
    int review_height = [[_reviewListHeights objectAtIndex:indexPath] intValue];
    LinTest2 = [[UIView alloc] initWithFrame:CGRectMake(68*LinPercent,review_y, 240, review_height)];
    [LinTest2 setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    [cellView addSubview:LinTest2];
    //添加回复列表 x y 7 10
    NSArray *com_list = info.com_list;
    review_y = 10;
    if ([com_list count]>0) {
        //添加用户名
        //加用户名
        for (NSDictionary *dic in com_list) {
            NSString *user_name = [Base64Tool fuckNULL:[dic objectForKey:@"user_name"]];
            NSString *user_back_name = [Base64Tool fuckNULL:[dic objectForKey:@"return_user_name"]];
            NSString *rev_text = [dic objectForKey:@"rev_text"];
            
            int blank_length;//留白长度
            blank_length = [self Linlength_str:user_name];
            if (user_back_name!=nil && user_back_name.length>0) {
                blank_length += [self Linlength_str:user_back_name]+2;
                //blank_length+=3;
            }else{
                //blank_length+=1;
            }
            NSString *tempUserName = user_name;
            if (user_back_name!=nil && user_back_name.length>0) {
                tempUserName = [NSString stringWithFormat:@"%@回复%@: ",tempUserName,user_back_name];
            }else{
                tempUserName = [NSString stringWithFormat:@"%@: ",tempUserName];
            }
            rev_text = [NSString stringWithFormat:@"%@ %@",tempUserName,rev_text];
            UIView *blankView ;
            UILabel *blankLable = [[UILabel alloc] init];
            blankLable.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
            blankLable.text = tempUserName;
            blankLable.font=[UIFont systemFontOfSize:13];
//            blankLable.backgroundColor = [UIColor redColor];
            [blankLable sizeToFit];
            blankLable.text = @"";
            if ([self isEmoji:rev_text]) {
                blankView = [[UIView alloc] initWithFrame:CGRectMake(7, review_y+5, blank_length*13+5, 14)];
                blankLable.frame = CGRectMake(7, review_y+5, blankLable.frame.size.width, blankLable.frame.size.height);
            }else{
                blankView = [[UIView alloc] initWithFrame:CGRectMake(7, review_y, blank_length*13+5, 14)];
                blankLable.frame = CGRectMake(7, review_y, blankLable.frame.size.width, blankLable.frame.size.height);
            }
            
            blankView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
            g_nsdicemojiDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
            if (g_nsdicemojiDict == nil)
            {
                g_nsdicemojiDict = [NSMutableDictionary dictionary];
                
                g_nsdicemojiDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"]];
                [[NSUserDefaults standardUserDefaults] setObject:g_nsdicemojiDict forKey:@"FaceMap"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            //t_OHAttributedLabel = [cell.contentView viewWithTag:112];
            if (t_OHAttributedLabel)
            {
                [t_OHAttributedLabel removeFromSuperview];
            }
            OHAttributedLabel*  textLabelEx ;
            textLabelEx = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
            textLabelEx.tag = 112;
            [textLabelEx setNeedsDisplay];
            NSString* text = [CustomMethod transformString:[[NSString alloc] initWithFormat:@"%@",rev_text] emojiDic:g_nsdicemojiDict];
            //        text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
            wk_markupParser = [[MarkupParser alloc] init];
            NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup:text];
            [attString setFont:[UIFont systemFontOfSize:13]];
            [textLabelEx setBackgroundColor:[UIColor clearColor]];
            [textLabelEx setAttString:attString withImages:wk_markupParser.images];
            int review_text_y = user_name_label.frame.origin.y + user_name_label.frame.size.height;
            textLabelEx.frame = CGRectMake(7,review_y, 230,100);
            CGRect labelRect = textLabelEx.frame;
            labelRect.size.width = [textLabelEx sizeThatFits:CGSizeMake(230, CGFLOAT_MAX)].width;
            labelRect.size.height = [textLabelEx sizeThatFits:CGSizeMake(230, CGFLOAT_MAX)].height;
            textLabelEx.frame = labelRect;
            textLabelEx.textColor = UIColorFromRGB(0xa8a8aa);
            //textLabelEx.backgroundColor  =[UIColor grayColor];
            [textLabelEx.layer display];
            [CustomMethod drawImage:textLabelEx];
            [LinTest2 addSubview:textLabelEx];
            //掩盖
            //[LinTest2 addSubview:blankView];
            [LinTest2 addSubview:blankLable];
            if ([self isEmoji:rev_text]) {
                review_y+= 5;
            }
            user_name_label = nil;
            user_name_label = [[UILabel alloc] initWithFrame:CGRectMake(7,review_y, 232, 16)];
            [user_name_label setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];//格式
            [user_name_label setTextColor:[UIColor colorWithRed:93/255.0 green:181/255.0 blue:235/255.0 alpha:1.0]];
            [user_name_label setNumberOfLines: 1];//行数，只有设为0才能自适应
            user_name_label.text = [NSString stringWithFormat:@"%@:",user_name];
            //n++;
            [LinTest2 addSubview:user_name_label];
            if (user_back_name!=nil && user_back_name.length>0) {
                user_name_label.text = [NSString stringWithFormat:@"%@",user_name];
                [user_name_label sizeToFit];
                NSLog(@"%@",user_name);
                int back_lable_x = user_name_label.frame.origin.x + user_name_label.frame.size.width;
                UILabel *back_lable = [[UILabel alloc] initWithFrame:CGRectMake(back_lable_x, review_y, 28, 16)];
                [back_lable setFont:[UIFont systemFontOfSize:13.0]];
                back_lable.textColor = UIColorFromRGB(0xa8a8aa);
                back_lable.text = @"回复";
                [back_lable sizeToFit];
                [LinTest2 addSubview:back_lable];
                int user_back_x = back_lable.frame.origin.x + back_lable.frame.size.width+3;
                UILabel *back_user_lable = [[UILabel alloc] initWithFrame:CGRectMake(user_back_x, review_y, 100, 16)];
                back_user_lable.textColor = [UIColor colorWithRed:93/255.0 green:181/255.0 blue:235/255.0 alpha:1.0];
                [back_user_lable setFont:[UIFont systemFontOfSize:13.0]];
                back_user_lable.text = [NSString stringWithFormat:@"%@:",user_back_name];
                [LinTest2 addSubview:back_user_lable];
            }
            review_y = textLabelEx.frame.origin.y+textLabelEx.frame.size.height+2;
        }
    }
    int y2 = 0;
    if ([[_textHeights objectAtIndex:indexPath] intValue] == 0) {
        y2 = 40;
    }else{
        y2 = 45 + [[_textHeights objectAtIndex:indexPath] intValue];
    }
    
    if ([[_comPicHeights objectAtIndex:indexPath] intValue] != 0) {
        y2 += [[_comPicHeights objectAtIndex:indexPath] intValue]+5;
    }
    
    if ([[_reviewListHeights objectAtIndex:indexPath] intValue]!=0) {
        y2 += [[_reviewListHeights objectAtIndex:indexPath] intValue]+5 ;
    }
    if (image != nil) {
        y2 += 37;
    }
    timeLable = nil;
    timeLable = [[UILabel alloc] initWithFrame:CGRectMake(66*LinPercent, y2-2, 300, 21)];
    timeLable.textColor = UIColorFromRGB(0xa8a8aa);
    timeLable.text = info.add_time;
    [timeLable setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    [timeLable sizeToFit];
    [cellView addSubview:timeLable];
    //删除按钮 如果是自己的帖子添加删除按钮
    NSString *uid = info.u_id;
    if(ApplicationDelegate.islogin == YES && [[UserModel shareInstance].u_id isEqualToString:uid]){
        NSLog(@"添加了删除按钮");
        int delete_x_position = timeLable.frame.origin.x + timeLable.frame.size.width;
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(delete_x_position, y2-4, 50, 21)];
        deleteButton.tag = indexPath;
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton setTitle:@"删除" forState:UIControlStateHighlighted];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [deleteButton setTitleColor:[UIColor colorWithRed:93/255.0 green:181/255.0 blue:235/255.0 alpha:1.0] forState:UIControlStateNormal];
        [deleteButton setTitleColor:UIColorFromRGB(0xa8a8aa) forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:deleteButton];
    }
    //个人生活添加删除按钮
    if ([self.identifer isEqualToString:@"1"]) {
        NSLog(@"添加了删除按钮");
        int delete_x_position = timeLable.frame.origin.x + timeLable.frame.size.width;
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(delete_x_position, y2-4, 50, 21)];
        deleteButton.tag = indexPath;
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton setTitle:@"删除" forState:UIControlStateHighlighted];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [deleteButton setTitleColor:[UIColor colorWithRed:93/255.0 green:181/255.0 blue:235/255.0 alpha:1.0] forState:UIControlStateNormal];
        [deleteButton setTitleColor:UIColorFromRGB(0xa8a8aa) forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:deleteButton];
    }
    
    if (![self.identifer isEqualToString:@"1"]) {
        //评论图标
        messageImageView = nil;
        messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(269, y2+1, 16, 14)];
        [messageImageView setImage:[UIImage imageNamed:@"issue_speech_no@2x.png"]];
        [cellView addSubview:messageImageView];
        //评论数量
        UILabel *count_review = [[UILabel alloc] initWithFrame:CGRectMake(269+19, y2, 50, 15)];
        [count_review setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];//格式
        count_review.textColor = UIColorFromRGB(0xa8a8aa);
        count_review.text = info.review_num;
        //NSLog(@"%@",info.review_num);
        [cellView addSubview:count_review];
    }
    return cellView;
}
-(void)longPressGestureRecognized :(UILongPressGestureRecognizer *)gestureRecognizer
{
    //寻找view下的lable
    if (isFirst) {
        isFirst = NO;
        NSLog(@"the gesture is %d",gestureRecognizer.view.tag);
        UIView *superView = gestureRecognizer.view;
        //移除btn内部的image
        for (id obj in superView.subviews) {
            if ([obj isKindOfClass:[OHAttributedLabel class]]) {
                LinFriendCircleInfo *info = [[LinFriendCircleInfo alloc] init];
                info = [FriendCircleList objectAtIndex:gestureRecognizer.view.tag];
                NSString *str = info.com_text;
                NSLog(@"%@",str);
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:str];
            }
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文字已经复制" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        alert.tag = 3;
        [alert show];
//        NSLog(@"长按复制");
//        //弹出复制menubar
//         UIMenuController *copyMenu = [UIMenuController sharedMenuController];
//        [copyMenu setTargetRect:gestureRecognizer.view.frame inView:superView];
//        copyMenu.arrowDirection = UIMenuControllerArrowDown;
//        [copyMenu setMenuVisible:YES animated:YES];
    }
}
#pragma mark-------alertdelegate
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        isFirst = YES;
//    }
//}
#pragma mark-------lable delegate
#pragma mark - HTCopyableLabelDelegate
- (NSString *)stringToCopyForCopyableLabel:(OHAttributedLabel *)copyableLabel
{
    NSString *stringToCopy = @"";
    stringToCopy = copyableLabel.text;
    return stringToCopy;
}

- (CGRect)copyMenuTargetRectInCopyableLabelCoordinates:(OHAttributedLabel *)copyableLabel
{
    CGRect rect;
    // The UIMenuController will appear close to the label itself
    rect = copyableLabel.bounds;
    return rect;
}

#pragma mark-------删除帖子方法
-(void)deleteAction:(UIButton*)sender
{
    NSLog(@"删除帖子");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否删除您发的帖子" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    alert.tag = sender.tag;
    [alert show];
}

#pragma mark-------alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3) {
        if (buttonIndex == 0) {
            isFirst = YES;
        }
    }else{
        if (buttonIndex == 0) {
            //调用删除的代理方法
            [delegate deleteAction:alertView.tag];
        }
    }
}

-(BOOL)isEmoji :(NSString*)str
{
    NSString *regex_emoji = @"\\[[^x00-xff]{1,3}\\]";
    //截取第一行的字符串 计算出一个合理的截取长度
    CGFloat length = 0;
    int count = 0;
    for (int i=0;i<str.length;i++) {
        NSRange bankRang = NSMakeRange(i, 1);
        NSString *ele = [str substringWithRange:bankRang];
        char c = [str characterAtIndex:i];
        count++;
        if ([self validateChinese:ele]) {
            length+=1;
        }else{
            if ((c>='a'&&c<='z') || c == ' ')
            {
                length += 0.5;
            }else if(c>'1' && c <'9'){
                length += 0.5;
            }else if(c>='A'&&c<='Z'){
                length += 0.5;
            }else{
                length += 0.5;
            }
        }
        if (length >= 20 ) {
            break;
        }
    }
    NSRange bankRang = NSMakeRange(0, count);
    NSString *testStr = [str substringWithRange:bankRang];
    NSArray *array_emoji = [testStr componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count]>0) {
        return YES;
    }
    return NO;
}

-(int)count_pic :(NSArray*)picList
{
    int count = 0;
    for (NSString *str in picList) {
        if (str.length > 0) {
            count++;
        }
    }
    return count;
}

-(CGFloat)Linlength_str:(NSString*)string
{
    NSString *text = string;
    CGFloat length = 0;
    for (int i=0;i<text.length;i++) {
        NSRange bankRang = NSMakeRange(i, 1);
        NSString *ele = [text substringWithRange:bankRang];
        char c = [text characterAtIndex:i];
        if ([self validateChinese:ele]) {
            length+=1;
        }else{
            if ((c>='a'&&c<='z') || c == ' ')
            {
                length += 0.5;
            }else{
                length += 1.0;
            }
            
        }
    }
    return length;
}

-(BOOL)validateChinese:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符 @"\\[[^x00-xff]{1,3}\\]"
    NSString *phoneRegex = @"[^x00-xff]";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

-(CGFloat)length_str:(NSString*)string
{
    NSString *text = string;
    NSString *regex_emoji = @"\\[[^x00-xff]{1,3}\\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count])
    {
        for (NSString *str in array_emoji)
        {
            NSRange range = [text rangeOfString:str];
            NSString *replaceStr = @"$";
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:replaceStr];
        }
    }
    CGFloat length = 0;
    for (int i=0;i<text.length;i++) {
        char c=[text characterAtIndex:i];
        if ((c>='a'&&c<='z') || c == ' ')
        {
            length += 0.5;
        }else if(c == '$'){
            length += 1.3;
        }else{
            length += 1.0;
        }
    }
    return length;
}

@end
