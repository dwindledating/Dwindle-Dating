//
//  ServiceManager.h
//  RocketInternetTest
//
//  Created by Yunas Qazi on 2/12/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceManager : NSObject


-(void) getProductsWithNameOrder:(BOOL)nameOrder
                      priceOrder:(BOOL)priceOrder
                      brandOrder:(BOOL)brandOrder
                     sucessBlock:(void (^)(NSArray *productsArr))successBlock
                         failure:(void (^)(NSError *error))failureBlock;

-(void) loginWithFacebookId:(NSString*)fbId
                sucessBlock:(void (^)(BOOL isRegistered))successBlock
                    failure:(void (^)(NSError *error))failureBlock;






@end
