//
//  GetUserPicturesService.m
//  DwindleDating
//
//  Created by Yunas Qazi on 4/28/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "PicturesService.h"

@implementation PicturesService

-(void) getUserPicturesAgainstFacebookId:(NSString*)fbId
                             sucessBlock:(void (^)(NSDictionary* pictures))successBlock
                                 failure:(void (^)(NSError *error))failureBlock{
    
    NSDictionary *params = @{@"fb_id":fbId};
    
    [super makeRequestWithUrl:@"GetUserPictures"
                andParameters:params
              withRequestType:RequestType_GET
             withResponseType:ResponseType_JSON
             withHeaderValues:nil
                 withResponse:^(id response) {
                         successBlock(response);
                     
                 } failure:^(NSError *error) {
                     
                     failureBlock (error);
                 }];

}



-(void) updateUserPictureAgainstFacebookId:(NSString*)fbId
                            andPictureName:(NSString*)picName
                                 withImage:(NSArray*)imagesArr
                               sucessBlock:(void (^)(BOOL isUpdated))successBlock
                                   failure:(void (^)(NSError *error))failureBlock{

    NSString *urlString =  @"UpdateUserPicture";//@"signup/123/male/female/20/30/5";
    
    NSDictionary *params = @{@"fb_id":fbId,
                             @"pic_name":picName};
    
    [super uploadRequestWithUrl:urlString
                  andParameters:params
             andImageParameters:imagesArr
               withResponseType:ResponseType_JSON
               withHeaderValues:nil
                   withResponse:^(id response) {
                       //GOT PRODUCTS PARSE IT
                       NSDictionary *responseDict = (NSDictionary*)response;
                       
                       BOOL isRegistered = ([responseDict[@"STATUS"] isEqualToString:@"Picture Updated"]) ? true : false;
                       successBlock(isRegistered);
                       
                   } failure:^(NSError *error) {
                       failureBlock (error);
                       
                   }];
}


@end
