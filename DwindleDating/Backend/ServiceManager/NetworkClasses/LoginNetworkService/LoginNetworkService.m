//
//  LoginNetworkService.m
//  DwindleDating
//
//  Created by Yunas Qazi on 4/3/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "LoginNetworkService.h"

@implementation LoginNetworkService

-(void) loginWithFacebookId:(NSString*)fbId
                sucessBlock:(void (^)(BOOL isRegistered))successBlock
                    failure:(void (^)(NSError *error))failureBlock{
    
    
    NSDictionary *params = @{@"":fbId};
    
    [super makeRequestWithUrl:nil
                andParameters:nil
              withRequestType:RequestType_GET
             withResponseType:ResponseType_JSON
             withHeaderValues:nil
                 withResponse:^(id response) {
                     
                     //GOT PRODUCTS PARSE IT
                     NSDictionary *responseDict = (NSDictionary*)response;
                    BOOL isRegistered = ([responseDict[@"status"] isEqualToString:@"NotRegistered"]) ? false : true;
                     successBlock(isRegistered);
                     
                 } failure:^(NSError *error) {
                     
                     failureBlock (error);
                 }];
    

}

@end
