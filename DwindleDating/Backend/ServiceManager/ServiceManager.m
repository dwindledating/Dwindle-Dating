//
//  ServiceManager.m
//  RocketInternetTest
//
//  Created by Yunas Qazi on 2/12/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

#import "ServiceManager.h"
#import "ProductsNetworkService.h"
#import "DBProductsService.h"

#import "LoginNetworkService.h"
#import "SignUpNetworkService.h"
#import "GamePlayUsersService.h"



@implementation ServiceManager


-(void) loginWithFacebookId:(NSString*)fbId
                sucessBlock:(void (^)(BOOL isRegistered))successBlock
                    failure:(void (^)(NSError *error))failureBlock{
    
    
    LoginNetworkService *networkService = [LoginNetworkService new];
    [networkService loginWithFacebookId:fbId
                            sucessBlock:^(BOOL isRegistered) {
                                
                                successBlock(isRegistered);
                                
                            } failure:^(NSError *error) {
                                
                                    failureBlock(error);
                                    
                                }];
    
}


-(void) signupWithFacebookId:(NSString*)fbId
                      gender:(NSString*)gender
              requiredGender:(NSString*)reqGender
                     fromAge:(NSString*)fromAge
                       toAge:(NSString*)toAge
                    distance:(NSString*)distance
                      images:(NSArray*)images
                 sucessBlock:(void (^)(BOOL isRegistered))successBlock
                     failure:(void (^)(NSError *error))failureBlock{
    
    SignUpNetworkService *networkService = [SignUpNetworkService new];
    [networkService signupWithFacebookId:fbId
                                  gender:gender
                          requiredGender:reqGender
                                 fromAge:fromAge
                                   toAge:toAge
                                distance:distance
                                  images:images
                             sucessBlock:^(BOOL isRegistered) {
                                successBlock(isRegistered);
                             } failure:^(NSError *error) {
                                failureBlock(error);
                             }];
    
}



-(void) getGamePlayUsersAgainstFacebookId:(NSString*)fbId
                              sucessBlock:(void (^)(NSDictionary* allPlayers))successBlock
                                  failure:(void (^)(NSError *error))failureBlock{
    
    GamePlayUsersService *networkService = [GamePlayUsersService new];
    [networkService getGamePlayUsersAgainstFacebookId:fbId
                                          sucessBlock:^(NSDictionary *allPlayers) {
                                              
            successBlock(allPlayers);
                                              
    } failure:^(NSError *error) {
        
             failureBlock(error);
    }];
    
    
}

//=======================
-(void) getProductsWithNameOrder:(BOOL)nameOrder
                      priceOrder:(BOOL)priceOrder
                      brandOrder:(BOOL)brandOrder
                     sucessBlock:(void (^)(NSArray *productsArr))successBlock
                         failure:(void (^)(NSError *error))failureBlock{
    
    
    //Now first look into the database if there are feeds get them if they are not
    //get from server and save them.
    
    DBProductsService *dbService = [DBProductsService new];
    NSArray *products = [dbService getProducts];
    
    if (products.count) {
        NSLog(@"Products from LOCAL DB");
        successBlock(products);
    }
    else{
        ProductsNetworkService *networkService = [ProductsNetworkService new];
        [networkService getProductsWithNameOrder:nameOrder
                                      priceOrder:priceOrder
                                      brandOrder:brandOrder
                                     sucessBlock:^(NSArray *productsArr) {

            NSLog(@"Products from Server");
            successBlock(productsArr);
         
        } failure:^(NSError *error) {
            failureBlock(error);
            
        }];
                
    }
    
}

@end
