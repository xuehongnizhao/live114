//
//  slideModel.h
//  CardLeap
//
//  Created by lin on 12/10/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface slideModel : NSObject
@property (strong, nonatomic) NSString *top_id;
@property (strong, nonatomic) NSString *top_pic;
@property (strong, nonatomic) NSString *top_desc;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *shop_id;
-(id)initWithDictionary :(NSDictionary*)dic;
@end
