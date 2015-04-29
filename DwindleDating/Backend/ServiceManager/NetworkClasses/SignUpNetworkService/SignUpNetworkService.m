//
//  SignUpNetworkService.m
//  DwindleDating
//
//  Created by Yunas Qazi on 4/7/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "SignUpNetworkService.h"

@implementation SignUpNetworkService


-(void) signupWithFacebookId:(NSString*)fbId
                      gender:(NSString*)gender
              requiredGender:(NSString*)reqGender
                     fromAge:(NSString*)fromAge
                       toAge:(NSString*)toAge
                    distance:(NSString*)distance
                      images:(NSArray*)imagesArr
                 sucessBlock:(void (^)(BOOL isRegistered))successBlock
                     failure:(void (^)(NSError *error))failureBlock{
    
    
    NSString *urlString =  @"signup";//@"signup/123/male/female/20/30/5";
    
    
    NSDictionary *params = @{@"fb_id":fbId,
                             @"user_gender":gender,
                             @"req_gender":reqGender,
                             @"req_from_age":fromAge,
                             @"req_to_age":toAge,
                             @"distance":distance};
    
    [super uploadRequestWithUrl:urlString
                  andParameters:params
             andImageParameters:imagesArr
               withResponseType:ResponseType_JSON
               withHeaderValues:nil
                   withResponse:^(id response) {
                       //GOT PRODUCTS PARSE IT
                       NSDictionary *responseDict = (NSDictionary*)response;
                       
                       BOOL isRegistered = ([responseDict[@"STATUS"] isEqualToString:@"Registered Successful"]) ? true : false;
                       successBlock(isRegistered);
                       
                   } failure:^(NSError *error) {
                       failureBlock (error);
                       
                   }];
    
    
    
}



@end
