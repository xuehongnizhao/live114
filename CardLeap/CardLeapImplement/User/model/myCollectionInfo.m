//
//  myCollectionInfo.m
//  CardLeap
//
//  Created by mac on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myCollectionInfo.h"

@implementation myCollectionInfo
@synthesize shop_action,rev_people,shop_id,shop_address,shop_name,shop_pic,score,shop_cate;
-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[myCollectionInfo alloc] init];
    }
    self.shop_action = [NSString stringWithFormat:@"%@",dic[@"shop_action"]];
    self.rev_people = [NSString stringWithFormat:@"%@",dic[@"rev_people"]];
    self.shop_id = [NSString stringWithFormat:@"%@",dic[@"shop_id"]];
    self.shop_address = [NSString stringWithFormat:@"%@",dic[@"shop_address"]];
    self.shop_name = [NSString stringWithFormat:@"%@",dic[@"shop_name"]];
    self.shop_pic = [NSString stringWithFormat:@"%@",dic[@"shop_pic"]];
    self.score = [NSString stringWithFormat:@"%@",dic[@"score"]];
    self.shop_cate = [NSString stringWithFormat:@"%@",dic[@"cat_name"]];
    return self;
}
@end
