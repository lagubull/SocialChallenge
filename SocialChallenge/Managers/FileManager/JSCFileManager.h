//
//  JSCFileManager.h
//  SocialChallenge
//
//  Created by Javier Laguna on 17/02/2016.
//
//

#import <Foundation/Foundation.h>

@interface JSCFileManager : NSObject

/**
 Retrieve data to path in document directory.
 
 @param path - path that will be combined documents path.
 
 @return NSData that was retrieved.
 */
+ (NSData *)retrieveDataFromDocumentsDirectoryWithPath:(NSString *)path;

/**
 Save data to path in document directory.
 
 @param data - data to be saved.
 @param path - path that will be combined documents path.
 
 @return BOOL if save was successful.
 */
+ (BOOL)saveData:(NSData *)data toDocumentsDirectoryPath:(NSString *)path;

/**
 Delete data from path in document directory.
 
 @param path - path that will be combined documents path.
 
 @return BOOL if deletion was successful.
 */
+ (BOOL)deleteDataFromDocumentDirectoryWithPath:(NSString *)path;

@end
