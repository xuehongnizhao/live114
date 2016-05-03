//
//  locatinoInfo.h
//  CardLeap
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface locatinoInfo : NSObject
@property (strong, nonatomic) NSString *location_name;
@property (strong, nonatomic) NSString *location_lng;
@property (strong, nonatomic) NSString *location_lat;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
