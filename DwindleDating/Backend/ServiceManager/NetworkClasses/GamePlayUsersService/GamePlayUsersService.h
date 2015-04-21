//
//  GamePlayUsersService.h
//  DwindleDating
//
//  Created by Yunas Qazi on 4/14/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "NetworkBaseService.h"

@interface GamePlayUsersService : NetworkBaseService

-(void) getGamePlayUsersAgainstFacebookId:(NSString*)fbId
                              sucessBlock:(void (^)(NSDictionary* allPlayers))successBlock
                                  failure:(void (^)(NSError *error))failureBlock;

@end
