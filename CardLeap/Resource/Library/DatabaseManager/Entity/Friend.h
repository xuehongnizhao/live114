//
//  Friend.h
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend : NSManagedObject

@property (nonatomic, retain) id address;
@property (nonatomic, retain) NSNumber * addressBookID;
@property (nonatomic, retain) NSNumber * attachmentCount;
@property (nonatomic, retain) NSNumber * clientID;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) id companyAddress;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSNumber * goupID;
@property (nonatomic, retain) NSNumber * hasDeleted;
@property (nonatomic, retain) NSString * headPicPath;
@property (nonatomic, retain) NSNumber * isUpdate;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSString * mainPhone;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * pictureCount;
@property (nonatomic, retain) NSNumber * serverFID;
@property (nonatomic, retain) NSNumber * serverID;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSNumber * videoCount;

@end
