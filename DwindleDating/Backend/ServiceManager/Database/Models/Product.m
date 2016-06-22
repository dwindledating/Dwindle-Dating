//
//  Product.m
//  RocketInternetTest
//
//  Created by Yunas Qazi on 2/12/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

#import "Product.h"
#import "CoreDataProvider.h"


@implementation Product

@dynamic name;
@dynamic imgUrlStr;
@dynamic date;
@dynamic price;
@dynamic brand;


-(void) parseProduct:(NSDictionary *)dict{
    
    
    
    [self setName:dict[@"data"][@"name"]];
    [self setPrice:dict[@"data"][@"price"]];
    [self setBrand:dict[@"data"][@"brand"]];
    NSArray *imagesArr = dict[@"images"];
    if (imagesArr.count) {
        NSDictionary* imageDict = imagesArr.lastObject;
        [self setImgUrlStr:imageDict[@"path"]];
    }
    
//    [self setDateCreated:[NSDate dateWithFormat:DATEFORMAT_FACEBOOK fromString:dict[@"created_time"]]];
    
}


+(Product*) getProductWithoutContextWithDict:(NSDictionary*)dict{

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:[[CoreDataProvider instance] managedObjectContext]];
    Product *product = (Product *)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:[[CoreDataProvider instance]managedObjectContext]];
    [product parseProduct:dict];
    [[CoreDataProvider instance] saveContext];
    return product;
}




+(NSArray*) getAllProducts{
    NSArray *feedsArr = nil;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:
                                              @"Product" inManagedObjectContext:[[CoreDataProvider instance]managedObjectContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entityDescription];
    
    NSError *error=nil;
    NSArray *array = [[[CoreDataProvider instance]managedObjectContext] executeFetchRequest:request error:&error];
    
    if ([array count]) {
        feedsArr = [NSMutableArray arrayWithArray:array];
    }
    return feedsArr;
    
}



@end
