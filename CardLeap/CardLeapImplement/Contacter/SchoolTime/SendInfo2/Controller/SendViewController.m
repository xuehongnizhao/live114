//
//  SendViewController.m
//  SendInfo2
//
//  Created by Sky on 14-8-15.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import "SendViewController.h"
#import "JSBadgeView.h"
#import "UITableView+DataSourceBlocks.h"
#import "UITableView+DelegateBlocks.h"
#import "SelectionCell.h"
#import "SSCheckBoxView.h"
#import "LinFriendCircleController.h"
#import "TableViewWithBlock.h"
#import "UITableView+DataSourceBlocks.h"
#import "UITableView+DelegateBlocks.h"
#import "SelectionCell.h"
#import "SSCheckBoxView.h"
#import "UserModel.h"
#import "LoginViewController.h"
#import "UserModel.h"
#import "UUProgressHUD.h"

@interface SendViewController ()
@property (strong,nonatomic)UILabel *hintLable;
@end

@implementation SendViewController
{
    SelectBar* selectBar;
    FaceBoard* faceBoard;
    VoiceView* voiceView;
    PhotoView* photoView;
    NSMutableArray* viewArray;
    
    UITextView* mTextView;
    
    UILabel* placeholder;
    
    BOOL isShowSystemKeyBoard;
    
    NSMutableArray* imageArray;
    
    NSMutableDictionary* selectedImageDict;
    
    UIImage* addimage;
    
    DoImagePickerController *cont;
    
    NSInteger cameraNumber;
    
    //语音流
    NSData* voiceData;
    
    //是否发送语音
    BOOL isSendVoice;
    
    BOOL isFromCamera;
    
    BOOL isPublic;//是否公开
    BOOL isOpened;//下拉框状态
    UITextView *cateText;//分类框显示
    UIButton *cateButton;
    int cat_height;
    UIView *cateView;//分类view
    BOOL isLast;
}
@synthesize tb = _tb;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
    [self initData];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    //[mTextView becomeFirstResponder];
}

-(void)initData
{
    isLast = NO;
    isPublic = YES;
    viewArray=[[NSMutableArray alloc]init];
    isShowSystemKeyBoard=YES;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    imageArray=[[NSMutableArray alloc]init];
    selectedImageDict=[[NSMutableDictionary alloc]init];
    isSendVoice=NO;
    cameraNumber=0;
    isFromCamera=NO;
}

