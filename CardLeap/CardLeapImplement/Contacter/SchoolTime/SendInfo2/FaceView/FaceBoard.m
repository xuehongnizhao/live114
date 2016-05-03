//
//  FaceBoard.m
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import "FaceBoard.h"


#define FACE_COUNT_ALL  102

#define FACE_COUNT_ROW  4

#define FACE_COUNT_CLU  7

#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )

#define FACE_ICON_SIZE  32




@implementation FaceBoard

@synthesize delegate;

@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;
@synthesize send ;
- (id)init {
     CGFloat my_height = SCREEN_HEIGHT-64-216*LinHeightPercent;
    self = [super initWithFrame:CGRectMake(0, my_height, 320*LinPercent, 216*LinHeightPercent)];
    if (self) {

        self.isShow=NO;
        self.inputTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320*LinPercent, 200)];
        self.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1];
//        NSLog(@"path=%@",[[NSBundle mainBundle] pathForResource:@"YBInput" ofType:@"bundle"]);
//        NSString* bundlePath=[[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"];
//        NSBundle* bundle=[NSBundle bundleWithPath:bundlePath];
//            _faceMap = [[NSDictionary dictionaryWithContentsOfFile:
//                         [bundle pathForResource:@"face_map"
//                                                         ofType:@"plist"]] retain];
        _faceMap=[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"]] retain];
      //  NSLog(@"facemAP:%@",_faceMap);

        [[NSUserDefaults standardUserDefaults] setObject:_faceMap forKey:@"FaceMap"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320*LinPercent, 190*LinHeightPercent)];
        faceView.pagingEnabled = YES;
//        faceView.layer.borderWidth = 1;
        faceView.contentSize = CGSizeMake((FACE_COUNT_ALL / FACE_COUNT_PAGE + 1) * 320*LinPercent, 190*LinHeightPercent);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        for (int i = 1; i <= FACE_COUNT_ALL; i++) {
            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            //计算每一个表情按钮的坐标和在哪一屏
            CGFloat x = (((i - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU) *
            (FACE_ICON_SIZE*LinPercent + 10) +20+ ((i - 1) / FACE_COUNT_PAGE * 320*LinPercent);
            //NSLog(@"facbutton.x=%f",x);
            CGFloat y = (((i - 1) % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * (FACE_ICON_SIZE*LinPercent + 8)+20;
            //NSLog(@"facbuuton.y=%f",y);
            faceButton.frame = CGRectMake( x, y, FACE_ICON_SIZE*LinPercent, FACE_ICON_SIZE*LinPercent);
            faceButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            NSString* imagePath=[NSString stringWithFormat:@"Expression_%d.png",i];
            [faceButton setImage:[UIImage imageNamed:imagePath]
                        forState:UIControlStateNormal];
            //NSLog(@"str:%@",[NSString stringWithFormat:@"%03d",i]);

            [faceView addSubview:faceButton];
        }
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(110*LinPercent, 190*LinHeightPercent, 100, 20)];
//        facePageControl.layer.borderWidth = 1;
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = FACE_COUNT_ALL / FACE_COUNT_PAGE + 1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
        //删除键
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"删除" forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"del_emoji_normal"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"del_emoji_select"] forState:UIControlStateSelected];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(272*LinPercent, 182*LinPercent, 38, 28);
        [self addSubview:back];
    }

    return self;
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [facePageControl setCurrentPage:faceView.contentOffset.x / 320];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {

    [faceView setContentOffset:CGPointMake(facePageControl.currentPage * 320*LinPercent, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {

    int i = (int)((FaceButton*)sender).buttonIndex;
    if (self.inputTextField)
    {
        NSLog(@"点击表情");
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
//        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"%03d", i]]];
        faceString =[_faceMap objectForKey:[NSString stringWithFormat:@"%03d",i]];
        NSLog(@"faceString:%@",faceString);
                self.inputTextField.text = faceString;
        [faceString release];
        [delegate textFieldDidChange:self.inputTextField];
    }

    if (self.inputTextView)
    {

        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
//        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"%03d", i]]];
       // faceString =[_faceMap objectForKey:[NSString stringWithFormat:@"%03d",i]];
        NSLog(@"i=%d",i);
        for (NSString* key in[_faceMap allKeys])
        {
            
            if ([[_faceMap objectForKey:key] isEqualToString:[NSString stringWithFormat:@"Expression_%d@2x.png",i]])
            {
                faceString=[NSMutableString stringWithFormat:@"%@",key];
            }
        }
       // faceString=[arr objectAtIndex:i];
        NSLog(@"faceString:%@",faceString);

        if ([self.send isEqualToString:@"1"])
        {
            faceString = [NSString stringWithFormat:@"%@%@",self.inputTextView.text,faceString];
            self.inputTextView.text = faceString;
            [delegate faceBoardTextViewDidChange:self.inputTextView andDelete:NO];
        }
        else
        {
            //发布
            //faceString =[_faceMap objectForKey:[NSString stringWithFormat:@"%03d",i]];
            NSLog(@"faceString:%@",faceString);
            self.inputTextView.text = faceString;
            [delegate faceBoardTextViewDidChange:self.inputTextView andDelete:NO];
        }
    }
}
//删除表情
- (void)backFace{

    NSString *inputString;
    inputString = self.inputTextField.text;
    if ( self.inputTextView ) {
        if ([self.send isEqualToString:@"1"]) {
            //
        }else{
            [delegate faceBoardTextViewDidChange:self.inputTextView andDelete:YES];
        }
        inputString = self.inputTextView.text;
    }
    NSLog(@"删除之前的Str:%@",inputString);
    if ( inputString.length ) {
        
        NSString *string = nil;
        NSInteger stringLength = inputString.length;
        if ( stringLength >= FACE_NAME_LEN ) {
            
            string = [inputString substringFromIndex:stringLength - FACE_NAME_LEN];
            NSRange range = [string rangeOfString:FACE_NAME_HEAD];
            if ( range.location == 0 ) {
                
                string = [inputString substringToIndex:
                          [inputString rangeOfString:FACE_NAME_HEAD
                                             options:NSBackwardsSearch].location];
            }
            else {
                
                string = [inputString substringToIndex:stringLength - 1];
            }
        }
        else {
            
            string = [inputString substringToIndex:stringLength - 1];
        }
        
        if ( self.inputTextField ) {
            
            self.inputTextField.text = string;
            [delegate textFieldDidChange:self.inputTextField];
        }
        
        if ( self.inputTextView ) {
            
            NSLog(@"删除之后的Str:%@",string);
            self.inputTextView.text = string;
            [delegate faceBoardDeleteFinsish:self.inputTextView];
            //[delegate faceBoardTextViewDidChange:self.inputTextView andDelete:YES];
        }
    }
}

- (void)dealloc {
    
    [_faceMap release];
    [_inputTextField release];
    [_inputTextView release];
    [faceView release];
    [facePageControl release];
    
    [super dealloc];
}

@end
