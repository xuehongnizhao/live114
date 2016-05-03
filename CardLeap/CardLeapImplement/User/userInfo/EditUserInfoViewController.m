//
//  EditUserInfoViewController.m
//  CardLeap
//
//  Created by mac on 15/1/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "EditUserInfoViewController.h"

@interface EditUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,
                                        UIActionSheetDelegate,UIImagePickerControllerDelegate,
                                        UITextFieldDelegate>
{
    UIImage *user_image_local;
}
@property (strong,nonatomic)UITableView *userInfoDetailTableview;//个人信息列表
@property (strong,nonatomic)UIButton *leftButton;//修改个人信息按钮
@property (strong,nonatomic)UITextField *user_name_T;//用户名显示框
@property (strong,nonatomic)UITextField *user_sex_T;//用户性别显示框
@property (strong,nonatomic)UITextField *user_phone_T;//用户手机号显示框
@property (strong,nonatomic)UITextField *user_address_T;//用户地址显示框
@property (strong,nonatomic)UIImageView *user_image;//用户头像
@end

@implementation EditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--------get data
-(void)getDataFromNet
{
    
}

#pragma mark--------get UI
-(UITableView *)userInfoDetailTableview
{
    if (!_userInfoDetailTableview) {
        _userInfoDetailTableview = [[UITableView alloc] initForAutoLayout];
        _userInfoDetailTableview.delegate = self;
        _userInfoDetailTableview.dataSource = self;
        _userInfoDetailTableview.separatorInset = UIEdgeInsetsZero;
        [UZCommonMethod hiddleExtendCellFromTableview:_userInfoDetailTableview];
    }
    return _userInfoDetailTableview;
}

-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
        [_leftButton setTitle:@"完成" forState:UIControlStateNormal];
        [_leftButton setTitle:@"完成" forState:UIControlStateHighlighted];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_leftButton addTarget:self action:@selector(confirmEditAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

-(UITextField *)user_name_T
{
    if (!_user_name_T) {
        _user_name_T = [[UITextField alloc] initForAutoLayout];
        _user_name_T.delegate = self;
        _user_name_T.userInteractionEnabled = [EDITENABLE boolValue];
        _user_name_T.leftViewMode = UITextFieldViewModeAlways;
        //_connect_phone_T.borderStyle=UITextBorderStyleRoundedRect;
        _user_name_T.textColor = UIColorFromRGB(0x6d6f72);
        _user_name_T.font = [UIFont systemFontOfSize:14.0f];
        _user_name_T.tintColor = UIColorFromRGB(tintColors);
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 60, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(0x7c7c7c);
        leftLable.text = @"用户名       ";
        _user_name_T.leftView = leftLable;
    }
    return _user_name_T;
}

-(UITextField *)user_sex_T
{
    if (!_user_sex_T) {
        _user_sex_T = [[UITextField alloc] initForAutoLayout];
        _user_sex_T.delegate = self;
        _user_sex_T.userInteractionEnabled = NO;
        _user_sex_T.leftViewMode = UITextFieldViewModeAlways;
        _user_sex_T.tintColor = UIColorFromRGB(tintColors);
        //_connect_phone_T.borderStyle=UITextBorderStyleRoundedRect;
        _user_sex_T.textColor = UIColorFromRGB(0x6d6f72);
        _user_sex_T.font = [UIFont systemFontOfSize:14.0f];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 60, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(0x7c7c7c);
        leftLable.text = @"性   别       ";
        _user_sex_T.leftView = leftLable;
    }
    return _user_sex_T;
}

-(UITextField *)user_phone_T
{
    if (!_user_phone_T) {
        _user_phone_T = [[UITextField alloc] initForAutoLayout];
        _user_phone_T.delegate = self;
        _user_phone_T.userInteractionEnabled = NO;
        _user_phone_T.leftViewMode = UITextFieldViewModeAlways;
         _user_phone_T.tintColor = UIColorFromRGB(tintColors);
        //_connect_phone_T.borderStyle=UITextBorderStyleRoundedRect;
        _user_phone_T.textColor = UIColorFromRGB(0x6d6f72);
        _user_phone_T.font = [UIFont systemFontOfSize:14.0f];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 60, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(0x7c7c7c);
        leftLable.text = @"手机号       ";
        _user_phone_T.leftView = leftLable;
        
    }
    return _user_phone_T;
}

-(UITextField *)user_address_T
{
    if (!_user_address_T) {
        _user_address_T = [[UITextField alloc] initForAutoLayout];
        _user_address_T.delegate = self;
        _user_address_T.userInteractionEnabled = [EDITENABLE boolValue];
        _user_address_T.leftViewMode = UITextFieldViewModeAlways;
        _user_address_T.tintColor = UIColorFromRGB(tintColors);
        //_connect_phone_T.borderStyle=UITextBorderStyleRoundedRect;
        _user_address_T.textColor = UIColorFromRGB(0x6d6f72);
        _user_address_T.font = [UIFont systemFontOfSize:14.0f];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 60, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(0x7c7c7c);
        leftLable.text = @"地   址     ";
        _user_address_T.leftView = leftLable;
    }
    return _user_address_T;
}

-(UIImageView *)user_image
{
    if (!_user_image) {
        _user_image = [[UIImageView alloc] initForAutoLayout];
    }
    return _user_image;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"";
    }
}

