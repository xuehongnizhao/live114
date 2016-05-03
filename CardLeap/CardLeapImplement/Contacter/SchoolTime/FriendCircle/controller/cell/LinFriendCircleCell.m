//
//  LinFriendCircleCell.m
//  EnjoyDQ
//
//  Created by lin on 14-8-14.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import "LinFriendCircleCell.h"


@implementation LinFriendCircleCell
@synthesize user_pic = _user_pic;
@synthesize user_name = _user_name;
//@synthesize com_text_view = _com_text_view;
//@synthesize com_pic_view = _com_pic_view;
//@synthesize review_list_view = _review_list_view;
//@synthesize add_time = _add_time;

-(void)configureCell :(LinFriendCircleInfo*)dic
{
    
    _user_name.text = dic.user_nickname;

    [_user_pic sd_setImageWithURL:[NSURL URLWithString:dic.user_pic] placeholderImage:[UIImage imageNamed:@"loading.png"]];
    _user_pic.layer.masksToBounds = YES;
    _user_pic.layer.cornerRadius = _user_pic.frame.size.height/2;
    CGFloat height = 0;
    NSString *com_text = dic.com_text;
    int count = com_text.length;
    height = ((count/16)+1) * 18;
    CGRect rect;
//    = _com_text_view.frame;
//    rect.size.height = height;
//    _com_text_view.frame = rect;
    LinTest = nil;
    LinTest = [[UIView alloc] initWithFrame:CGRectMake(68, 27, 232, height)];
    [LinTest setBackgroundColor:[UIColor grayColor]];
    [self addSubview:LinTest];
    //设置阅读全文 暂时搁置 以后再加
    Com_text_lable = nil;
    Com_text_lable = [[UILabel alloc] initWithFrame:CGRectMake(68, 27, 232, height)];
    Com_text_lable.text = dic.com_text;
    [Com_text_lable setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];//格式
    int line = (count/16)+1;
    [Com_text_lable setNumberOfLines: line];//行数，只有设为0才能自适应
    [self addSubview:Com_text_lable];
    
    
    //照片高度
    height = 0;
    NSArray *picList = dic.com_pic;
    count = [picList count]/3;
    int lin = [picList count] % 3;
    if (lin) {
        count ++;
    }
    height = (count)*70;
    rect = LinTest.frame;
    int y = rect.origin.y + rect.size.height + 10;
    LinTest1 = nil;
    LinTest1 = [[UIView alloc] initWithFrame:CGRectMake(68, y, 232, height)];
    [LinTest1 setBackgroundColor:[UIColor grayColor]];
    //[self addSubview:LinTest1];
    
    //NSLog(@"图片的个数%d",count);
    for (int n=0; n<[picList count]; n++) {
        int lines = n / 3;
        int col = n % 3;
        com_image_view = nil;
        com_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(70+col*75, y+5+lines*75, 68, 68)];
        //NSLog(@"dfasdfasdf%@",[picList objectAtIndex:n]);
        [com_image_view sd_setImageWithURL:[NSURL URLWithString:[picList objectAtIndex:n]] placeholderImage:[UIImage imageNamed:@"loading.png"]];
        [self addSubview:com_image_view];
    }
    
    //回复列表高度
    height = 0;
    NSArray *com_list = dic.com_list;
    NSString *review_num = dic.review_num;
    count = [review_num intValue];
    for (NSDictionary *ele in com_list) {
        //NSString *user_name = [ele objectForKey:@"user_name"];
       // NSLog(@"%@",user_name);
        NSString *rev_text = [ele objectForKey:@"rev_text"];
        int rev_count =  rev_text.length;
        int col_num = rev_count / 18 +2;
        if (col_num>4) {
            col_num = 4;
        }
        height += col_num*20;
    }
    rect = LinTest1.frame;
    int y1 = rect.origin.y + rect.size.height + 10;
    //NSLog(@"%d",y1);
    LinTest2 =nil;
    LinTest2 = [[UIView alloc] initWithFrame:CGRectMake(68, y1+10, 232, height)];
    [LinTest2 setBackgroundColor:[UIColor grayColor]];
    [self addSubview:LinTest2];
    
    //添加回复
    int n = 0;
    NSLog(@"评论列表为%@",com_list);
    if ([com_list count] != 0) {
        for (NSDictionary *ele in com_list) {
            NSString *user_name = [ele objectForKey:@"user_name"];
            NSString *rev_text = [ele objectForKey:@"rev_text"];
            //加用户名
            user_name_label = nil;
            user_name_label = [[UILabel alloc] initWithFrame:CGRectMake(70, y1+n*14+20, 232, 16)];
            [user_name_label setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];//格式
            [user_name_label setTextColor:[UIColor blueColor]];
            [user_name_label setNumberOfLines: 1];//行数，只有设为0才能自适应
            user_name_label.text = [NSString stringWithFormat:@"%@:",user_name];
            n++;
            [self addSubview:user_name_label];
            //加回复
            user_review_lable = nil;
            user_review_lable = [[UILabel alloc] initWithFrame:CGRectMake(80, y1+n*14+20, 232, 16)];
            int lines = rev_text.length / 18 + 1;
            [user_review_lable setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];//格式
            [user_review_lable setNumberOfLines: lines];//行数，只有设为0才能自适应
            user_review_lable.text = rev_text;
            n++;
            [self addSubview:user_review_lable];
        }

    }
    
    //帖子创建时间
    rect = LinTest2.frame;
    int y2 = rect.origin.y + rect.size.height + 10;
    timeLable = nil;
    timeLable = [[UILabel alloc] initWithFrame:CGRectMake(91, y2, 119, 21)];
    timeLable.text = dic.add_time;
    [self addSubview:timeLable];
    //创建时间的图标
    timeImageView = nil;
    timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(67, y2, 21, 21)];
    [timeImageView setImage:[UIImage imageNamed:@"issue_face_sel@2x.png"]];
    [self addSubview:timeImageView];
    messageImageView = nil;
    messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(279, y2, 21, 21)];
    [messageImageView setImage:[UIImage imageNamed:@"issue_picture_sel@2x.png"]];
    [self addSubview:messageImageView];

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

@end
