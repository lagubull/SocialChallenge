//
//  NSDateFormatter+JSCDateFormatter.h
//  SocialChallenge
//
//  Created by Javier Laguna on 02/02/2016.
//
//

#import <Foundation/Foundation.h>

/**
 Manages our date format.
 */
@interface NSDateFormatter (JSCDateFormatter)

/**
 Convinient method to create a date formatter per thread.
 
 @return NSDateFormmater of the thread we are on.
 */
+ (NSDateFormatter *)jsc_dateFormatter;

@end
