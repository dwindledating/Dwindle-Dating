//
//  MatchesService.h
//  DwindleDating
//
//  Created by Yunas Qazi on 5/23/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "NetworkBaseService.h"

@interface MatchesService : NetworkBaseService

-(void) getMathchesForUser:(NSString*)fbId
               sucessBlock:(void (^)(NSArray *matchesArr))successBlock
                   failure:(void (^)(NSError *error))failureBlock;
@end
