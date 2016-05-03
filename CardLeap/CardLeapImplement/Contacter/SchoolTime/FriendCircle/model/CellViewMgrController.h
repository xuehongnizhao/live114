//
//  ImageViewMgrController.h
//  EnjoyDQ
//
//  Created by lin on 14-9-3.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActionDeletedelegate <NSObject>
@optional
-(void)deleteAction :(int)index;
@end

@interface CellViewMgrController : NSObject<UIAlertViewDelegate>
@property (nonatomic, assign) id<ActionDeletedelegate> delegate;
@property (strong, nonatomic) NSMutableArray *heightsOfCells;//cell的高度
@property (strong, nonatomic) NSMutableArray *textHeights;//帖子正文的高度
@property (strong, nonatomic) NSMutableArray *comPicHeights;//图片的高度
@property (strong, nonatomic) NSMutableArray *reviewListHeights;//回复列表的高度
@property (strong, nonatomic) NSString *identifer;
-(id)initWithDictionary :(NSArray*)array;
-(UIView*)ImageLayout :(int)indexPath;
@end
