//
//  Matches.h
//  DwindleDating
//
//  Created by Yunas Qazi on 5/24/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Match : NSObject

@property (nonatomic,retain) NSString *fbId;
@property (nonatomic,retain) NSURL *imgPath;
@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) NSString *date;
@property BOOL status;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
