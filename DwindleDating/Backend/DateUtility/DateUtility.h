//
//  DateUtility.h
//  IOTab
//
//  Created by Yunas Qazi on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtility : NSObject

+(NSDate*) dateWithUTCStr :(NSString *)utcDateStr;
+(NSTimeInterval) UTCWithDate:(NSDate *)date;
+(NSString *) dateStrWithRespectToday:(NSDate*)date2;
@end
