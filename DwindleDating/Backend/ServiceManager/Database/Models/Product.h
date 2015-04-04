//
//  Product.h
//  RocketInternetTest
//
//  Created by Yunas Qazi on 2/12/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DBBaseService.h"



@interface Product : DBBaseService

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imgUrlStr;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * brand;

+(Product*) getProductWithoutContextWithDict:(NSDictionary*)dict;
+(NSArray*) getAllProducts;



@end
