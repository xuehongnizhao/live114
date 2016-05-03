//
//  littleCateModel.h
//  CardLeap
//
//  Created by lin on 12/10/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface littleCateModel : NSObject
@property (strong, nonatomic) NSString *cat_img;
@property (strong, nonatomic) NSString *cat_name;
@property (strong, nonatomic) NSString *cat_id;
-(id)initWithDictionary :(NSDictionary*)dic;
@end