-(void)setUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"创建内容";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//设置bar的风格，控制字体颜色
    UIButton* rightbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame=CGRectMake(0, 0, 44, 44);
    [rightbutton setImage:[UIImage imageNamed:@"issue_plane_no"] forState:UIControlStateNormal];
    [rightbutton setImage:[UIImage imageNamed:@"issue_plane_sel"] forState:UIControlStateSelected];
    rightbutton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, -25);
    [rightbutton addTarget:self action:@selector(sendInfol:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    
    UIButton* leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame=CGRectMake(0, 0, 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"issue_back_no"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"issue_back_sel"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, -30, 0, 0);
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    CGFloat my_height = SCREEN_HEIGHT - 64;
    
    selectBar=[[SelectBar alloc]initWithFrame:CGRectMake(0, my_height-216*LinHeightPercent - 50, 320*LinPercent, 50)];
    selectBar.delegate=self;
    [self.view addSubview:selectBar];
    NSLog(@"%f",SCREEN_HEIGHT);
    //默认下面的view都不显示
    photoView=[[PhotoView alloc]initWithFrame:CGRectMake(0, my_height-216*LinHeightPercent, 320*LinPercent, 216*LinHeightPercent)];
    photoView.backgroundColor=[UIColor whiteColor];
    photoView.tag=3;
    photoView.delegate=self;
    [viewArray addObject:photoView];
    [self.view addSubview:photoView];
    [photoView setHidden:YES];
    faceBoard=[[FaceBoard alloc]init];
    faceBoard.delegate=self;
    faceBoard.tag=1;
    [viewArray addObject:faceBoard];
    [self.view addSubview:faceBoard];
    [faceBoard setHidden:YES];
    
    voiceView=[[VoiceView alloc]initWithFrame:CGRectMake(0, my_height-216*LinHeightPercent, 320*LinPercent, 216*LinHeightPercent)];
    voiceView.tag=4;
    voiceView.delegate=self;
    [viewArray addObject:voiceView];
    [self.view addSubview:voiceView];
    [voiceView setHidden:YES];
    
    mTextView =[[UITextView alloc]initWithFrame:CGRectMake(0, 10, 320*LinPercent, 150)];
    mTextView.backgroundColor=UIColorFromRGB(0xfdfdfd);
    mTextView.delegate = self;
    //mTextView.contentVerticalAlignment=UIControlContentVerticalAlignmentTop;
    [mTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [mTextView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    mTextView.backgroundColor=[UIColor whiteColor];
    mTextView.delegate=self;
    
    [self.view addSubview:mTextView];
    
    placeholder=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 200, 30)];
    placeholder.text=@"想说什么就说嘛，200字以内...";
    placeholder.enabled=NO;
    placeholder.backgroundColor=[UIColor clearColor];
    [mTextView addSubview:placeholder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self.view addSubview:self.hintLable];
    [_hintLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
    [_hintLable autoSetDimension:ALDimensionHeight toSize:15.0f];
    [_hintLable autoSetDimension:ALDimensionWidth toSize:60.0f];
    [_hintLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:mTextView withOffset:5.0f];
}

-(UILabel *)hintLable
{
    if (!_hintLable) {
        _hintLable = [[UILabel alloc] initForAutoLayout];
        _hintLable.text = @"0/200";
        //_hintLable.layer.borderWidth = 1;
        _hintLable.font = [UIFont systemFontOfSize:11.0f];
        _hintLable.textAlignment = NSTextAlignmentRight;
    }
    return _hintLable;
}

#pragma mark----添加分类和是否公开
-(void)addCate
{
    //    cateView = [[UIView alloc] initWithFrame:CGRectMake(0, 188, 320, 50)];
    //    [cateView setBackgroundColor:[UIColor whiteColor]];
    //    cateText = [[UITextView alloc] initWithFrame:CGRectMake(10, 8, 170, 35)];
    //    cateText.layer.masksToBounds = YES;
    //    cateText.layer.cornerRadius  = 4;
    //    cateText.layer.borderWidth = 0.5;
    //    cateText.font = [UIFont systemFontOfSize:14];
    //    cateText.editable = NO;
    //
    //    //[cateText setUserInteractionEnabled:NO];
    //    cateText.text = [[self.cateDic allKeys] objectAtIndex:0];
    //    [cateView addSubview:cateText];
    //    cateButton = [[UIButton alloc] initWithFrame:CGRectMake(135, 0, 35, 35)];
    //    cateButton.layer.borderWidth  = 0.5;
    //    cateButton.layer.masksToBounds = YES;
    //    cateButton.layer.cornerRadius = 4;
    //    [cateButton setImage:[UIImage imageNamed:@"slete.png"] forState:UIControlStateNormal];
    //    [cateButton setImage:[UIImage imageNamed:@"slete.png"] forState:UIControlStateHighlighted];
    //    [cateButton addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    //    [cateText addSubview:cateButton];
    //
    //    CGRect maleFrame = CGRectMake(195, 5, 120, 60);
    //    SSCheckBoxView *maleButton = [[SSCheckBoxView alloc] initWithFrame:maleFrame
    //                                                                 style:kSSCheckBoxViewStyleGlossy
    //                                                               checked:isPublic];
    //    [maleButton setText:@"是否公开"];
    //    [maleButton setStateChangedTarget:self
    //                             selector:@selector(public:)];
    //    [maleButton setChecked:YES];
    //    if ([[UserModel shareInstance].my_class isEqualToString:@"0"]) {
    //        maleButton.enabled = NO;
    //    }
    //    [cateView addSubview:maleButton];
    //    [self.view addSubview:cateView];
}
#pragma mark----弹出下拉分类框
-(void)open
{
    if (isOpened) {
        
        [UIView animateWithDuration:0.3 animations:^{
            //            UIImage *closeImage=[UIImage imageNamed:@"dropdown.png"];
            CGRect frame=_tb.frame;
            frame.origin.y = cateView.frame.origin.y+8;;
            frame.size.height=0;
            [_tb setFrame:frame];
        } completion:^(BOOL finished){
            //
            isOpened=NO;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            //            UIImage *openImage=[UIImage imageNamed:@"dropup.png"];
            //[_openButton setImage:openImage forState:UIControlStateNormal];
            
            CGRect frame=_tb.frame;
            if (IS_HEIGHT_GTE_568 == 0) {
                frame.origin.y =  cateView.frame.origin.y+8-cat_height+20;
                frame.size.height = cat_height - 20;
            }else{
                frame.origin.y =  cateView.frame.origin.y+8-cat_height;
                frame.size.height = cat_height;
            }
            [_tb setFrame:frame];
        } completion:^(BOOL finished){
            isOpened=YES;
        }];
    }
}
#pragma mark-----是否公开
-(void)public :(SSCheckBoxView *)cbv
{
    if (isPublic == NO) {
        isPublic = YES;
        //[alertMessage alertMsg:@"zhen"];
    }else{
        isPublic = NO;
        //[alertMessage alertMsg:@"+"];
    }
    
}
#pragma mark------返回按钮
-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark------发送信息
-(void)sendInfol:(UIButton*) sender
{
    if (ApplicationDelegate.islogin == NO) {
        //跳转到登录
        LoginViewController *firVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        if (mTextView.text.length < 200) {
            if (photoView.photoArray.count<9&&photoView.photoArray.count!=1)
            {
                [photoView.photoArray removeLastObject];
            }
            NSLog(@"发送信息");
            NSMutableArray* files=[[NSMutableArray alloc]init];
            NSMutableArray* fileNames=[[NSMutableArray alloc]init];
            int i=0;
            NSLog(@"%lu",(unsigned long)photoView.photoArray.count);
            if (photoView.photoArray.count>=1 )
            {
                if (photoView.photoArray.count == 1) {
                    UIImage *image = [photoView.photoArray objectAtIndex:0];
                    if (image != [UIImage imageNamed:@"issue_add_sel"]) {
                        for (UIImage* image in photoView.photoArray)
                        {
                            NSData* data=UIImageJPEGRepresentation(image, 0.3);
                            [files addObject:data];
                            NSString* name=[NSString stringWithFormat:@"com_pic[%d]",i];
                            //NSString* name=@"com_pic";
                            i++;
                            [fileNames addObject:name];
                        }
                    }
                }else{
                    for (UIImage* image in photoView.photoArray)
                    {
                        NSData* data=UIImageJPEGRepresentation(image, 0.3);
                        [files addObject:data];
                        NSString* name=[NSString stringWithFormat:@"com_pic[%d]",i];
                        //NSString* name=@"com_pic";
                        i++;
                        [fileNames addObject:name];
                    }
                }
            }
            if (voiceData.length>0&&isSendVoice==YES)
            {
                [files addObject:voiceData];
                [fileNames addObject:@"com_voice"];
            }
            NSString *u_id = [UserModel shareInstance].u_id;
            NSString *session_key = [UserModel shareInstance].session_key;
            NSString *post_url = connect_url(@"com_add");
            //NSString *cat_str = cateText.text;
            NSString *lat = userDefault(@"u_lat");
            NSString *lng = userDefault(@"u_lng");
            if (lat == nil) {
                lat = @"0";
            }
            if (lng == nil) {
                lng = @"0";
            }
            NSMutableDictionary* dict=[NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"u_id":u_id,
                                                                                      @"app_key":post_url,
                                                                                      @"com_text":mTextView.text,
                                                                                      @"session_key":session_key,
                                                                                      @"com_lat":self.u_lat,
                                                                                      @"com_lng":self.u_lng
                                                                                      }];
            NSLog(@"files.count:%d",(int)files.count);
            NSLog(@"fileNames:%@",fileNames);
            NSLog(@"dict:%@",dict);
            //com_pic[0]
            //NSLog(@"files:%@",files);
            //如果不发送文字则 去掉字典中的关键字
            NSLog(@"mtextView.text:%@",mTextView.text);
            if ([mTextView.text isEqualToString:@""])
            {
                [dict removeObjectForKey:@"com_text"];
            }
            NSLog(@"after dict=%@",dict);
            if ([[dict allKeys] containsObject:@"com_text"]||files.count>0)
            {
                [SVProgressHUD showWithStatus:@"正在发送" maskType:SVProgressHUDMaskTypeClear];
                [Base64Tool postFileTo:post_url andParams:dict andFiles:files andFileNames:fileNames isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
                    if ([[param objectForKey:@"code"] isEqualToString:@"200"])
                    {
                        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"STARTRELOAD" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } andErrorBlock:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
                }];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"还没输入信息呢"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"输入信息过长，限制200字以内"];
        }
    }
}

