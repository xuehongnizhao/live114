//
//  cateInfo.h
//  CardLeap
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cateInfo : NSObject
@property (strong, nonatomic) NSString *cate_name;
@property (strong, nonatomic) NSString *cate_id;
@property (strong, nonatomic) NSMutableArray *son;
-(id)initWithDictinoary :(NSDictionary*)dic;
@end
