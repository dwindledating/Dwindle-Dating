//
//  DBFBService.m
//  RocketInternetTest
//
//  Created by Yunas Qazi on 2/12/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

#import "DBProductsService.h"
#import "Product.h"

@implementation DBProductsService


-(NSArray*) getProducts{
    NSArray *products = nil;
    products = [Product getAllProducts];
    return products;
}

@end
