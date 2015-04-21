//
//  Player.m
//  DwindleDating
//
//  Created by Yunas Qazi on 4/16/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [self initWithFBId:dict[@"fb_id"] andImagePath:@"pic_path"];
    return self;
}

- (instancetype)initWithFBId:(NSString*)fbId andImagePath:(NSString*)imgPath{
    self = [super init];
    if (self) {
        self.fbId = [NSString stringWithString:fbId];
        self.imgPath = [NSURL URLWithString:imgPath];
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
