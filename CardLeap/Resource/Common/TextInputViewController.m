//
//  TextInputViewController.m
//  Orange
//
//  Created by mac on 14-1-27.
//  Copyright (c) 2014年 Youdro. All rights reserved.
//

#import "TextInputViewController.h"

@interface TextInputViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textField;

@end

@implementation TextInputViewController

@synthesize placeHolderString;
@synthesize textField;

- (void)prepareForInput
{
    [textField becomeFirstResponder];
    textField.text = placeHolderString;
}

- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{
    NSValue *keyboardRectAsObject=[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    self.textField.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
}

- (void)handleKeyboardDidHidden
{
    self.textField.contentInset=UIEdgeInsetsZero;
}

- (void)settingRightItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(settingPresetContent)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)settingPresetContent
{
    if (![self.textField.text isEqualToString:@""]) {
        
        [self.delegate doneTextInput:self.textField.text type:self.type];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"内容不能为空"];
    }
}

#pragma mark - Lifecycle

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
	   
    [self settingRightItem];
    
    if (!self.placeHolderString) {
        self.placeHolderString = @"";
    }
    
    [self prepareForInput];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [textField resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
