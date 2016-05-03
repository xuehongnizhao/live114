//
//  groupDetailTableViewCell.m
//  CardLeap
//
//  Created by mac on 15/1/26.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "groupDetailTableViewCell.h"
#import "AdBannerView.h"

@interface groupDetailTableViewCell()<AdBannerViewDelegate,UIWebViewDelegate>
{
     AdBannerView *_adBannerView;//轮播
}
@property (strong,nonatomic)UILabel *groupPrice;
@property (strong,nonatomic)UILabel *oldPrice;
@property (strong,nonatomic)UIButton *confirmButton;
//---
@property (strong,nonatomic)UIView *scoreView;
@property (strong,nonatomic)UILabel *scoreLalbe;
@property (strong,nonatomic)UILabel *rev_num_lable;
//---
@property (strong,nonatomic)UILabel *group_name_lable;
@property (strong,nonatomic)UILabel *shop_desc_lable;
@property (strong,nonatomic)UILabel *shop_pay_lable;
@property (strong,nonatomic)UILabel *group_time_lable;
//---
@property (strong,nonatomic)UILabel *shop_name_lable;
@property (strong,nonatomic)UILabel *shop_address_lable;
@property (strong,nonatomic)UIButton *call_phone_button;
//---
@property (strong,nonatomic)UILabel *shop_detail_lable;
//---
@property (strong,nonatomic)UIWebView *detailWeb;
@end

@implementation groupDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(AdBannerView*)_adBannerView
//{
//    
//}

