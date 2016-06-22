//
//  GamePlayUsersService.h
//  DwindleDating
//
//  Created by Yunas Qazi on 4/14/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "NetworkBaseService.h"
#import "INTULocationManager.h"

@interface GamePlayUsersService : NetworkBaseService

- (void)UserInsideRadiusSucessBlock:(void (^)(bool isInRadius))successBlock
                   failure:(void (^)(NSError *error))failureBlock;

-(void) getGamePlayUsersAgainstFacebookId:(NSString*)fbId
                              sucessBlock:(void (^)(NSDictionary* allPlayers))successBlock
                                  failure:(void (^)(NSError *error))failureBlock;

-(void) getUserLocation:(void (^)(CLLocation *currentLocation))successBlock
                failure:(void (^)(NSError *error))failureBlock;

@end
