//
//  NSDate+Extras.m
//  BlipHomework
//
//  Created by João Carreira on 21/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import "NSDate+Extras.h"

@implementation NSDate (Extras)

+(BOOL)isSameDayDate1:(NSDate *)date1 comparedWithDate2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned dateFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *component1 = [calendar components:dateFlags fromDate:date1];
    NSDateComponents *component2 = [calendar components:dateFlags fromDate:date2];
    
    return [component1 day] == [component2 day] && [component1 month] == [component2 month] && [component1 year] == [component2 year];
}


+(BOOL)isYesterdayDate1:(NSDate *)date1 comparedWithDate2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned dateFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *component1 = [calendar components:dateFlags fromDate:date1];
    NSDateComponents *component2 = [calendar components:dateFlags fromDate:date2];
    
    return [component1 day] == [component2 day] + 1
    && [component1 month] == [component2 month]
    && [component1 year] == [component2 year];
}


+(NSString *)getHoursAndMinutesFromDate:(NSDate *)date withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)hour, (long)minute];
}

@end
