//
//  UserSettingsService.m
//  DwindleDating
//
//  Created by Yunas Qazi on 4/29/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "UserSettingsService.h"

@implementation UserSettingsService


-(void) editDistance:(NSNumber*)distance
   againstFacebookId:(NSString*)fbId
         sucessBlock:(void (^)(bool isUpdated))successBlock
             failure:(void (^)(NSError *error))failureBlock{
    
    NSDictionary *params = @{@"fb_id":fbId, @"distance":distance};
    
    [super makeRequestWithUrl:@"ChangeDistanceRadius"
                andParameters:params
              withRequestType:RequestType_GET
             withResponseType:ResponseType_JSON
             withHeaderValues:nil
                 withResponse:^(id response) {

                     NSDictionary *responseDict = (NSDictionary*)response;
                     
                     BOOL isUpdated = ([responseDict[@"status"] isEqualToString:@"Record Updated"]) ? true : false;
                     successBlock(isUpdated);
                     
                 } failure:^(NSError *error) {
                     
                     failureBlock (error);
                 }];

}


-(void) editAgeFromRange:(NSNumber*)ageFrom
              andToRange:(NSNumber*)ageTo
       againstFacebookId:(NSString*)fbId
             sucessBlock:(void (^)(bool isUpdated))successBlock
                 failure:(void (^)(NSError *error))failureBlock{
    
    
    NSDictionary *params = @{@"fb_id":fbId, @"req_from_age":ageFrom, @"req_to_age":ageTo};
    
    [super makeRequestWithUrl:@"ChangeAgeLimit"
                andParameters:params
              withRequestType:RequestType_GET
             withResponseType:ResponseType_JSON
             withHeaderValues:nil
                 withResponse:^(id response) {
                     
                     NSDictionary *responseDict = (NSDictionary*)response;
                     
                     BOOL isUpdated = ([responseDict[@"status"] isEqualToString:@"Record Updated"]) ? true : false;
                     successBlock(isUpdated);
                     
                 } failure:^(NSError *error) {
                     
                     failureBlock (error);
                 }];

    
}


-(void) editRequiredGender:(NSString*)gender
         againstFacebookId:(NSString*)fbId
               sucessBlock:(void (^)(bool isUpdated))successBlock
                   failure:(void (^)(NSError *error))failureBlock{
    
    
    NSDictionary *params = @{@"fb_id":fbId, @"req_gender":gender};
    
    [super makeRequestWithUrl:@"ChangeRequiredGender"
                andParameters:params
              withRequestType:RequestType_GET
             withResponseType:ResponseType_JSON
             withHeaderValues:nil
                 withResponse:^(id response) {
                     
                     NSDictionary *responseDict = (NSDictionary*)response;
                     
                     BOOL isUpdated = ([responseDict[@"status"] isEqualToString:@"Record Updated"]) ? true : false;
                     successBlock(isUpdated);
                     
                 } failure:^(NSError *error) {
                     
                     failureBlock (error);
                 }];
    
    
}



@end
