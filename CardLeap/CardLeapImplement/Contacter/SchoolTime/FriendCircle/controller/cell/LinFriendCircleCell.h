//
//  LinFriendCircleCell.h
//  EnjoyDQ
//
//  Created by lin on 14-8-14.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinFriendCircleInfo.h"
@interface LinFriendCircleCell : UITableViewCell
{
    UIView *LinTest;
    UILabel *Com_text_lable;
    UIView *LinTest1;
    UIImageView *com_image_view;
    UIView * LinTest2;
    UILabel *user_name_label;
    UILabel *user_review_lable;
    UILabel *timeLable;
    UIImageView *timeImageView;
    UIImageView *messageImageView ;
}
@property (weak, nonatomic) IBOutlet UIImageView *user_pic;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
//@property (weak, nonatomic) IBOutlet UIView *com_text_view;//废弃
//@property (weak, nonatomic) IBOutlet UIView *com_pic_view;//废弃
//@property (weak, nonatomic) IBOutlet UIView *review_list_view;//废弃
//@property (weak, nonatomic) IBOutlet UILabel *add_time;
-(void)configureCell :(LinFriendCircleInfo*)dic;
@end
