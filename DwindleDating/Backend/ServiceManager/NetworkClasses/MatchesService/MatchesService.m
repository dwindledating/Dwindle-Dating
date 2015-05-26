//
//  MatchesService.m
//  DwindleDating
//
//  Created by Yunas Qazi on 5/23/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "MatchesService.h"
#import "Match.h"

@implementation MatchesService

-(void) getMathchesForUser:(NSString*)fbId
               sucessBlock:(void (^)(NSArray *matchesArr))successBlock
                   failure:(void (^)(NSError *error))failureBlock{
 
    NSDictionary *params = @{@"fb_id":fbId};
    
    [super makeRequestWithUrl:@"GetMatches"
                andParameters:params
              withRequestType:RequestType_GET
             withResponseType:ResponseType_JSON
             withHeaderValues:nil
                 withResponse:^(id response) {
                     
                     //GOT PRODUCTS PARSE IT
                     
                     if ([response isKindOfClass:[NSDictionary class]]){
                         NSDictionary *responseDict = (NSDictionary*)response;
                         BOOL isEmpty = ([responseDict[@"status"] isEqualToString:@"No Record Found"]) ? false : true;
                         if (!isEmpty)
                         {
                             NSError *error = [NSError errorWithDomain:@"NoRecord" code:420 userInfo:@{@"msg":@"No Record found"}];
                             failureBlock(error);
                         }
                     }
                     else{
                         
                         NSMutableArray *matchesArr = [NSMutableArray new];
                         NSArray *responseArr = (NSArray*)response;
                         for (NSDictionary *dict  in responseArr) {
                             Match *match = [[Match alloc]initWithDict:dict];
                             [matchesArr addObject:match];
                         }
                          successBlock(matchesArr);
                     }

                 } failure:^(NSError *error) {
                     
                     failureBlock (error);
                 }];

}

@end
