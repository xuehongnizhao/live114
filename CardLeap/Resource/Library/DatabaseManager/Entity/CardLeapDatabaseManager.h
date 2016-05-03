//
//  CardLeapDatabaseManager.h
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "IQDatabaseManager.h"
#import "CardLeapDatabaseConstants.h"

@interface CardLeapDatabaseManager : IQDatabaseManager

- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute;
- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute where:(NSString*)key contains:(id)value;

- (Friend*) insertRecordInRecordTable:(NSDictionary*)recordAttributes;
- (Friend*) insertUpdateRecordInRecordTable:(NSDictionary*)recordAttributes;
- (Friend*) updateRecord:(Friend*)record inRecordTable:(NSDictionary*)recordAttributes;
- (BOOL) deleteTableRecord:(Friend*)record;


- (BOOL) deleteAllTableRecord;

//- (Settings*) settings;
//- (Settings*) saveSettings:(NSDictionary*)settings;


@end
