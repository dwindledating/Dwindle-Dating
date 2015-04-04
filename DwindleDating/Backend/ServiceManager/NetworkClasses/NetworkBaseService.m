//
//  BaseService.m
//  RocketInternetTest
//
//  Created by Yunas Qazi on 2/12/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

#import "NetworkBaseService.h"
#import "AFHTTPRequestOperationManager.h"

NSString *const kApp_BaseUrl = @"http://52.11.98.82:3000/login/637824466345948";

@implementation NetworkBaseService


-(void) makePostRequestWithUrl:(NSURL*)URL
                 andParameters:(NSDictionary*)params
              withResponseType:(ResponseType)responseType
              withHeaderValues:(NSDictionary*)headerParams
                  withResponse:(void (^)(id response))success
                       failure:(void (^)(NSError *error))fail{
    
    if(URL == nil){
        URL = [NSURL URLWithString:kApp_BaseUrl];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    
    
    for (NSString *key in [headerParams allKeys]) {
        [request setValue:headerParams[key] forHTTPHeaderField:key];
    }
    
    [request setHTTPBody:params[@"data"]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        fail(error);
        
    }];
    [op start];
    
}



-(void) makeRequestWithUrl:(NSString*)url
             andParameters:(NSDictionary*)params
           withRequestType:(RequestType)requestType
          withResponseType:(ResponseType)responseType
          withHeaderValues:(NSDictionary*)headerParams
              withResponse:(void (^)(id response))success
                   failure:(void (^)(NSError *error))fail{
    
    if(url == nil){
        url = kApp_BaseUrl;
    }

    
    if (requestType == RequestType_POST) {
        [self makePostRequestWithUrl:[NSURL URLWithString:url]
                       andParameters:params
                    withResponseType:responseType
                    withHeaderValues:headerParams
                        withResponse:success
                             failure:fail];
    }
    else{
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        if (responseType == ResponseType_PLAIN_HTML) {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
        else if (responseType == ResponseType_JSON){
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
        else if (responseType == ResponseType_XML) {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        }
        
        if (headerParams) {
            AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
            
            for (NSString *key in [headerParams allKeys]) {
                [requestSerializer setValue:headerParams[key] forHTTPHeaderField:key];
            }
            
            manager.requestSerializer = requestSerializer;
        
        }
        
        [manager GET:url
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 success(responseObject);
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 fail(error);
             }];
    
    }
    
}


-(void) makeRequestWithMethod:(NSString*)method
                andParameters:(NSDictionary*)params
                 withResponse:(void (^)(id response))success
                      failure:(void (^)(NSError *error))fail{
 
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSString *urlWithMethod = [NSString stringWithFormat:@"%@%@",kApp_BaseUrl,method];
    
    [manager GET:urlWithMethod
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             success(responseObject);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             fail(error);
             
         }];

    
}



@end
