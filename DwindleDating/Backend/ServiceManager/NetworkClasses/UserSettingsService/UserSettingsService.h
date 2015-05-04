//
//  UserSettingsService.h
//  DwindleDating
//
//  Created by Yunas Qazi on 4/29/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "NetworkBaseService.h"

@interface UserSettingsService : NetworkBaseService


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

@end