#pragma mark-------UIKeyboardNotification
-(void)keyboardWillShow:(NSNotification*) notification
{
    isShowSystemKeyBoard=YES;
    NSLog(@"系统键盘弹出");
    for (UIView* view in viewArray)
    {
        [view setHidden:YES];
    }
    NSDictionary* dict=[notification userInfo];
    NSValue* endValue=[dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endKeyboardRect=[endValue CGRectValue];
    
    CGFloat endY=endKeyboardRect.origin.y-64-50;
    NSLog(@"当前y为:%f",endY);
    [UIView animateWithDuration:0.25 animations:^{
        selectBar.frame=CGRectMake(0, endY, 320*LinPercent, 50);
    }];
    //移动分类view
    //CGRect rect = cateView.frame;
    //CGRect rect = _tb.frame;
    //rect.origin.y = cateView.frame.origin.y + 8;
    //_tb.frame = rect;
}
-(void)keyboardWillHide:(NSNotification*) notification
{
    NSLog(@"系统键盘收起");
    isShowSystemKeyBoard=NO;
    CGFloat my_height = SCREEN_HEIGHT - 64;
    int height = my_height - 216*LinHeightPercent - 50;
    if (IS_HEIGHT_GTE_568==0) {
        height = height - 88;
    }
    [UIView animateWithDuration:0.25 animations:^{
        selectBar.frame=CGRectMake(0, height, 320*LinPercent, 50);
    }];
    //还原分类view
    height = 188;
    if (IS_HEIGHT_GTE_568==0) {
        height = 100;
    }
    //    CGRect rect = _tb.frame;
    //    rect.origin.y = cateView.frame.origin.y + 8;
    //    _tb.frame = rect;
}
//CGRectMake(10, cateView.frame.origin.y+8, 170, 0)
#pragma mark---------selectBarDelegate
-(void)selectecButtonTag:(NSInteger)buttonTag
{
    if (isShowSystemKeyBoard==YES)
    {
        [mTextView resignFirstResponder];
    }
    NSLog(@"buttonTag=%d",(int)buttonTag);
    switch (buttonTag)
    {
        case 1:
            if (faceBoard.isShow==NO)
            {
                NSLog(@"faceboardShow");
                [faceBoard setHidden:NO];
                faceBoard.isShow=YES;
                
                //修改其他
                photoView.isShow=NO;
                voiceView.isShow=NO;
                [photoView setHidden:YES];
                [voiceView setHidden:YES];
            }
            else
            {
                [faceBoard setHidden:YES];
                [self.view insertSubview:faceBoard atIndex:1];
                faceBoard.isShow=NO;
                [mTextView becomeFirstResponder];
                
            }
            break;
        case 2:
            NSLog(@"相机走起");
            [self takePicture];
            break;
        case 3:
            if (photoView.isShow==NO)
            {
                if (photoView.photoArray.count==0)
                {
                    [self localPicture];
                    
                }
                [photoView setHidden:NO];
                photoView.isShow=YES;
                
                faceBoard.isShow=NO;
                voiceView.isShow=NO;
                [faceBoard setHidden:YES];
                [voiceView setHidden:YES];
            }
            else
            {
                [photoView setHidden:YES];
                [self.view insertSubview:photoView atIndex:1];
                photoView.isShow=NO;
                [mTextView becomeFirstResponder];
            }
            break;
        case 4:
            if (voiceView.isShow==NO)
            {
                [voiceView setHidden:NO];
                voiceView.isShow=YES;
                
                faceBoard.isShow=NO;
                photoView.isShow=NO;
                [faceBoard setHidden:YES];
                [photoView setHidden:YES];
            }
            else
            {
                [voiceView setHidden:YES];
                [self.view insertSubview:voiceView atIndex:1];
                voiceView.isShow=NO;
                [mTextView becomeFirstResponder];
            }
            
            break;
            
            
        default:
            break;
    }
    
}
#pragma mark--------本地相册
-(void)localPicture
{
    NSInteger count = 3;
    NSLog(@"%f",LinPercent);
    if (LinPercent>1) {
        if (LinPercent>1.1) {
            count = 5;
        }else{
            count = 4;
        }
    }
    cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
    cont.nMaxCount = 9;
    cont.nColumnCount = count;
    //修改_dSelected字典以确保再次进入时显示已点击图片
    cont.dSelected=selectedImageDict;
    cont.title=@"相机胶卷";
    [self presentViewController:cont animated:YES completion:^{
        if (isFromCamera==YES)
        {
            [cont readAlbumList];
            //[cont.cvPhotoList reloadData];
            isFromCamera=NO;
        }
    }];
    //[self.navigationController pushViewController:cont animated:YES];
}
#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"didSelected:%@",picker.dSelected);
    selectedImageDict=picker.dSelected;
    NSLog(@"aselected:%@",aSelected);
    [photoView addNewsImageArray:aSelected];
    [self addButtonBadge];
    [photoView setHidden:NO];
    photoView.isShow=YES;
}
#pragma mark--------照相
-(void)takePicture
{
    // 拍照
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        NSLog(@"选择完毕");
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        //拍照结束保存到本地
        UIImageWriteToSavedPhotosAlbum(portraitImg,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
        
        //所选择的照片平移一张
        //        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        //        for (NSNumber* number in [selectedImageDict allKeys])
        //        {
        //            NSNumber *value = [selectedImageDict objectForKey:number];
        //            NSNumber *tmpKey = [NSNumber numberWithInt:[number intValue]+1];
        //            [tmpDic setObject:value forKey:tmpKey];
        //            //NSLog(@"object:%@",[selectedImageDict objectForKey:number]);
        //        }
        //        selectedImageDict = tmpDic;
        //每照一张相则从照片库里选择的就少一张
        //        cont.nMaxCount--;
        //        photoView.isFromCamera=YES;
        //        [photoView addNewsImageArray:@[portraitImg]];
        //        [self addButtonBadge];
        //[photoView setHidden:NO];
        //photoView.isShow=YES;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
        NSLog(@"停止选择");
    }];
}
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    //Handle the end of the image write process
    if(!error)
    {
        NSLog(@"顺位之前的dic:%@",selectedImageDict);
        NSMutableDictionary* newDict=[[NSMutableDictionary alloc]init];
        for (NSNumber* key in [selectedImageDict allKeys])
        {
            //key+1
            NSInteger newkey=[key integerValue]+1;
            //之前key的value
            NSNumber* value=selectedImageDict[key];
            
            [newDict setObject:value forKey:@(newkey)];
        }
        NSLog(@"顺位之后的dic:%@",newDict);
        //清楚字典 重新加入
        [selectedImageDict removeAllObjects];
        [selectedImageDict setValuesForKeysWithDictionary:newDict];
        NSLog(@"Image written to photo album");
        //设置已拍摄照片为选中状态
        selectedImageDict[@(0)] = @(selectedImageDict.count);
        isFromCamera=YES;
        [self localPicture];
        cameraNumber++;
        NSLog(@"已选择的图片字典:%@",selectedImageDict);
    }
    else
    {
        NSLog(@"Error writing to photo album:%@",[error localizedDescription]);
    }
}

