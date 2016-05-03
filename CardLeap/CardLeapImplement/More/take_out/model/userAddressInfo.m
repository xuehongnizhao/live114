//
//  userAddressInfo.m
//  CardLeap
//
//  Created by lin on 1/4/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "userAddressInfo.h"

@implementation userAddressInfo

@synthesize as_id = _as_id;
@synthesize u_id = _u_id;
@synthesize is_default = _is_default;
@synthesize as_address = _as_address;
@synthesize as_name = _as_name;
@synthesize as_tel = _as_tel;


-(id)initWithNSDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[userAddressInfo alloc] init];
    }
    
    _as_id = [NSString stringWithFormat:@"%@",dic[@"as_id"]];
    _u_id = [NSString stringWithFormat:@"%@",dic[@"u_id"]];
    _is_default = [NSString stringWithFormat:@"%@",dic[@"is_default"]];
    _as_address = [NSString stringWithFormat:@"%@",dic[@"as_address"]];
    _as_name = [NSString stringWithFormat:@"%@",dic[@"as_name"]];
    _as_tel = [NSString stringWithFormat:@"%@",dic[@"as_tel"]];
    
    return self;
}

@end
