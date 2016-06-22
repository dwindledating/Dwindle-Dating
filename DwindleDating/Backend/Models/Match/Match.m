
//
//  Matches.m
//  DwindleDating
//
//  Created by Yunas Qazi on 5/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "Match.h"
#import "DateUtility.h"

@implementation Match

- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.fbId   = dict[@"fb_id"];
        self.name   = dict[@"Name"];
        self.imgPath= [NSURL URLWithString:dict[@"PicPath"]];
        self.text   = dict[@"Text"];
        self.date   = [DateUtility dateStrWithRespectToday:[DateUtility getDwindleDateFromString:dict[@"Date"]]];
        self.status = dict[@"Status"];
        self.statusMessage = false;
        if ([dict[@"MessageStatus"] isEqualToString:@"read"]){
            self.statusMessage = true;
        }
    }

    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