#pragma mark--------addButtonBadge
-(void)addButtonBadge
{
    NSLog(@"delete.count=%lu",(unsigned long)photoView.photoArray.count);
    UIButton* button;
    for (UIView* view in selectBar.subviews)
    {
        if (view.tag==3)
        {
            button=(UIButton*)view;
        }
    }
    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:button alignment:JSBadgeViewAlignmentTopRight];
    if (photoView.photoArray.count==9)
    {
        badgeView.badgeText = [NSString stringWithFormat:@"%ld",(unsigned long)photoView.photoArray.count];
    }
    else if(photoView.photoArray.count!=1)
    {
        badgeView.badgeText = [NSString stringWithFormat:@"%ld",photoView.photoArray.count-1];
    }
    else
    {
        NSLog(@"全部删除");
        for (UIView* v in button.subviews)
        {
            if ([v isKindOfClass:[JSBadgeView class]])
            {
                [v removeFromSuperview];
            }
        }
        //全部删除 则相机照片数归0
        cameraNumber=0;
    }
    
}
#pragma mark--------textViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""])
    {
        placeholder.hidden=YES;
    }
    if ([text isEqualToString:@""]&&range.location==0&&range.length==1)
    {
        placeholder.hidden=NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == mTextView) {
        int count = (int)textView.text.length;
        if (count>=200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多输入200个字符" delegate:nil cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
            [alert show];
        }else{
            _hintLable.text = [NSString stringWithFormat:@"%d/200",count];
        }
    }
}

