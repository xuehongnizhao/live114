//
//  ImageUploadViewController.m
//  cityo2o
//
//  Created by mac on 16/5/12.
//  Copyright © 2016年 Sky. All rights reserved.
//图片路况

#import "ImageUploadViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>
@interface ImageUploadViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *currentLocation;
@property (weak, nonatomic) IBOutlet UIButton *EtoW;
@property (weak, nonatomic) IBOutlet UIButton *WtoE;
@property (weak, nonatomic) IBOutlet UIButton *StoN;
@property (weak, nonatomic) IBOutlet UIButton *NtoS;
@property (weak, nonatomic) IBOutlet UITextView *descriptionForCondition;
@property (weak, nonatomic) IBOutlet UIButton *sendCondition;
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
@property (weak, nonatomic) IBOutlet UIView *locationCell;
@property (strong, nonatomic) NSString *lastChosenMediaType;
@property (strong, nonatomic) UIImageView *contentimageview;
@property (strong, nonatomic) UITableView *locationChose;
@end

@implementation ImageUploadViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}
- (IBAction)dismissViewController:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 2016.5 调用相册
- (IBAction)takePhoto:(UIButton *)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
      [alert show];
}
- (void)setNearbyRoad:(NSArray *)nearbyRoad{
    _nearbyRoad=nearbyRoad;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1)
            [self shootPiicturePrVideo];
    else if(buttonIndex==2)
            [self selectExistingPictureOrVideo];
}
-(void)shootPiicturePrVideo{
        [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
-(void)selectExistingPictureOrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([_lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
        {
                UIImage *chosenImage=[info objectForKey:UIImagePickerControllerEditedImage];
                _contentimageview.image=chosenImage;
            
#warning 2016.5 保存图片
            }
    if([_lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
        {
                   UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
    
            }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
        [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
            NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
            UIImagePickerController *picker=[[UIImagePickerController alloc] init];
            picker.mediaTypes=mediatypes;
            picker.delegate=self;
            picker.allowsEditing=YES;
            picker.sourceType=sourceType;
            NSString *requiredmediatype=(NSString *)kUTTypeImage;
            NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
            [picker setMediaTypes:arrmediatypes];
        [self presentViewController:picker animated:YES completion:nil];
        }
    else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
        }
}
/*
 尺寸
//static UIImage *shrinkImage(UIImage *orignal,CGSize size)
//{
//    CGFloat scale=[UIScreen mainScreen].scale;
//    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
//    CGContextRef context=CGBitmapContextCreate(NULL, size.width *scale,size.height*scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGContextDrawImage(context, CGRectMake(0, 0, size.width*scale, size.height*scale), orignal.CGImage);
//    CGImageRef shrunken=CGBitmapContextCreateImage(context);
//    UIImage *final=[UIImage imageWithCGImage:shrunken];
//    CGContextRelease(context);
//    CGImageRelease(shrunken);
//    return  final;
//}
 */
- (IBAction)EtoW:(UIButton *)sender {
    self.EtoW.selected=!self.EtoW.selected;
}
- (IBAction)WtoE:(UIButton *)sender {
    self.WtoE.selected=!self.WtoE.selected;
}
- (IBAction)StoN:(UIButton *)sender {
    self.StoN.selected=!self.StoN.selected;
}
- (IBAction)NtoS:(UIButton *)sender {
    self.NtoS.selected=!self.NtoS.selected;
}
- (IBAction)sendCondition:(UIButton *)sender {
    
}

- (void)setUI{
    self.EtoW.layer.borderColor=[UIColor colorWithRed:0.0 green:0.502 blue:1.0 alpha:1.0].CGColor;
    self.EtoW.layer.borderWidth=2.f;
    self.WtoE.layer.borderColor=[UIColor colorWithRed:0.0 green:0.502 blue:1.0 alpha:1.0].CGColor;
    self.WtoE.layer.borderWidth=2.f;
    self.StoN.layer.borderColor=[UIColor colorWithRed:0.0 green:0.502 blue:1.0 alpha:1.0].CGColor;
    self.StoN.layer.borderWidth=2.f;
    self.NtoS.layer.borderColor=[UIColor colorWithRed:0.0 green:0.502 blue:1.0 alpha:1.0].CGColor;
    self.NtoS.layer.borderWidth=2.f;
    self.sendCondition.layer.cornerRadius=5.f;
    self.sendCondition.clipsToBounds=YES;
    self.EtoW.layer.cornerRadius=5.f;
    self.EtoW.clipsToBounds=YES;
    self.WtoE.layer.cornerRadius=5.f;
    self.WtoE.clipsToBounds=YES;
    self.StoN.layer.cornerRadius=5.f;
    self.StoN.clipsToBounds=YES;
    self.NtoS.layer.cornerRadius=5.f;
    self.NtoS.clipsToBounds=YES;
    self.descriptionForCondition.delegate=self;
    UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loacationCellAction)];
    [self.locationCell addGestureRecognizer:tapG];
    self.currentLocation.text=self.nearbyRoad[0];
    
}

- (void)loacationCellAction{
    _locationChose=[[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    _locationChose.delegate=self;
    _locationChose.dataSource=self;
    [self.view addSubview:_locationChose];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSLog(@"%@",self.nearbyRoad[indexPath.row]);
    cell.textLabel.text=self.nearbyRoad[indexPath.row];
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nearbyRoad.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentLocation.text=self.nearbyRoad[indexPath.row];
    [UIView animateWithDuration:.35 animations:^{
        self.locationChose.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        self.locationChose=nil;
    }];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text=@"";
}


@end
