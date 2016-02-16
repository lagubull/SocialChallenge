//
//  JSCJSONManager.h
//  SocialChallenge
//
//  Created by Javier Laguna on 15/08/2015.
//
//

@interface JSCJSONManager : NSObject

/**
 Reads the data and deserialises it in a NSdictionary
 
 @param data to process
 
 @result Dictionary with the processed information
 */
+ (NSDictionary *)processJSONData:(NSData *)data;

@end
