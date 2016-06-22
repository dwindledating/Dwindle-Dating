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
    self = [self initWithFBId:dict[@"fb_id"] andImagePath:dict[@"pic_path"]];
    return self;
}

- (instancetype)initWithFBId:(NSString*)fbId andImagePath:(NSString*)imgPath{
    self = [super init];
    if (self) {
        self.fbId = [NSString stringWithString:fbId];
        self.imgPath = [NSURL URLWithString:imgPath];
        self.galleryImages = [NSMutableArray new];
        [self.galleryImages addObject:self.imgPath];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void) addImageUrlToGallery:(NSString*)imgPath{
     [self.galleryImages addObject:[NSURL URLWithString:imgPath]];
}

@end
