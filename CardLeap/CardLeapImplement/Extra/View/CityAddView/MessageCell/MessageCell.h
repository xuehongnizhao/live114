//
//  MessageCell.h
//  CardLeap
//
//  Created by songweiping on 15/1/7.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CityAddLableMessage;
@class MessageCell;

// 协议
@protocol MessageCellDelegate <NSObject>

//Called to the delegate whenever the text in the rightTextField is changed
- (void)textFieldCell:(MessageCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath string:(NSString *)inValue;


// 可以不实现
@optional

//Called to the delegate whenever return is hit when a user is typing into the rightTextField of an ELCTextFieldCell
- (BOOL)textFieldCell:(MessageCell *)inCell shouldReturnForIndexPath:(NSIndexPath*)inIndexPath withValue:(NSString *)inValue;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;


@end


@interface MessageCell : UITableViewCell <UITextFieldDelegate>


@property (nonatomic,assign) id<MessageCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

/** 名称 */
@property (weak, nonatomic) UILabel     *messageNameView;

/** 名称分割线 */
@property (weak, nonatomic) UIImageView *messageImageView;

/** 显示描述 */
@property (weak, nonatomic) UILabel     *messageLabelView;

/** 编辑描述 */
@property (weak, nonatomic) UITextField *messageTextFieldView;

/** 价格图片 */
@property (weak, nonatomic) UILabel     *messagePriceLabelView;

/** 价格"元" */
@property (weak, nonatomic) UIImageView *messagePriceImageView;

/** 数据模型 */
@property (strong, nonatomic) CityAddLableMessage  *lableMessage;


/**
 *  创建一个 cell
 *
 *  @param tableView
 *
 *  @return cell
 */
+ (instancetype) messageAddCellWithTableView:(UITableView *)tableView;

@end
