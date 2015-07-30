//
//  GamePlayUsersService.m
//  DwindleDating
//
//  Created by Yunas Qazi on 4/14/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "GamePlayUsersService.h"

#import "Player.h"

@implementation GamePlayUsersService

-(void) getGamePlayUsersAgainstFacebookId:(NSString*)fbId
                              sucessBlock:(void (^)(NSDictionary* allPlayers))successBlock
                                  failure:(void (^)(NSError *error))failureBlock{
    

    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    INTULocationRequestID locationRequestID;
    locationRequestID = [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyHouse
                                                           timeout:10
                                              delayUntilAuthorized:YES
                                                             block:
                         ^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        if (status == INTULocationStatusSuccess) {
            // A new updated location is available in currentLocation, and achievedAccuracy indicates how accurate this particular location is
            NSString* text = [NSString stringWithFormat:@"Subscription block called with Current Location:\n%@", currentLocation];
            NSLog(@"%@",text);
            
            NSDictionary *params = @{@"fb_id":fbId,
                                     @"user_lat":@(currentLocation.coordinate.latitude),
                                     @"user_lon":@(currentLocation.coordinate.longitude)};
            
            [super makeRequestWithUrl:@"Play"
                        andParameters:params
                      withRequestType:RequestType_GET
                     withResponseType:ResponseType_JSON
                     withHeaderValues:nil
                         withResponse:^(id response) {
                             
                             //GOT PRODUCTS PARSE IT
                             
                             if ([response isKindOfClass:[NSDictionary class]]) {
                                 
                                 Player *mainPlayer = [[Player alloc]initWithDict:response[@"MainUser"]];
                                 Player *opponentPlayer = [[Player alloc]initWithDict:response[@"SecondUser"]];
                                 
                                 NSMutableArray *otherUsersArr = [NSMutableArray new];
                                 for (NSDictionary * dict in response[@"OtherUsers"]) {
                                     [otherUsersArr addObject:[[Player alloc] initWithDict:dict]];
                                 }
                                 
                                 
                                 NSDictionary *allPlayers = @{@"MainPlayer":mainPlayer,
                                                              @"OpponentPlayer":opponentPlayer,
                                                              @"Others":otherUsersArr};
                                 
                                 
                                 successBlock(allPlayers);
                             }
                             
                             
                         } failure:^(NSError *error) {
                             
                             failureBlock (error);
                         }];

            
            
            
            
            
        }
        else {
            // An error occurred, which causes the subscription to cancel automatically (this block will not execute again unless it is used to start a new subscription).
            
//            __locationRequestID = NSNotFound;
//            
            if (status == INTULocationStatusServicesNotDetermined) {
                NSLog(@"Error: User has not responded to the permissions alert.");
            } else if (status == INTULocationStatusServicesDenied) {
                NSLog(@"Error: User has denied this app permissions to access device location.");
            } else if (status == INTULocationStatusServicesRestricted) {
                NSLog(@"Error: User is restricted from using location services by a usage policy.");
            } else if (status == INTULocationStatusServicesDisabled) {
                NSLog(@"Error: Location services are turned off for all apps on this device.");
            } else {
                NSLog(@"An unknown error occurred.\n(Are you using iOS Simulator with location set to 'None'?)");
            }
        }
    }];

}


-(void) getUserLocation:(void (^)(CLLocation *currentLocation))successBlock
                failure:(void (^)(NSError *error))failureBlock{
    
    
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    INTULocationRequestID locationRequestID;
    locationRequestID = [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyHouse
                                                           timeout:10
                                              delayUntilAuthorized:YES
                                                             block:
                         ^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                             
                             if ((status == INTULocationStatusSuccess) || (status == INTULocationStatusTimedOut)) {
                                 // A new updated location is available in currentLocation, and achievedAccuracy indicates how accurate this particular location is
                                 NSString* text = [NSString stringWithFormat:@"Subscription block called with Current Location:\n%@", currentLocation];
                                 NSLog(@"%@",text);
                                 
                                 successBlock(currentLocation);
                                 
                             }
                             else {
                                 // An error occurred, which causes the subscription to cancel automatically (this block will not execute again unless it is used to start a new subscription).
                                 
                                 //            __locationRequestID = NSNotFound;
                                 //
                                 
                                 NSString *errorMsg ;
                                 if (status == INTULocationStatusServicesNotDetermined) {
                                     errorMsg = @"Error: User has not responded to the permissions alert.";
                                 } else if (status == INTULocationStatusServicesDenied) {
                                     errorMsg = @"Error: User has denied this app permissions to access device location.";
                                 } else if (status == INTULocationStatusServicesRestricted) {
                                     errorMsg = @"Error: User is restricted from using location services by a usage policy.";
                                 } else if (status == INTULocationStatusServicesDisabled) {
                                     errorMsg = @"Error: Location services are turned off for all apps on this device.";
                                 } else {
                                     errorMsg = @"An unknown error occurred.\n(Are you using iOS Simulator with location set to 'None'?)";
                                 }
                                 
                                 NSError* error = [NSError errorWithDomain:@"local" code:420 userInfo:@{@"message":errorMsg}];
                                 failureBlock(error);
                             }
                         }];
    
    
    
    
    
}
@end
