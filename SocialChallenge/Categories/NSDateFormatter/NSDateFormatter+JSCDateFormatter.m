//
//  NSDateFormatter+JSCDateFormatter.m
//  SocialChallenge
//
//  Created by Javier Laguna on 02/02/2016.
//
//

#import "NSDateFormatter+JSCDateFormatter.h"

/**
 Key to store the fateFormatter in the threads dictionary.
*/
static NSString *const kJSCDateFormatterKey = @"dateFormatterKey";

@implementation NSDateFormatter (JSCDateFormatter)

#pragma mark - DateFormatter

+ (NSDateFormatter *)jsc_dateFormatter
{
    if (![NSThread currentThread].threadDictionary[kJSCDateFormatterKey])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_GB"]];
        
        [NSThread currentThread].threadDictionary[kJSCDateFormatterKey] = dateFormatter;
    }
    
    return [NSThread currentThread].threadDictionary[kJSCDateFormatterKey];
}

@end
