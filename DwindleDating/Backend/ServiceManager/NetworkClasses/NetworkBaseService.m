//
//  BaseService.m
//  RocketInternetTest
//
//  Created by Yunas Qazi on 2/12/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

#import "NetworkBaseService.h"
#import "AFHTTPRequestOperationManager.h"

NSString *const kApp_BaseUrl = @"http://159.203.245.103:3000/";

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



-(void) uploadRequestWithUrl:(NSString*)URLString
               andParameters:(NSDictionary*)params
          andImageParameters:(NSArray*)imagesArr
            withResponseType:(ResponseType)responseType
            withHeaderValues:(NSDictionary*)headerParams
                withResponse:(void (^)(id response))success
                     failure:(void (^)(NSError *error))fail{
    
    if(URLString == nil){
        URLString = kApp_BaseUrl;
    }
    else{
        URLString = [NSString stringWithFormat:@"%@%@",kApp_BaseUrl,URLString];
    }

    


    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                             URLString:URLString
                            parameters:params
             constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
                int imgNo = 1;
                for(UIImage *img in imagesArr)
                {
                    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
                    NSString *imgName = [NSString stringWithFormat:@"image%d.jpg",imgNo];
                    [formData appendPartWithFileData: imgData
                                                name:@"image"
                                            fileName:imgName
                                            mimeType:@"image/jpg"];
                }
                 
                
                
                 for (NSString *key in params.allKeys) {
                     NSMutableData *data = [[NSMutableData alloc] init];
                     [data appendData:[params[key] dataUsingEncoding:NSUTF8StringEncoding]];
                     [formData appendPartWithFormData:data name:key];
                 }
                 

                 
             } error:nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    AFHTTPRequestOperation *op = [manager HTTPRequestOperationWithRequest:request success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        fail(error);
    }];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op start];

    
}



-(void) makeRequestWithUrl:(NSString*)url
             andParameters:(id)params
           withRequestType:(RequestType)requestType
          withResponseType:(ResponseType)responseType
          withHeaderValues:(NSDictionary*)headerParams
              withResponse:(void (^)(id response))success
                   failure:(void (^)(NSError *error))fail{
    
    if(url == nil){
        url = kApp_BaseUrl;
    }
    else{
        url = [NSString stringWithFormat:@"%@%@",kApp_BaseUrl,url];
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
          parameters:params
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
