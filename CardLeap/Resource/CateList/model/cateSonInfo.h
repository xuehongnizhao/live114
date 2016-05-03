//
//  cateSonInfo.h
//  CardLeap
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cateSonInfo : NSObject
@property (strong, nonatomic) NSString *cate_son_name;
@property (strong, nonatomic) NSString *cate_son_id;
-(id)initWithDictionary :(NSDictionary*)dic;
@end
