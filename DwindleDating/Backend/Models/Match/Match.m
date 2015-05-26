
//
//  Matches.m
//  DwindleDating
//
//  Created by Yunas Qazi on 5/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "Match.h"

@implementation Match

- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.fbId   = dict[@"fb_id"];
        self.imgPath= [NSURL URLWithString:dict[@"PicPath"]];
        self.text   = dict[@"Text"];
        self.date   = dict[@"Date"];
        self.status = [dict[@"Status"] boolValue];
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
