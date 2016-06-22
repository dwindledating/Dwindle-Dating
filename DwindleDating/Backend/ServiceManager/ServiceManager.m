//
//  ServiceManager.m
//  RocketInternetTest
//
//  Created by Yunas Qazi on 2/12/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

#import "ServiceManager.h"
//#import "ProductsNetworkService.h"
#import "DBProductsService.h"

#import "LoginNetworkService.h"
#import "SignUpNetworkService.h"

#import "PicturesService.h"
#import "UserSettingsService.h"

#import "MatchesService.h"


@implementation ServiceManager

- (void)userInsideRadiusSucessBlock:(void (^)(bool isInRadius))successBlock
                   failure:(void (^)(NSError *error))failureBlock {
    
    GamePlayUsersService *networkService = [GamePlayUsersService new];
    [networkService UserInsideRadiusSucessBlock:^(bool isInRadius) {

        successBlock(isInRadius);
        
    } failure:^(NSError *error) {
        
        failureBlock(error);
        
    }];
}

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
                    fullName:(NSString*)fullName
                         dob:(NSString*)dob
                      gender:(NSString*)gender
              requiredGender:(NSString*)reqGender
                     fromAge:(NSString*)fromAge
                       toAge:(NSString*)toAge
                    distance:(NSString*)distance
                      images:(NSArray*)imagesArr
                 sucessBlock:(void (^)(BOOL isRegistered))successBlock
                     failure:(void (^)(NSError *error))failureBlock{

    SignUpNetworkService *networkService = [SignUpNetworkService new];
    
    [networkService signupWithFacebookId:fbId
                                fullName:fullName
                                     dob:dob
                                  gender:gender
                          requiredGender:reqGender
                                 fromAge:fromAge
                                   toAge:toAge
                                distance:distance
                                  images:imagesArr
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

-(void) getUserLocation:(void (^)(CLLocation *currentLocation))successBlock
                failure:(void (^)(NSError *error))failureBlock{
    
    
    GamePlayUsersService *networkService = [GamePlayUsersService new];
    [networkService getUserLocation:^(CLLocation *currentLocation) {
        //code
        successBlock(currentLocation);
    } failure:^(NSError *error) {
        //code
        failureBlock(error);
    }];
}



-(void) getUserPicturesAgainstFacebookId:(NSString*)fbId
                             sucessBlock:(void (^)(NSDictionary* pictures))successBlock
                                 failure:(void (^)(NSError *error))failureBlock{
    
    PicturesService *networkService = [PicturesService new];
    [networkService getUserPicturesAgainstFacebookId:fbId
                                         sucessBlock:^(NSDictionary *pictures) {
        
        successBlock(pictures);

    } failure:^(NSError *error) {
    
        failureBlock(error);
        
    }];
    
    
}


-(void) updateUserPictureAgainstFacebookId:(NSString*)fbId
                            andPictureName:(NSString*)picName
                                 withImage:(NSArray*)imagesArr
                               sucessBlock:(void (^)(BOOL isUpdated))successBlock
                                   failure:(void (^)(NSError *error))failureBlock{
 
    
    PicturesService *networkService = [PicturesService new];
    [networkService updateUserPictureAgainstFacebookId:fbId
                                        andPictureName:picName
                                             withImage:imagesArr
                                           sucessBlock:^(BOOL isUpdated) {
                                             successBlock(isUpdated);
    } failure:^(NSError *error) {
                                             failureBlock(error);
    }];

    
}


-(void) editDistance:(NSNumber*)distance
   againstFacebookId:(NSString*)fbId
         sucessBlock:(void (^)(BOOL isUpdated))successBlock
             failure:(void (^)(NSError *error))failureBlock{

    
    UserSettingsService *networkService = [UserSettingsService new];
    [networkService editDistance:distance
               againstFacebookId:fbId sucessBlock:^(BOOL isUpdated) {
                   
                   successBlock(isUpdated);
                   
               } failure:^(NSError *error) {
                   failureBlock(error);
               }];
    
}

-(void) editAgeFromRange:(NSNumber*)ageFrom
              andToRange:(NSNumber*)ageTo
       againstFacebookId:(NSString*)fbId
             sucessBlock:(void (^)(bool isUpdated))successBlock
                 failure:(void (^)(NSError *error))failureBlock{
    
    UserSettingsService *networkService = [UserSettingsService new];
    [networkService editAgeFromRange:ageFrom
                          andToRange:ageTo
                   againstFacebookId:fbId
                         sucessBlock:^(bool isUpdated) {
                             successBlock(isUpdated);
                         } failure:^(NSError *error) {
                             failureBlock(error);
                         }];
    
}



-(void) editRequiredGender:(NSString*)gender
         againstFacebookId:(NSString*)fbId
               sucessBlock:(void (^)(bool isUpdated))successBlock
                   failure:(void (^)(NSError *error))failureBlock{

    UserSettingsService *networkService = [UserSettingsService new];
    [networkService editRequiredGender:gender
                   againstFacebookId:fbId
                         sucessBlock:^(bool isUpdated) {
                             successBlock(isUpdated);
                         } failure:^(NSError *error) {
                             failureBlock(error);
                         }];

    
}


-(void) getMathchesForUser:(NSString*)fbId
               sucessBlock:(void (^)(NSArray *matchesArr))successBlock
                   failure:(void (^)(NSError *error))failureBlock{
    
    
    MatchesService *mateches =  [MatchesService new];
    [mateches getMathchesForUser:fbId sucessBlock:^(NSArray *matchesArr) {
        successBlock (matchesArr);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
    
}

//
////=======================
//-(void) getProductsWithNameOrder:(BOOL)nameOrder
//                      priceOrder:(BOOL)priceOrder
//                      brandOrder:(BOOL)brandOrder
//                     sucessBlock:(void (^)(NSArray *productsArr))successBlock
//                         failure:(void (^)(NSError *error))failureBlock{
//    
//    
//    //Now first look into the database if there are feeds get them if they are not
//    //get from server and save them.
//    
//    DBProductsService *dbService = [DBProductsService new];
//    NSArray *products = [dbService getProducts];
//    
//    if (products.count) {
//        NSLog(@"Products from LOCAL DB");
//        successBlock(products);
//    }
//    else{
//        ProductsNetworkService *networkService = [ProductsNetworkService new];
//        [networkService getProductsWithNameOrder:nameOrder
//                                      priceOrder:priceOrder
//                                      brandOrder:brandOrder
//                                     sucessBlock:^(NSArray *productsArr) {
//
//            NSLog(@"Products from Server");
//            successBlock(productsArr);
//         
//        } failure:^(NSError *error) {
//            failureBlock(error);
//            
//        }];
//                
//    }
//    
//}

@end
