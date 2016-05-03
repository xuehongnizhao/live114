//
//  CardLeapDatabaseManager.m
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "CardLeapDatabaseManager.h"
#import "IQDatabaseManagerSubclass.h"
@implementation CardLeapDatabaseManager


+(NSURL*)modelURL
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CardLeap" withExtension:IQ_MODEL_EXTENSION_momd];
    
    if (modelURL == nil)    modelURL = [[NSBundle mainBundle] URLForResource:@"CardLeap" withExtension:IQ_MODEL_EXTENSION_mom];
    
    return modelURL;
}


#pragma mark - RecordTable
- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    return [self allObjectsFromTable:NSStringFromClass([Friend class]) sortDescriptor:sortDescriptor];
}

- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute where:(NSString*)key contains:(id)value
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    return [self allObjectsFromTable:NSStringFromClass([Friend class]) where:key contains:value sortDescriptor:sortDescriptor];
}

-(Friend*) insertRecordInRecordTable:(NSDictionary*)recordAttribute
{
    return (Friend*)[self insertRecordInTable:NSStringFromClass([Friend class]) withAttribute:recordAttribute];
}

- (Friend*) insertUpdateRecordInRecordTable:(NSDictionary*)recordAttribute
{
    return (Friend*)[self insertRecordInTable:NSStringFromClass([Friend class]) withAttribute:recordAttribute updateOnExistKey:kEmail equals:[recordAttribute objectForKey:kEmail]];
}

- (Friend*) updateRecord:(Friend*)record inRecordTable:(NSDictionary*)recordAttribute
{
    return (Friend*)[self updateRecord:record withAttribute:recordAttribute];
}

- (BOOL) deleteTableRecord:(Friend*)record
{
    return [self deleteRecord:record];
}

-(BOOL) deleteAllTableRecord
{
    return [self flushTable:NSStringFromClass([Friend class])];
}


@end
