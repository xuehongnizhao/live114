//
//  userAddressInfo.h
//  CardLeap
//
//  Created by lin on 1/4/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userAddressInfo : NSObject

@property (strong, nonatomic) NSString *as_id;
@property (strong, nonatomic) NSString *u_id;
@property (strong, nonatomic) NSString *is_default;
@property (strong, nonatomic) NSString *as_address;
@property (strong, nonatomic) NSString *as_name;
@property (strong, nonatomic) NSString *as_tel;

-(id)initWithNSDictionary:(NSDictionary*)dic;

@end
