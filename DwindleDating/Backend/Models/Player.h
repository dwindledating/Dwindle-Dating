//
//  Player.h
//  DwindleDating
//
//  Created by Yunas Qazi on 4/16/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (nonatomic,retain) NSString *fbId;
@property (nonatomic,retain) NSURL *imgPath;
@property (nonatomic,retain) NSMutableArray *galleryImages;

- (instancetype)initWithDict:(NSDictionary*)dict;
- (void) addImageUrlToGallery:(NSString*)imgPath;

@end
