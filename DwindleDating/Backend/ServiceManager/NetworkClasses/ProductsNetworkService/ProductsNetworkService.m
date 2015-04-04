//
//  ProductsNetworkService.m
//  RocketInternetTest
//
//  Created by Yunas Qazi on 2/12/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

#import "ProductsNetworkService.h"
#import "Product.h"

#define kBaseUrl @"https://www.zalora.com.my/mobile-api/women/clothing"

@implementation ProductsNetworkService


-(void) getProductsWithNameOrder:(BOOL)nameOrder
                      priceOrder:(BOOL)priceOrder
                      brandOrder:(BOOL)brandOrder
                     sucessBlock:(void (^)(NSArray *productsArr))successBlock
                         failure:(void (^)(NSError *error))failureBlock{

    NSDictionary *params = @{@"name":@(nameOrder), @"price":@(priceOrder), @"brand":@(brandOrder)};

    [super makeRequestWithUrl:kBaseUrl
                andParameters:params
              withRequestType:RequestType_GET
             withResponseType:ResponseType_JSON
             withHeaderValues:nil
                 withResponse:^(id response) {
        
                 //GOT PRODUCTS PARSE IT
                 NSMutableArray *productsArr = [NSMutableArray new];
                 
                     NSDictionary *responseDict = (NSDictionary*)response;
                     
                     if ([responseDict[@"success"] boolValue]) {
                         
                             NSArray *productsResponseArr = responseDict[@"metadata"][@"results"];
                             for (NSDictionary *productDict in productsResponseArr) {
                                 Product *product = [Product getProductWithoutContextWithDict:productDict];
                                 [productsArr addObject:product];
                         }
                         successBlock(productsArr);
                     }
                     
     } failure:^(NSError *error) {
         
         failureBlock (error);
     }];

    
    
}

@end