-(void)faceBoardTextViewDidChange:(UITextView *)textView andDelete:(BOOL)isDelete
{
    if (isDelete==NO)
    {
        mTextView.text=[mTextView.text stringByAppendingString:textView.text];
    }
    else
    {
        faceBoard.inputTextView.text=[NSString stringWithFormat:@"%@",mTextView.text];
    }
    
    if (mTextView.text.length==0)
    {
        placeholder.text=@"想说什么就说嘛，200字以内...";
    }
    else
    {
        placeholder.text=@"";
    }
    //表情键盘输入
    int count = (int)mTextView.text.length;
    if (count>=200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多输入200个字符" delegate:nil cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        [alert show];
    }else{
        _hintLable.text = [NSString stringWithFormat:@"%d/200",count];
    }
}
-(void)faceBoardDeleteFinsish:(UITextView *)text
{
    mTextView.text=text.text;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}



#pragma mark------------camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark--------photoViewDelegate
-(void)getMorePhoto
{
    [self localPicture];
}

-(void)showBrowserWithIndex:(NSInteger)index
{
    NSLog(@"showPhotoIndex:%ld",(long)index);
    PhotoBrowserViewController*  pbvc=[[PhotoBrowserViewController alloc]init];
    pbvc.delegate=self;
    pbvc.photoArray=[photoView.photoArray copy];
    pbvc.photoIndex=index;
    pbvc.imageDict=[selectedImageDict copy];
    pbvc.isAddImage=photoView.isAddImage;
    pbvc.title=@"相册";
    [self presentViewController:pbvc animated:YES completion:nil];
}

