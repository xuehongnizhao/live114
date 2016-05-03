//
//  Group.h
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Group : NSManagedObject

@property (nonatomic, retain) NSNumber * clientID;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSNumber * serverID;
@property (nonatomic, retain) NSNumber * userID;

@end
