//
//  JSCJSONManager.m
//  SocialChallenge
//
//  Created by Javier Laguna on 15/08/2015.
//
//

#import "JSCJSONManager.h"

@interface JSCJSONManager ()

/**
 Applies UYF9 encoding to the data
 
 @param Data without UTF8 encoding
 
 @result data with UTF8 enconding
 */
+ (NSData *)encondeDataUTF8:(NSData *)data;

/**
 Reads the deserialised data in a NSdictionary
 
 @param data to process
 
 @result Dictionary with the processed information
 */
+ (NSDictionary *)JSONObjectWithData:(NSData *)responseData;

@end

@implementation JSCJSONManager

+ (NSDictionary *)processJSONData:(NSData *)data
{
    NSDictionary *resultDictionary = nil;
    
    if(![data isKindOfClass:NSDictionary.class])
    {
        data = [JSCJSONManager encondeDataUTF8:data];
        resultDictionary =  [JSCJSONManager JSONObjectWithData:data];
    }
    else
    {
        resultDictionary = (NSDictionary *)data;
    }
    
    return resultDictionary;
}

+ (NSData *)encondeDataUTF8:(NSData *)data
{
    NSData *resultData = nil;
    
    @try
    {
        NSString *theContent = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        
        NSString *newJsonString = [theContent stringByReplacingOccurrencesOfString:@"\t"
                                                                        withString:@"\\t"];
        
        resultData = [newJsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        data = resultData;
    }
    @catch (NSException *exception)
    {
        NSLog(@"ERROR encondeDataUTF8");
    }
    @finally
    {
        return resultData;
    }
}

+ (NSDictionary *)JSONObjectWithData:(NSData *)responseData
{
    NSDictionary *fetchedDataDictionary = nil;
    NSError *error;
    
    @try
    {
        fetchedDataDictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                options:kNilOptions
                                                                  error:&error];
        if (error)
        {
            NSLog(@"%@", error);
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"ERROR JSONObjectWithData");
    }
    @finally
    {
        return fetchedDataDictionary;
    }
}

@end
