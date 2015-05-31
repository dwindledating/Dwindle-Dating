//
//  Chat.m
//  DwindleDating
//
//  Created by Yunas Qazi on 5/31/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "Chat.h"
#import "DateUtility.h"

@implementation Chat

- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.fbId   = dict[@"FromUser"];
        self.message   = dict[@"Message"];
        self.date   = [DateUtility dateStrWithRespectToday:[DateUtility getDwindleDateFromString:dict[@"Date"]]];
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
