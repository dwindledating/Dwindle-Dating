//
//  ServiceManager.h
//  RocketInternetTest
//
//  Created by Yunas Qazi on 2/12/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamePlayUsersService.h"

@interface ServiceManager : NSObject


- (void)userInsideRadiusSucessBlock:(void (^)(bool isInRadius))successBlock
                   failure:(void (^)(NSError *error))failureBlock;

//-(void) getProductsWithNameOrder:(BOOL)nameOrder
//                      priceOrder:(BOOL)priceOrder
//                      brandOrder:(BOOL)brandOrder
//                     sucessBlock:(void (^)(NSArray *productsArr))successBlock
//                         failure:(void (^)(NSError *error))failureBlock;

-(void) loginWithFacebookId:(NSString*)fbId
                sucessBlock:(void (^)(BOOL isRegistered))successBlock
                    failure:(void (^)(NSError *error))failureBlock;



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
                     failure:(void (^)(NSError *error))failureBlock;

-(void) getGamePlayUsersAgainstFacebookId:(NSString*)fbId
                              sucessBlock:(void (^)(NSDictionary* allPlayers))successBlock
                                  failure:(void (^)(NSError *error))failureBlock;

-(void) getUserLocation:(void (^)(CLLocation *currentLocation))successBlock
                failure:(void (^)(NSError *error))failureBlock;

-(void) getUserPicturesAgainstFacebookId:(NSString*)fbId
                             sucessBlock:(void (^)(NSDictionary* pictures))successBlock
                                 failure:(void (^)(NSError *error))failureBlock;

-(void) updateUserPictureAgainstFacebookId:(NSString*)fbId
                            andPictureName:(NSString*)picName
                                 withImage:(NSArray*)imagesArr
                               sucessBlock:(void (^)(BOOL isUpdated))successBlock
                                   failure:(void (^)(NSError *error))failureBlock;

-(void) editDistance:(NSNumber*)distance
   againstFacebookId:(NSString*)fbId
         sucessBlock:(void (^)(BOOL isUpdated))successBlock
             failure:(void (^)(NSError *error))failureBlock;


-(void) editAgeFromRange:(NSNumber*)ageFrom
              andToRange:(NSNumber*)ageTo
       againstFacebookId:(NSString*)fbId
             sucessBlock:(void (^)(bool isUpdated))successBlock
                 failure:(void (^)(NSError *error))failureBlock;

-(void) editRequiredGender:(NSString*)gender
         againstFacebookId:(NSString*)fbId
               sucessBlock:(void (^)(bool isUpdated))successBlock
                   failure:(void (^)(NSError *error))failureBlock;

-(void) getMathchesForUser:(NSString*)fbId
               sucessBlock:(void (^)(NSArray *matchesArr))successBlock
                   failure:(void (^)(NSError *error))failureBlock;

@end