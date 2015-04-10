//
//  SignUpNetworkService.h
//  DwindleDating
//
//  Created by Yunas Qazi on 4/7/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "NetworkBaseService.h"

@interface SignUpNetworkService : NetworkBaseService

-(void) signupWithFacebookId:(NSString*)fbId
                      gender:(NSString*)gender
              requiredGender:(NSString*)reqGender
                     fromAge:(NSString*)fromAge
                       toAge:(NSString*)toAge
                    distance:(NSString*)distance
                      images:(NSArray*)imagesArr
                 sucessBlock:(void (^)(BOOL isRegistered))successBlock
                     failure:(void (^)(NSError *error))failureBlock;

@end
