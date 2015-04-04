//
//  LoginNetworkService.h
//  DwindleDating
//
//  Created by Yunas Qazi on 4/3/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "NetworkBaseService.h"

@interface LoginNetworkService : NetworkBaseService

-(void) loginWithFacebookId:(NSString*)fbId
                sucessBlock:(void (^)(BOOL isRegistered))successBlock
                    failure:(void (^)(NSError *error))failureBlock;


@end
