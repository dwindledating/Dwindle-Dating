//
//  GetUserPicturesService.h
//  DwindleDating
//
//  Created by Yunas Qazi on 4/28/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "NetworkBaseService.h"

@interface PicturesService : NetworkBaseService


-(void) getUserPicturesAgainstFacebookId:(NSString*)fbId
                             sucessBlock:(void (^)(NSDictionary* pictures))successBlock
                                 failure:(void (^)(NSError *error))failureBlock;



-(void) updateUserPictureAgainstFacebookId:(NSString*)fbId
                            andPictureName:(NSString*)picName
                                 withImage:(NSArray*)imagesArr
                               sucessBlock:(void (^)(BOOL isUpdated))successBlock
                                   failure:(void (^)(NSError *error))failureBlock;


@end
