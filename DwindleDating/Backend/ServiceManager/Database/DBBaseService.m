//
//  BaseService.m
//  RocketInternetTest
//
//  Created by Yunas Qazi on 2/12/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

#import "DBBaseService.h"
#import "CoreDataProvider.h"

@implementation DBBaseService

// Core Data
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}



#pragma mark singleton
- (void)saveContext{
    
    [[CoreDataProvider instance] saveContext];
}
- (NSManagedObjectContext *)managedObjectContext
{
    return [[CoreDataProvider instance] managedObjectContext];
}


- (NSManagedObjectModel *)managedObjectModel
{

    return [[CoreDataProvider instance] managedObjectModel];
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    return [[CoreDataProvider instance] persistentStoreCoordinator];
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[CoreDataProvider instance] applicationDocumentsDirectory];
}

- (void) flushDatabase{

    [[CoreDataProvider instance] flushDatabase];

}

@end
