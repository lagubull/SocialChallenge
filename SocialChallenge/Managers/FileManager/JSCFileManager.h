//
//  JSCFileManager.h
//  SocialChallenge
//
//  Created by Javier Laguna on 17/02/2016.
//
//

#import <Foundation/Foundation.h>

@interface JSCFileManager : NSObject

+ (NSData *)retrieveDataFromDocumentsDirectoryWithPath:(NSString *)path;

+ (BOOL)moveFileFromSourcePath:(NSString *)sourcePath
             toDestinationPath:(NSString *)destinationPath;

+ (BOOL)saveData:(NSData *)data toDocumentsDirectoryPath:(NSString *)path;

@end
