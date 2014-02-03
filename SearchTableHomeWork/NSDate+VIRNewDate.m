//
//  NSDate+VIRNewDate.m
//  SearchTableHomeWork
//
//  Created by Administrator on 03.02.14.
//  Copyright (c) 2014 Konstantin Kokorin. All rights reserved.
//

#import "NSDate+VIRNewDate.h"

@implementation NSDate (VIRNewDate)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    
    return [calendar dateFromComponents:components];
}

@end
