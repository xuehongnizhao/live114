//
//  locatinoInfo.m
//  CardLeap
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "locatinoInfo.h"

@implementation locatinoInfo
-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[locatinoInfo alloc] init];
    }
    self.location_name = dic[@"location_name"];
    self.location_lat = dic[@"locatino_lat"];
    self.location_lng = dic[@"location_lng"];
    return self;
}
@end