#pragma mark-------photoBrowserViewControllerDelegate
-(void)deletePhotoAtIndex:(NSInteger)photoIndex andPhotoTag:(NSInteger)photoTag
{
    NSLog(@"index:%ld",(long)photoIndex);
    NSLog(@"dict:%@",selectedImageDict);
    for (NSNumber* number in [selectedImageDict allKeys])
    {
        //NSLog(@"object:%@",[selectedImageDict objectForKey:number]);
        if ([@(photoTag) isEqualToNumber:[selectedImageDict objectForKey:number]])
        {
            NSLog(@"已找到匹配照片");
            [selectedImageDict removeObjectForKey:number];
            NSLog(@"seledict:%@",selectedImageDict);
        }
    }
    [photoView.photoArray removeObjectAtIndex:photoIndex];
    [photoView deleteReloadData];
    [self addButtonBadge];
}

#pragma mark------VoiceViewDelegate
-(void)sendDataWithFilePath:(NSString *)filePath
{
    NSLog(@"filePath:%@",filePath);
    NSData* data=[NSData dataWithContentsOfFile:filePath];
    voiceData=data;
    if (data)
    {
        NSLog(@"语音转流文件成功");
        NSLog(@"data.length:%lu",(unsigned long)data.length);
        UIButton* button;
        for (UIView* view in selectBar.subviews)
        {
            if (view.tag==4)
            {
                button=(UIButton*)view;
            }
        }
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:button alignment:JSBadgeViewAlignmentTopRight];
        badgeView.badgeText = @"1";
        isSendVoice=YES;
    }
}

-(void)deleteBadgeFromButton
{
    UIButton* button;
    for (UIView* view in selectBar.subviews)
    {
        if (view.tag==4)
        {
            button=(UIButton*)view;
            for (UIView* v in button.subviews)
            {
                if ([v isKindOfClass:[JSBadgeView class]])
                {
                    [v removeFromSuperview];
                }
            }
        }
    }
    isSendVoice=NO;
}

#pragma mark----屏幕尺寸匹配
-(void)changeSize{
    //cateview
    if (IS_HEIGHT_GTE_568 == 0) {
        CGRect rect = cateView.frame;
        rect.origin.y = 100;
        cateView.frame = rect;
        //selectBar
        rect = selectBar.frame;
        rect.origin.y = 150;
        selectBar.frame = rect;
        //文本输入框
        rect = mTextView.frame;
        rect.size.height = 82;
        mTextView.frame = rect;
        //xiangce
        rect = photoView.frame;
        rect.origin.y = 200;
        photoView.frame = rect;
        //语音
        rect = voiceView.frame;
        rect.origin.y = 200;
        voiceView.frame = rect;
        //键盘
        rect = faceBoard.frame;
        rect.origin.y = 200;
        faceBoard.frame = rect;
    }
}

-(void)viewDidLayoutSubviews
{
    [self changeSize];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPPLAY" object:nil];
    [UUProgressHUD dismissWithError:@""];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHiddenTabbar:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