#pragma mark--------set UI
-(void)setUI
{
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.rightBarButtonItem = leftBar;
    
    [self.view addSubview:self.userInfoDetailTableview];
    [_userInfoDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_userInfoDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_userInfoDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_userInfoDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    
}

#pragma mark--------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        NSLog(@"修改头像");
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"取消"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:@"打开相机",@"从相册中选择", nil];
        myActionSheet.tag = 1;
        [myActionSheet showInView:self.view];
    }else if (section == 1){
        if (row == 1) {
            NSLog(@"选择性别");
            UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"取消"
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:@"男",@"女", nil];
            myActionSheet.tag = 2;
            [myActionSheet showInView:self.view];
        }else{
            
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60.0;
    }
    return 40.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"user_info_edit_cell";
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [cell.contentView addSubview:self.user_image];
        [_user_image autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_user_image autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_user_image autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_user_image autoSetDimension:ALDimensionWidth toSize:40.0f];
        if (user_image_local == nil) {
            [_user_image sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].user_pic] placeholderImage:[UIImage imageNamed:@"user"]];
        }else{
            _user_image.image = user_image_local;
        }
        _user_image.layer.masksToBounds = YES;
        _user_image.layer.cornerRadius = 20.0f;
        
        UILabel *titleLable = [[UILabel alloc] initForAutoLayout];
        [cell.contentView addSubview:titleLable];
        titleLable.textColor = UIColorFromRGB(0x484848);
        titleLable.font = [UIFont systemFontOfSize:15.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
        [titleLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_user_image withOffset:20.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [titleLable autoSetDimension:ALDimensionHeight toSize:25.0f];
        titleLable.text = @"修改头像";
    }else if (section == 1){
        if (row == 0) {
            [cell.contentView addSubview:self.user_name_T];
            [_user_name_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_user_name_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_user_name_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_user_name_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            if ([[UserModel shareInstance].user_nickname isEqualToString:@""]) {
                _user_name_T.text = @"未填写";
            }else{
                _user_name_T.text = [UserModel shareInstance].user_nickname;
            }
        }else{
            [cell.contentView addSubview:self.user_sex_T];
            [_user_sex_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_user_sex_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_user_sex_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_user_sex_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            if ([[UserModel shareInstance].sex integerValue]==1) {
                _user_sex_T.text = @"男";
            }else{
                _user_sex_T.text = @"女";
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (section == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (row == 0) {
            [cell.contentView addSubview:self.user_phone_T];
            [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            if ([[UserModel shareInstance].user_tel isEqualToString:@""]) {
                _user_phone_T.text = @"未填写";
            }else{
                _user_phone_T.text = [UserModel shareInstance].user_tel;
            }
        }else{
            [cell.contentView addSubview:self.user_address_T];
            [_user_address_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_user_address_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_user_address_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_user_address_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            if ([[UserModel shareInstance].user_address isEqualToString:@""]) {
                _user_address_T.text = @"未填写";
            }else{
                _user_address_T.text = [UserModel shareInstance].user_address;
            }
        }
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    return 5.0f;
}

#pragma mark--------button action
-(void)confirmEditAction:(UIButton*)sender
{
    NSLog(@"确认修改信息");
    if (user_image_local == nil) {
        NSLog(@"未修改头像");
        [self postMessage];
    }else{
        //上传 头像
        NSString *pic_url = connect_url(@"yz_upload_pic");
        NSData* data=UIImageJPEGRepresentation(user_image_local, 0.3);
        NSDictionary *dict = @{
                               @"app_key":pic_url,
                               @"u_id":[UserModel shareInstance].u_id,
                               @"session_key":[UserModel shareInstance].session_key
                               };
        [Base64Tool postFileTo:pic_url andParams:dict andFile:data andFileName:@"pic" isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200) {
                [UserModel shareInstance].user_pic = [param[@"obj"] objectForKey:@"user_pic"];
                [self postMessage];
            }else{
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }
}

-(void)postMessage
{
    //上传 信息
    NSString *user_name = self.user_name_T.text;
    NSString *user_sex = self.user_sex_T.text;
    NSString *user_tel = self.user_phone_T.text;
    NSString *user_address = self.user_address_T.text;
    if (user_name.length != 0 && user_sex.length!=0 && user_tel.length!=0 && user_address.length!=0) {
        [SVProgressHUD showWithStatus:@"正在提交信息" maskType:SVProgressHUDMaskTypeNone];
        NSString *user_url = connect_url(@"yz_edit_info");
        NSString *sex;
        if ([user_sex isEqualToString:@"男"]) {
            sex = @"1";
        }else{
            sex = @"0";
        }
        NSDictionary *dict = @{
                               @"app_key":user_url,
                               @"user_tel":user_tel,
                               @"user_address":user_address,
                               @"user_nickname":user_name,
                               @"sex":sex,
                               @"u_id":[UserModel shareInstance].u_id,
                               @"session_key":[UserModel shareInstance].session_key
                               };
        [Base64Tool postSomethingToServe:user_url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200) {
                NSLog(@"修改成功");
                [SVProgressHUD dismiss];
                [UserModel shareInstance].user_nickname = user_name;
                [UserModel shareInstance].sex = sex;
                [UserModel shareInstance].user_address = user_address;
                [UserModel shareInstance].user_tel = user_tel;
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小助手" message:@"信息不完整" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark-----uiactionsheet delegate
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:
                [self takePhoto];//打开相机
                break;
            case 1:
                [self loadPhoto];//打开本地相册
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:
                self.user_sex_T.text = @"男";
                break;
            case 1:
                self.user_sex_T.text = @"女";
                break;
        }
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        picker.delegate = self;
        
        picker.allowsEditing = YES;
        
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"无法打开相机,请在真机中调试！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
}

//打开本地相册
-(void)loadPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{}];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info==%@",info);
    //UIImagePickerControllerEditedImage
    //UIImagePickerControllerOriginalImage
    //UIImagePickerControllerCropRect
    //UIImagePickerControllerMediaType
    //UIImagePickerControllerReferenceURL
    
    UIImage *image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    user_image_local = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.userInfoDetailTableview reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
