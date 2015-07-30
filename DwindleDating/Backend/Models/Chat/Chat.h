//
//  Chat.h
//  DwindleDating
//
//  Created by Yunas Qazi on 5/31/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chat : NSObject

@property (nonatomic,retain) NSString *fbId;
@property (nonatomic,retain) NSString *message;
@property (nonatomic,retain) NSString *date;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
