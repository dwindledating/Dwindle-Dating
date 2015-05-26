//
//  DateUtility.m
//  IOTab
//
//  Created by Yunas Qazi on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

+(NSDate*) dateWithUTCStr :(NSString *)utcDateStr{

	double timeInterval = [utcDateStr doubleValue];
	timeInterval = timeInterval /1000;
	
	return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+(NSTimeInterval) UTCWithDate:(NSDate *)date{

	return [date timeIntervalSince1970]*1000;
}



+(double) differenceBetween :(NSDate *)firstDate andOtherDate:(NSDate *)secondDate{
	
	NSTimeInterval secondsBetween = [secondDate timeIntervalSinceDate:firstDate];
	return secondsBetween;
}


+(NSString *) dateStrWithRespectToday:(NSDate*)date2{
	
	NSString *result=nil;
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                               fromDate:date2
                                                 toDate:[NSDate date]
                                                options:0];
    if(components.month>1){
    
        NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
        [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [theDateFormatter setDateFormat:@"dd-MM-yyyy"];
         [theDateFormatter setLocale:[NSLocale currentLocale]];
        result = [theDateFormatter stringFromDate:date2];
        return result;
        
    }
    else if(components.month >0){
    
        result=@"Last month";
        return result;
        
    }
    else if(components.day>7){
    
        if(components.day>21)
            result=@"Three weeks ago";
        else
            result=@"Two weeks ago";
        
        return result;
        
    }
    else if(components.day==7){
    
        result=@"Last Week";
        return result;
        
    }
    else if(components.day>=2){
    
        NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
        [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [theDateFormatter setDateFormat:@"MMMM"];
        result = [theDateFormatter stringFromDate:date2];
        result=[NSString stringWithFormat:@"Last %@",result];
        return result;
        
    }
    else if (components.day>0){
    
        NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
        [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [theDateFormatter setDateFormat:@"hh:mm a"];
          [theDateFormatter setLocale:[NSLocale currentLocale]];
        result = [theDateFormatter stringFromDate:date2];
        
        result=[NSString stringWithFormat:@"Yesterday at %@",result];
        return result;

    }
    else{
    
        NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
        [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [theDateFormatter setDateFormat:@"dd"];
        NSString * dte1 = [theDateFormatter stringFromDate:date2];
        NSString * dte2 = [theDateFormatter stringFromDate:[NSDate date]];

        theDateFormatter = [[NSDateFormatter alloc] init];
        [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [theDateFormatter setDateFormat:@"hh:mm a"];
          [theDateFormatter setLocale:[NSLocale currentLocale]];
        result = [theDateFormatter stringFromDate:date2];

        
        if([dte1 isEqualToString:dte2]){
        
            result=[NSString stringWithFormat:@"%@",result];
            
        }else{
        
            result=[NSString stringWithFormat:@"Yesterday:%@",result];
        }
        return result;

    }
    
    NSDate *today = [NSDate date];
	double timeInSeconds = 0;
	int numberOfDays = 0;
	timeInSeconds = [DateUtility differenceBetween:date2 andOtherDate:today];
	
	numberOfDays = timeInSeconds/86400;
	
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
	[theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];

    
	if (numberOfDays <= 0) {
		[theDateFormatter setDateFormat:@"hh:mm a"];
          [theDateFormatter setLocale:[NSLocale currentLocale]];
	}
	else {
        [theDateFormatter setDateFormat:@"dd-MM-yyyy"];
	}
	NSString *dateStr =  [theDateFormatter stringFromDate:date2];	
    return dateStr;
	
}


@end
