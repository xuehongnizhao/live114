//
//  LinFriendCircleDetailController.h
//  EnjoyDQ
//
//  Created by lin on 14-8-16.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FaceBoard.h"
#import "PhotoBrowserViewController.h"
#import "PhotoView.h"
#import "UMSocial.h"
#import "BaseViewController.h"
#import "LinFriendCircleInfo.h"

@interface LinFriendCircleDetailController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate, FaceBoardDelegate ,PhotoBrowserViewControllerDelegate,photoViewDelegate,AVAudioPlayerDelegate,UIWebViewDelegate,UMSocialUIDelegate>
{
    BOOL isFirstShowKeyboard;
    
    BOOL isButtonClicked;
    
    BOOL isKeyboardShowing;
    
    BOOL isSystemBoardShow;
    
    
    CGFloat keyboardHeight;
    
    NSMutableArray *messageList;
    
    NSMutableDictionary *sizeList;
    
    FaceBoard *faceBoard;
    
    UIView *toolBar;
    
    UITextView *textView;
    
    UIButton *keyboardButton;
    
    UIButton *sendButton;
    
    NSArray *_photos;
}

//由上一个界面传过来的
@property (strong, nonatomic) NSString *cur_id;
@property (strong, nonatomic) NSString *com_id;
@property (strong, nonatomic) NSString *lin_user_pic;
@property (strong, nonatomic) NSString *lin_user_name;
@property (strong, nonatomic) NSString *lin_com_text;
@property (strong, nonatomic) NSArray *lin_pic_list_short;
@property (strong, nonatomic) NSArray *lin_pic_list_clear;
@property (strong, nonatomic) NSString *lin_add_time;
@property (strong, nonatomic) NSMutableArray *lin_review_list;
@property (strong, nonatomic) NSString *lin_com_voice;
//@property (weak, nonatomic) IBOutlet UITableView *LinFriendCircleTableview;
@property (strong, nonatomic) AVAudioPlayer * player;//播放音乐
@property (strong, nonatomic) MKNetworkOperation *downloadOperation;
@property (strong, nonatomic) LinFriendCircleInfo *detailInfo;
@end
