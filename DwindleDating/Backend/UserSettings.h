//
//  IOUtility.h
//  IFFT2014
//
//  Created by Yunas Qazi on 3/25/14.
//  Copyright (c) 2014 AppsFoundry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSettings : NSObject<NSCoding>

@property (nonatomic, assign) NSString* userGender;
@property (nonatomic, strong) NSString* userDistance;
@property (nonatomic, strong) NSString* userAgeFrom;
@property (nonatomic, strong) NSString* userAgeTo;


+(UserSettings *) loadUserSettings;

-(void)saveUserSettings;

@end
