//
//  JCDates.h
//  BlipHomework
//
//  Created by João Carreira on 21/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCDates : NSObject

+(BOOL)isSameDayDate1:(NSDate *)date1 comparedWithDate2:(NSDate *)date2;
+(BOOL)isYesterdayDate1:(NSDate *)date1 comparedWithDate2:(NSDate *)date2;
+(NSString *)getHoursAndMinutesFromDate:(NSDate *)date withDateFormat:(NSString *)dateFormat;

@end