//---列表传入detail message---
-(void)confirgureCell :(groupInfo*)info row:(NSInteger)row section:(NSInteger)section
{
    if (section == 0) {
        if (row == 0) {
            NSMutableArray *imageArray = [[NSMutableArray alloc] init];
            NSMutableArray *descArray = [[NSMutableArray alloc] init];
            for (NSString *pic in info.pic_list) {

                [imageArray addObject:pic];
                [descArray addObject:@""];
            }
            NSMutableArray *Images = [[NSMutableArray alloc] init];
            NSMutableArray *Descs = [[NSMutableArray alloc] init];
            for(int i=0;i<[imageArray count];i++)
            {
                //添加图片数组
                UIImageView *imageView = [[UIImageView alloc] init];
                NSLog(@"%@",[imageArray objectAtIndex:i]);
                [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"user"]];
                [Images addObject:imageView];
                //添加Label数组
                UILabel *label = [[UILabel alloc] init];
                label.backgroundColor = [UIColor blackColor];
                label.alpha = 0.3;
                label.text = [descArray objectAtIndex:i];
                [Descs addObject:label];
            }
            CGRect rect = [[UIScreen mainScreen] bounds];
            _adBannerView  = [[AdBannerView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 180) Delegate:self andImageViewArray:Images andNameArray:Descs];
            [self.contentView addSubview:_adBannerView];
        }else{
            [self.contentView addSubview:self.groupPrice];
            [_groupPrice autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_groupPrice autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
            [_groupPrice autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            _groupPrice.text = [NSString stringWithFormat:@"￥%@",info.now_price];
            
            [self.contentView addSubview:self.oldPrice];
//            [_oldPrice autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [_oldPrice autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_groupPrice];
            [_oldPrice autoSetDimension:ALDimensionHeight toSize:15.0f];
            //[_oldPrice autoSetDimension:ALDimensionWidth toSize:60.0f];
            [_oldPrice autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_groupPrice withOffset:5.0f];
            _oldPrice.text = [NSString stringWithFormat:@"￥%@",info.before_price];
            
            UIImageView *line = [[UIImageView alloc] initForAutoLayout];
            [line setBackgroundColor:[UIColor lightGrayColor]];
            [_oldPrice addSubview:line];
            [line autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6.5f];
            [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
            [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
            [line autoSetDimension:ALDimensionHeight toSize:1.0f];
            
            [self.contentView addSubview:self.confirmButton];
            [_confirmButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_confirmButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_confirmButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_confirmButton autoSetDimension:ALDimensionWidth toSize:130.0f];
        }
    }else if (section == 1){
        // 商家名称
        [self.contentView addSubview:self.shop_name_lable];
        [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:30.0f];
        _shop_name_lable.text = info.group_name;
#pragma mark --- 11.25 删除商家描述，商家名称改为2行文本
//        UITextView *shop_desc = [[UITextView alloc] initForAutoLayout];
//        //shop_desc.textAlignment = NSTextAlignmentCenter;
//        shop_desc.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        shop_desc.scrollEnabled = NO;
//        shop_desc.editable = NO;
//        shop_desc.textColor = UIColorFromRGB(addressTitle);
//        //shop_desc.textColor = [UIColor lightGrayColor];
//        shop_desc.font = [UIFont systemFontOfSize:13.0f];
//        shop_desc.text = info.group_brief;
//        [self.contentView addSubview:shop_desc];
//        [shop_desc autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:6.0f];
//        [shop_desc autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
//        //shop_desc.layer.borderWidth = 1;
//        [shop_desc autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name_lable withOffset:3.0f];
//        [shop_desc autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:30.0f];
//        CGFloat height = [shop_desc systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        NSLog(@"%f",height);


        UIImageView *iconImage = [[UIImageView alloc] initForAutoLayout];
        iconImage.image = [UIImage imageNamed:@"group_people"];
        [self.contentView addSubview:iconImage];
        [iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [iconImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name_lable withOffset:5.0f];
        [iconImage autoSetDimension:ALDimensionHeight toSize:12.0f];
        [iconImage autoSetDimension:ALDimensionWidth toSize:15.0f];
        
        [self.contentView addSubview:self.shop_pay_lable];
        [_shop_pay_lable autoAlignAxis:ALAxisHorizontal toSameAxisOfView:iconImage];
        [_shop_pay_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImage withOffset:3.0f];
        _shop_pay_lable.text = [NSString stringWithFormat:@"%@人购买",info.group_people];
        
        UIImageView *iconImage1 = [[UIImageView alloc] initForAutoLayout];
        iconImage1.image = [UIImage imageNamed:@"group_time"];
        [self.contentView addSubview:iconImage1];
        [iconImage1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pay_lable withOffset:10.0f];
        [iconImage1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name_lable withOffset:5.0f];
        [iconImage1 autoSetDimension:ALDimensionHeight toSize:15.0f];
        [iconImage1 autoSetDimension:ALDimensionWidth toSize:15.0f];
        
        [self.contentView addSubview:self.group_time_lable];
        [_group_time_lable autoAlignAxis:ALAxisHorizontal toSameAxisOfView:iconImage1];
        [_group_time_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImage1 withOffset:3.0f];
        _group_time_lable.text = info.end_time;
        
    }else if (section == 2){
        [self.contentView addSubview:self.scoreView];
        [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12.0f];
        [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_scoreView autoSetDimension:ALDimensionWidth toSize:80.0f];
        [self setScore:_scoreView :info.score];
        [self.contentView addSubview:self.scoreLalbe];
        [_scoreLalbe autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_scoreLalbe autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_scoreLalbe autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreView withOffset:8.0f];
        [_scoreLalbe autoSetDimension:ALDimensionWidth toSize:30.0f];
        _scoreLalbe.text = [NSString stringWithFormat:@"%@分",info.score];
        [self.contentView addSubview:self.rev_num_lable];
        [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
        [_rev_num_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreLalbe withOffset:5.0f];
        _rev_num_lable.text = [NSString stringWithFormat:@"已有%@人评价",info.review_people];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else if (section == 3){
        if (row == 0) {
            UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
            imageView.image = [UIImage imageNamed:@"shop_icon"];
            [self.contentView addSubview:imageView];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [imageView autoSetDimension:ALDimensionWidth toSize:20.0f];
            
            UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
            tmpLable.font = [UIFont systemFontOfSize:14.0f];
            tmpLable.textColor = UIColorFromRGB(0x484848);
            tmpLable.text = @"商家信息";
            [self.contentView addSubview:tmpLable];
            [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        }else if (row == 1){
            [self.contentView addSubview:self.call_phone_button];
            [_call_phone_button autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [_call_phone_button autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            [_call_phone_button autoSetDimension:ALDimensionHeight toSize:30.0f];
            [_call_phone_button autoSetDimension:ALDimensionWidth toSize:30.0f];
            
            UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
            lineImage.backgroundColor = UIColorFromRGB(0xe0e0e0);
            [self.contentView addSubview:lineImage];
            [lineImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [lineImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [lineImage autoSetDimension:ALDimensionWidth toSize:0.5f];
            [lineImage autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_call_phone_button withOffset:-10.0f];
            
            //shop message
            [self.contentView addSubview:self.shop_name_lable];
            [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
            [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_shop_name_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:lineImage withOffset:-10.0f];
            _shop_name_lable.text = info.shop_name;
            
            [self.contentView addSubview:self.shop_address_lable];
            [_shop_address_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_shop_address_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:lineImage withOffset:-5.0f];
            [_shop_address_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name_lable withOffset:5.0f];
            _shop_address_lable.text = info.shop_address;
            
        }
    }else if (section == 4){
        if (row == 0) {
            UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
            imageView.image = [UIImage imageNamed:@"city_deticon"];
            [self.contentView addSubview:imageView];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [imageView autoSetDimension:ALDimensionWidth toSize:25.0f];
            
            UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
            tmpLable.font = [UIFont systemFontOfSize:14.0f];
            tmpLable.textColor = UIColorFromRGB(0x484848);
            tmpLable.text = @"详细信息";
            [self.contentView addSubview:tmpLable];
            [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        }else if (row == 1){
//            [self.contentView addSubview:self.shop_detail_lable];
//            [_shop_detail_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
//            [_shop_detail_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
//            [_shop_detail_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
//            _shop_detail_lable.text = info.group_brief;
            [self.contentView addSubview:self.detailWeb];
            [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
            [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
            [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
            [_detailWeb  autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
            //[_detailWeb loadHTMLString:info.group_desc baseURL:nil];

            [_detailWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:info.message_url]]];
            _detailWeb.layer.borderColor = [UIColor whiteColor].CGColor;
            _detailWeb.layer.borderWidth = 1;
        }
    }
}
//---网络获取的group detail----
-(void)confirgureDetailCell :(groupDetailInfo*)info row:(NSInteger)row section:(NSInteger)section
{
    if (section == 0) {
        if (row == 0) {
            NSMutableArray *imageArray = [[NSMutableArray alloc] init];
            NSMutableArray *descArray = [[NSMutableArray alloc] init];
            for (NSString *pic in info.pic_list) {
                
                [imageArray addObject:pic];
                [descArray addObject:@""];
            }
            NSMutableArray *Images = [[NSMutableArray alloc] init];
            NSMutableArray *Descs = [[NSMutableArray alloc] init];
            for(int i=0;i<[imageArray count];i++)
            {
                //添加图片数组
                UIImageView *imageView = [[UIImageView alloc] init];
                NSLog(@"%@",[imageArray objectAtIndex:i]);
                [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"user"]];
                [Images addObject:imageView];
                //添加Label数组
                UILabel *label = [[UILabel alloc] init];
                label.backgroundColor = [UIColor blackColor];
                label.alpha = 0.3;
                label.text = [descArray objectAtIndex:i];
                [Descs addObject:label];
            }
            CGRect rect = [[UIScreen mainScreen] bounds];
            _adBannerView  = [[AdBannerView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 180) Delegate:self andImageViewArray:Images andNameArray:Descs];
            [self.contentView addSubview:_adBannerView];
        }else{
            [self.contentView addSubview:self.groupPrice];
            [_groupPrice autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_groupPrice autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
            [_groupPrice autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            _groupPrice.text = [NSString stringWithFormat:@"￥%@",info.now_price];
            
            [self.contentView addSubview:self.oldPrice];
            //[_oldPrice autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [_oldPrice autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_groupPrice];
            [_oldPrice autoSetDimension:ALDimensionHeight toSize:15.0f];
            //[_oldPrice autoSetDimension:ALDimensionWidth toSize:60.0f];
            [_oldPrice autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_groupPrice withOffset:5.0f];
            _oldPrice.text = [NSString stringWithFormat:@"￥%@",info.before_price];
            
            UIImageView *line = [[UIImageView alloc] initForAutoLayout];
            [line setBackgroundColor:[UIColor lightGrayColor]];
            [_oldPrice addSubview:line];
            [line autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6.5f];
            [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
            [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
            [line autoSetDimension:ALDimensionHeight toSize:1.0f];
            
            [self.contentView addSubview:self.confirmButton];
            [_confirmButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_confirmButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_confirmButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_confirmButton autoSetDimension:ALDimensionWidth toSize:130.0f];
        }
    }else if (section == 1){
        // 商家标题
        [self.contentView addSubview:self.shop_name_lable];
        [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:30.0f];
        _shop_name_lable.text = info.group_name;
#pragma mark --- 11.25 删除商家描述，商家名称改为2行文本
//        // 描述
//        UITextView *shop_desc = [[UITextView alloc] initForAutoLayout];
//        //shop_desc.textAlignment = NSTextAlignmentCenter;
//        shop_desc.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        shop_desc.scrollEnabled = NO;
//        shop_desc.editable = NO;
//        shop_desc.textColor = UIColorFromRGB(addressTitle);
//        //shop_desc.textColor = [UIColor lightGrayColor];
//        shop_desc.font = [UIFont systemFontOfSize:13.0f];
//        shop_desc.text = info.group_brief;
//        [self.contentView addSubview:shop_desc];
//        [shop_desc autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:6.0f];
//        [shop_desc autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
//        //shop_desc.layer.borderWidth = 1;
//        [shop_desc autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name_lable withOffset:3.0f];
//        [shop_desc autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:30.0f];
//        CGFloat height = [shop_desc systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        NSLog(@"%f",height);
        
        UIImageView *iconImage = [[UIImageView alloc] initForAutoLayout];
        iconImage.image = [UIImage imageNamed:@"group_people"];
        [self.contentView addSubview:iconImage];
        [iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [iconImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name_lable withOffset:5.0f];
        [iconImage autoSetDimension:ALDimensionHeight toSize:12.0f];
        [iconImage autoSetDimension:ALDimensionWidth toSize:15.0f];
        
        [self.contentView addSubview:self.shop_pay_lable];
        [_shop_pay_lable autoAlignAxis:ALAxisHorizontal toSameAxisOfView:iconImage];
        [_shop_pay_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImage withOffset:3.0f];
        _shop_pay_lable.text = [NSString stringWithFormat:@"%@人购买",info.group_people];
        
        UIImageView *iconImage1 = [[UIImageView alloc] initForAutoLayout];
        iconImage1.image = [UIImage imageNamed:@"group_time"];
        [self.contentView addSubview:iconImage1];
        [iconImage1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shop_pay_lable withOffset:10.0f];
        [iconImage1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name_lable withOffset:5.0f];
        [iconImage1 autoSetDimension:ALDimensionHeight toSize:15.0f];
        [iconImage1 autoSetDimension:ALDimensionWidth toSize:15.0f];
        
        [self.contentView addSubview:self.group_time_lable];
        [_group_time_lable autoAlignAxis:ALAxisHorizontal toSameAxisOfView:iconImage1];
        [_group_time_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImage1 withOffset:3.0f];
        _group_time_lable.text = info.end_time;
        
    }else if (section == 2){
        [self.contentView addSubview:self.scoreView];
        [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12.0f];
        [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_scoreView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_scoreView autoSetDimension:ALDimensionWidth toSize:80.0f];
        [self setScore:_scoreView :info.score];
        [self.contentView addSubview:self.scoreLalbe];
        [_scoreLalbe autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_scoreLalbe autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_scoreLalbe autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreView withOffset:8.0f];
        [_scoreLalbe autoSetDimension:ALDimensionWidth toSize:30.0f];
        _scoreLalbe.text = [NSString stringWithFormat:@"%@分",info.score];
        [self.contentView addSubview:self.rev_num_lable];
        [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_rev_num_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
        [_rev_num_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreLalbe withOffset:5.0f];
        _rev_num_lable.text = [NSString stringWithFormat:@"已有%@人评价",info.review_people];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else if (section == 3){
        if (row == 0) {
            UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
            imageView.image = [UIImage imageNamed:@"shop_icon"];
            [self.contentView addSubview:imageView];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [imageView autoSetDimension:ALDimensionWidth toSize:20.0f];
            
            UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
            tmpLable.font = [UIFont systemFontOfSize:14.0f];
            tmpLable.textColor = UIColorFromRGB(singleTitle);
            tmpLable.text = @"商家信息";
            [self.contentView addSubview:tmpLable];
            [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        }else if (row == 1){
            [self.contentView addSubview:self.call_phone_button];
            [_call_phone_button autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [_call_phone_button autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_call_phone_button autoSetDimension:ALDimensionHeight toSize:30.0f];
            [_call_phone_button autoSetDimension:ALDimensionWidth toSize:30.0f];
            
            UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
            lineImage.backgroundColor = UIColorFromRGB(0xe0e0e0);
            [self.contentView addSubview:lineImage];
            [lineImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [lineImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [lineImage autoSetDimension:ALDimensionWidth toSize:0.5f];
            [lineImage autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_call_phone_button withOffset:-10.0f];
            
            //shop message
            [self.contentView addSubview:self.shop_name_lable];
            [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
            [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_shop_name_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:lineImage withOffset:-5.0f];
            _shop_name_lable.text = info.shop_name;
            
            [self.contentView addSubview:self.shop_address_lable];
            [_shop_address_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_shop_address_lable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:lineImage withOffset:-5.0f];
            [_shop_address_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shop_name_lable withOffset:5.0f];
            _shop_address_lable.text = info.shop_address;
            
        }
    }else if (section == 4){
        if (row == 0) {
            UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
            imageView.image = [UIImage imageNamed:@"city_deticon"];
            [self.contentView addSubview:imageView];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [imageView autoSetDimension:ALDimensionWidth toSize:25.0f];
            
            UILabel *tmpLable = [[UILabel alloc] initForAutoLayout];
            tmpLable.font = [UIFont systemFontOfSize:14.0f];
            tmpLable.textColor = UIColorFromRGB(singleTitle);
            tmpLable.text = @"详细信息";
            [self.contentView addSubview:tmpLable];
            [tmpLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [tmpLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        }else if (row == 1){
//            [self.contentView addSubview:self.shop_detail_lable];
//            [_shop_detail_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
//            [_shop_detail_lable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
//            [_shop_detail_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
//            _shop_detail_lable.text = info.group_brief;
            [self.contentView addSubview:self.detailWeb];
            [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
            [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
            [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
            [_detailWeb  autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
            //[_detailWeb loadHTMLString:info.group_desc baseURL:nil];
            [_detailWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:info.message_url]]];
            _detailWeb.layer.borderColor = [UIColor whiteColor].CGColor;
            _detailWeb.layer.borderWidth = 1;
        }
    }
}

#pragma mark ----- UIWebView代理
- (void)webViewDidStartLoad:(UIWebView *)webView
{
#pragma mark --- 2015.12.29 加载web时显示“数据加载...”字样
    [SVProgressHUD showWithStatus:@"数据加载..." maskType:SVProgressHUDMaskTypeBlack];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.webViewHeightDelegate != nil) {
        if ([self.webViewHeightDelegate respondsToSelector:@selector(webViewDidLoad:)]) {
            CGFloat webHeight;
            webHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
            NSLog(@"加载完成，获取高度%f",webHeight);
            [self.webViewHeightDelegate webViewDidLoad:webHeight];
        } else {
            [SVProgressHUD showErrorWithStatus:@"团购-详情web页，找不到webViewDidFinishLoad:方法"];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"团购-详情web页，找不到<webViewHeightDelegate>代理"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.webViewHeightDelegate != nil) {
        if ([self.webViewHeightDelegate respondsToSelector:@selector(webViewFailLoadWithError:)]) {
            [self.webViewHeightDelegate webViewFailLoadWithError:error];
        } else {
            [SVProgressHUD showErrorWithStatus:@"订座-详情web页，找不到webViewFailLoadWithError:方法"];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"订座-详情web页，找不到<webViewHeightDelegate>代理"];
    }
}

#pragma mark-----------get UI
-(UILabel *)groupPrice
{
    if (!_groupPrice) {
        _groupPrice = [[UILabel alloc] initForAutoLayout];
        _groupPrice.font = [UIFont systemFontOfSize:17.0f];
        _groupPrice.textColor = UIColorFromRGB(0xf4353d);
        //_groupPrice.layer.borderWidth = 1;
    }
    return _groupPrice;
}

-(UILabel *)oldPrice
{
    if (!_oldPrice) {
        _oldPrice = [[UILabel alloc] initForAutoLayout];
        _oldPrice.font = [UIFont systemFontOfSize:13.0f];
        _oldPrice.textColor = UIColorFromRGB(0x8c8c8c);
        //_oldPrice.layer.borderWidth = 1;
    }
    return _oldPrice;
}

-(UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initForAutoLayout];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius = 4.0f;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_confirmButton setTitle:@"立即抢购" forState:UIControlStateNormal];
        [_confirmButton setTitle:@"立即抢购" forState:UIControlStateHighlighted];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_confirmButton setBackgroundColor:UIColorFromRGB(0xe34b52)];
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

-(UILabel *)group_name_lable
{
    if (!_group_name_lable) {
        _group_name_lable = [[UILabel alloc] initForAutoLayout];
        _group_name_lable.textColor = UIColorFromRGB(0x484848);
        _group_name_lable.font = [UIFont systemFontOfSize:14.0f];
       // _shop_name_lable.layer.borderWidth = 1;
    }
    return _group_name_lable;
}

-(UILabel *)shop_desc_lable
{
    if (!_shop_desc_lable) {
        _shop_desc_lable = [[UILabel alloc] initForAutoLayout];
        _shop_desc_lable.textColor = UIColorFromRGB(0x909090);
        _shop_desc_lable.font = [UIFont systemFontOfSize:13.0f];
        _shop_desc_lable.numberOfLines = 0;
        //_shop_desc_lable.layer.borderWidth = 1;
    }
    return _shop_desc_lable;
}

-(UILabel *)shop_pay_lable
{
    if (!_shop_pay_lable) {
        _shop_pay_lable = [[UILabel alloc] initForAutoLayout];
        _shop_pay_lable.font = [UIFont systemFontOfSize:13.0f];
        _shop_pay_lable.textColor = UIColorFromRGB(reviewTitle);
        //_shop_desc_lable.layer.borderWidth = 1;
    }
    return _shop_pay_lable;
}

-(UILabel *)group_time_lable
{
    if (!_group_time_lable) {
        _group_time_lable = [[UILabel alloc] initForAutoLayout];
        _group_time_lable.font = [UIFont systemFontOfSize:13.0f];
        _group_time_lable.textColor = UIColorFromRGB(reviewTitle);
        //_group_time_lable.layer.borderWidth = 1;
          _group_time_lable.numberOfLines = 2;
    }
    return _group_time_lable;
}

#pragma mark-----------设置星星显示
-(void)setScore:(UIView *)score :(NSString*)count
{
    //判断星星数量
    int scores = [count floatValue]*2;
    for (int n=0; n<5; n++) {
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.frame = CGRectMake(16*n, 0, 13, 13);
        NSString *starName;
        //判断每一颗星星
        if (scores>=(n+1)*2) {
            //有星星
            starName = @"home_allstar";
        }else{
            //判断没有星星 还是半颗星星
            if (scores == (n+1)*2-1) {
                //半颗星星
                starName = @"home_starhalf";
            }else{
                //没有星星
                starName = @"home_star";
            }
        }
        [imageview setImage:[UIImage imageNamed:starName]];
        [score addSubview:imageview];
    }
}

-(UIView *)scoreView
{
    if (!_scoreView) {
        _scoreView = [[UIView alloc] initForAutoLayout];
    }
    return _scoreView;
}

-(UILabel *)scoreLalbe
{
    if (!_scoreLalbe) {
        _scoreLalbe = [[UILabel alloc] initForAutoLayout];
        _scoreLalbe.font = [UIFont systemFontOfSize:13.0f];
        _scoreLalbe.textColor = UIColorFromRGB(reviewTitle);
    }
    return _scoreLalbe;
}

-(UILabel *)rev_num_lable
{
    if (!_rev_num_lable) {
        _rev_num_lable = [[UILabel alloc] initForAutoLayout];
        _rev_num_lable.font = [UIFont systemFontOfSize:13.0f];
        _rev_num_lable.textColor = UIColorFromRGB(reviewTitle);
        _rev_num_lable.textAlignment = NSTextAlignmentRight;
    }
    return _rev_num_lable;
}

-(UILabel *)shop_name_lable
{
#pragma mark --- 11.25 团购详情 - 商品标题改多行，商家名称复用此label所以可能会导致未知问题
    if (!_shop_name_lable) {
        _shop_name_lable = [[UILabel alloc] initForAutoLayout];
//        _shop_name_lable.layer.borderWidth = 1;
        _shop_name_lable.font = [UIFont systemFontOfSize:15.0f];
        _shop_name_lable.textColor = UIColorFromRGB(indexTitle);
        _shop_name_lable.numberOfLines = 2;
    }
    return _shop_name_lable;
}

-(UILabel *)shop_address_lable
{
    if (!_shop_address_lable) {
        _shop_address_lable = [[UILabel alloc] initForAutoLayout];
        _shop_address_lable.font = [UIFont systemFontOfSize:13.0f];
        _shop_address_lable.textColor = UIColorFromRGB(addressTitle);
    }
    return _shop_address_lable;
}

-(UIButton *)call_phone_button
{
    if (!_call_phone_button) {
        _call_phone_button = [[UIButton alloc] initForAutoLayout];
        [_call_phone_button setImage:[UIImage imageNamed:@"takeout_telphone"] forState:UIControlStateNormal];
        [_call_phone_button setImage:[UIImage imageNamed:@"takeout_telphone"] forState:UIControlStateHighlighted];
        [_call_phone_button addTarget:self action:@selector(callPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _call_phone_button;
}

-(UILabel *)shop_detail_lable
{
    if (!_shop_detail_lable) {
        _shop_detail_lable = [[UILabel alloc] initForAutoLayout];
        _shop_detail_lable.font = [UIFont systemFontOfSize:15.0f];
        _shop_detail_lable.textColor = [UIColor lightGrayColor];
    }
    return _shop_detail_lable;
}

-(UIWebView *)detailWeb
{
    if (!_detailWeb) {
        _detailWeb = [[UIWebView alloc] initForAutoLayout];
        //_detailWeb.userInteractionEnabled = NO;
        _detailWeb.delegate = self;
        _detailWeb.scrollView.scrollEnabled = NO;
    }
    return _detailWeb;
}

#pragma mark-------adBannerViewDelegate
-(void)adBannerView:(AdBannerView *)adBannerView itemIndex:(int)index
{
    NSLog(@"被点击的图片是第%d长",index);
    
}

-(void)confirmAction:(UIButton*)sender
{
    NSLog(@"抢购去");
    [self.delegate go2PurchaseDelegate];
}

-(void)callPhoneAction:(UIButton*)sender
{
    NSLog(@"拨打电话，号码--在哪找");
    [self.delegate callPhone];
}

@end
