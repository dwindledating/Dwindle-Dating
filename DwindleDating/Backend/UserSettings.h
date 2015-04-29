//
//  IOUtility.h
//  IFFT2014
//
//  Created by Yunas Qazi on 3/25/14.
//  Copyright (c) 2014 AppsFoundry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSettings : NSObject<NSCoding>

@property (nonatomic, strong) NSString* userGender;
@property (nonatomic, strong) NSString* requiredGender;
@property (nonatomic, strong) NSString* userDistance;
@property (nonatomic, strong) NSString* userAgeFrom;
@property (nonatomic, strong) NSString* userAgeTo;
@property (nonatomic, strong) NSString* fbName;
@property (nonatomic, strong) NSString* fbId;

+(UserSettings *) loadUserSettings;

-(void)saveUserSettings;
-(void)removeUserSettings;

@end
