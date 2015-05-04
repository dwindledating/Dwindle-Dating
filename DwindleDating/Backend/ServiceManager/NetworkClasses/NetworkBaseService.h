//
//  BaseService.h
//  RocketInternetTest
//
//  Created by Yunas Qazi on 2/12/15.
//  Copyright (c) 2015 Coeus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ResponseBlock)(id JSONObject);
typedef void(^FailureBlock) (NSError *error);

typedef enum {
    ResponseType_JSON,
    ResponseType_PLAIN_HTML,
    ResponseType_XML,
}ResponseType;

typedef enum {
    RequestType_GET,
    RequestType_POST,
}RequestType;


@interface NetworkBaseService : NSObject

-(void) makeRequestWithUrl:(NSString*)url
             andParameters:(NSDictionary*)params
           withRequestType:(RequestType)requestType
          withResponseType:(ResponseType)responseType
          withHeaderValues:(NSDictionary*)headerParams
              withResponse:(void (^)(id response))success
                   failure:(void (^)(NSError *error))fail;


-(void) makeRequestWithMethod:(NSString*)method
                andParameters:(NSDictionary*)params
                 withResponse:(void (^)(id response))success
                      failure:(void (^)(NSError *error))fail;


-(void) uploadRequestWithUrl:(NSString*)URLString
               andParameters:(NSDictionary*)params
          andImageParameters:(NSArray*)imagesArr
            withResponseType:(ResponseType)responseType
            withHeaderValues:(NSDictionary*)headerParams
                withResponse:(void (^)(id response))success
                     failure:(void (^)(NSError *error))fail;

@end
