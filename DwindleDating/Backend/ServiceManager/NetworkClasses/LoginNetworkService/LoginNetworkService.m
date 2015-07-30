//
//  LoginNetworkService.m
//  DwindleDating
//
//  Created by Yunas Qazi on 4/3/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "LoginNetworkService.h"
#import "UserSettings.h"

@implementation LoginNetworkService

-(void) loginWithFacebookId:(NSString*)fbId
                sucessBlock:(void (^)(BOOL isRegistered))successBlock
                    failure:(void (^)(NSError *error))failureBlock{
    
    
    NSDictionary *params = @{@"fb_id":fbId};
    
    [super makeRequestWithUrl:@"login"
                andParameters:params
              withRequestType:RequestType_GET
             withResponseType:ResponseType_JSON
             withHeaderValues:nil
                 withResponse:^(id response) {
                     
                     //GOT PRODUCTS PARSE IT
                     NSDictionary *responseDict = (NSDictionary*)response;
                    BOOL isRegistered = ([responseDict[@"status"] isEqualToString:@"NotRegistered"]) ? false : true;
                     
                     if (isRegistered){
                         UserSettings *settings = [UserSettings loadUserSettings];
                         [settings setFbName:           response[@"Name"]];
                         [settings setRequiredGender:   response[@"RequiredGender"]];
                         [settings setUserAgeFrom:      [NSString stringWithFormat:@"%@",response[@"FromAge"]]];
                         [settings setUserAgeTo:        [NSString stringWithFormat:@"%@",response[@"ToAge"]]];
                         [settings setUserDistance:     [NSString stringWithFormat:@"%@",response[@"Distance"]]];
                         [settings saveUserSettings];
                     }

                     successBlock(isRegistered);
                     
                     
                 } failure:^(NSError *error) {
                     
                     failureBlock (error);
                 }];
    
//    http://52.11.98.82:3000/login?fb_id=facebookID
//    http://52.11.98.82:3000/login?fb_id=637824466345948
    
}

@end
