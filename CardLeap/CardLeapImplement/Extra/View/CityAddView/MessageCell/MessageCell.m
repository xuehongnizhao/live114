//
//  MessageCell.m
//  CardLeap
//
//  Created by songweiping on 15/1/7.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "MessageCell.h"
#import "CityAddLableMessage.h"


#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size];
#define padding 10

@interface MessageCell()


@end

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self addUI];
    }
    return self;
}

+ (instancetype) messageAddCellWithTableView:(UITableView *)tableView {
    
    static NSString *cellName = @"messageCell";

    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    if (cell.indexPath.section  == 2) {
        
        
    }
    
    // cell 点击样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


/**
 *  添加控件
 */
- (void) addUI {
    
    UILabel *messageNameView      = [[UILabel alloc] init];
    messageNameView.font          = SYSTEM_FONT_SIZE(15);
    messageNameView.textAlignment = NSTextAlignmentCenter;
    messageNameView.textColor     = Color(134, 134, 134, 255);
    _messageNameView              = messageNameView;
    [self.contentView addSubview:_messageNameView];
    
    UIImageView *messageImageView = [[UIImageView alloc] init];
    messageImageView.image  = [UIImage imageNamed:@"city_release_velrine"];
    _messageImageView       = messageImageView;
    [self.contentView addSubview:_messageImageView];
    
    UILabel *messageLabelView = [[UILabel alloc] init];
    _messageLabelView = messageLabelView;
    [self.contentView addSubview:_messageLabelView];
    
    UITextField *messageTextFieldView = [[UITextField alloc] init];
    messageTextFieldView.delegate     = self;
    
    // 监听
    [messageTextFieldView addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    _messageTextFieldView             = messageTextFieldView;
    
    [self.contentView addSubview:_messageTextFieldView];
    
    
    UILabel *messagePriceLabelView = [[UILabel alloc] init];
    messagePriceLabelView.textAlignment = NSTextAlignmentCenter;
    _messagePriceLabelView         = messagePriceLabelView;
    [self.contentView addSubview:_messagePriceLabelView];
    
    UIImageView *messagePriceImageView = [[UIImageView alloc] init];
    _messagePriceImageView             = messagePriceImageView;
    [self.contentView addSubview:_messagePriceImageView];
}


- (void)setLableMessage:(CityAddLableMessage *)lableMessage {
    
    _lableMessage = lableMessage;
    
    // 设置数据
    [self settingData];
    
    // 计算frame
    [self settingFrame];
}


- (void)settingData {
    self.messageNameView.text = self.lableMessage.name;
    
    
//    if (!self.lableMessage.isDisplayLable) {
//        self.messageTextFieldView.text = self.lableMessage.title;
//    } else {
//        self.messageLabelView.text = self.lableMessage.title;
//    }
    
    if (self.lableMessage.cate && self.lableMessage.title == nil) {
        self.messageLabelView.text     = self.lableMessage.cate;
    } else {
        self.messageTextFieldView.text = self.lableMessage.title;
    }
    
    // 有价格
    if (self.lableMessage.isDisplayPriceImageView && self.lableMessage.isDisplayPriceTextView) {
        self.messagePriceImageView.image = [UIImage imageNamed:@"city_release_horilzline"];
        self.messagePriceLabelView.text  = @"元";
        // 数字 键盘
        self.messageTextFieldView.keyboardType = UIKeyboardTypeNumberPad;
    }
    
}

- (void) settingFrame {
    CGFloat nameX = padding;
    CGFloat nameY = padding;
    CGFloat nameW = 50;
    CGFloat nameH = self.frame.size.height - padding;
    self.messageNameView.frame = CGRectMake(nameX, nameY, nameW, nameH);
    
    
    // 分割线
    CGFloat imageX = CGRectGetMaxX(self.messageNameView.frame) + padding / 2;
    CGFloat imageY = padding;
    CGFloat imageW = 1;
    CGFloat imageH = CGRectGetMaxY(self.messageNameView.frame) - padding;
    self.messageImageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    
    // LabelView
    CGFloat lfX = CGRectGetMaxX(self.messageImageView.frame) + padding;
    CGFloat lfY = padding;
    CGFloat lfW = 0;
    CGFloat lfH = self.frame.size.height - padding;
    if (self.lableMessage.isDisplayPriceImageView) {
        lfW = 100;
        lfH = self.frame.size.height - padding * 2;
        
    } else {
        lfW = self.frame.size.width - CGRectGetMinX(self.messageImageView.frame) - 40;
    }
    if (self.messageLabelView.text) {
        // 显示TextFieldView
        self.messageLabelView.frame = CGRectMake(lfX, lfY, lfW, lfH);
        
    } else {
        // 显示 LabelView
        self.messageTextFieldView.frame = CGRectMake(lfX, lfY, lfW, lfH);
    }
    
    // 显示价格的图片 和 文字
    if (self.lableMessage.isDisplayPriceImageView && self.lableMessage.isDisplayPriceTextView) {
        
        CGFloat pImageX = lfX;
        CGFloat pImageY = CGRectGetMaxY(self.messageTextFieldView.frame) + padding / 3;
        CGFloat pImageW = lfW;
        CGFloat pImageH = 1;
        self.messagePriceImageView.frame = CGRectMake(pImageX, pImageY, pImageW, pImageH);
        
        CGFloat pLabelX = CGRectGetMaxX(self.messageTextFieldView.frame) +padding / 4;
        CGFloat pLabelY = lfY;
        CGFloat pLabelW = 40;
        CGFloat pLabelH = lfH;

        self.messagePriceLabelView.frame = CGRectMake(pLabelX, pLabelY, pLabelW, pLabelH);
    }
}



#pragma mark - textfieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *textString = self.messageTextFieldView.text;
//    //textString = [textString stringByReplacingCharactersInRange:range withString:string];
//    if([_delegate respondsToSelector:@selector(textFieldCell:updateTextLabelAtIndexPath:string:)]) {
//        [_delegate textFieldCell:self updateTextLabelAtIndexPath:_indexPath string:textString];
//    }
//    return YES;
//}
//

- (void)textFieldEditChanged:(UITextField *)textField
{
    NSString* textString=textField.text;
    
    if([_delegate respondsToSelector:@selector(textFieldCell:updateTextLabelAtIndexPath:string:)]) {
        [_delegate textFieldCell:self updateTextLabelAtIndexPath:_indexPath string:textString];
    }
    
}


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if([_delegate respondsToSelector:@selector(textFieldCell:updateTextLabelAtIndexPath:string:)]) {
        [_delegate textFieldCell:self updateTextLabelAtIndexPath:_indexPath string:nil];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [_delegate textFieldShouldBeginEditing:(UITextField *)textField];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if([_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [_delegate textFieldShouldEndEditing:(UITextField *)textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        return [_delegate textFieldDidBeginEditing:(UITextField *)textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_delegate textFieldDidEndEditing:(UITextField*)textField];
    }
}

@end
