//
//  JSCFileManager.m
//  SocialChallenge
//
//  Created by Javier Laguna on 17/02/2016.
//
//

#import "JSCFileManager.h"

static NSString * const kJSCLocalDirectory = @"SocialChallenge";

@interface JSCFileManager ()

/**
 Path of documents directory.
 
 @return NSString instance.
 */
+ (NSString *)documentsDirectoryPath;

/**
 Path of resource in documents directory.
 
 @param path - path that will be combined documents path.
 
 @return Combined path.
 */
+ (NSString *)documentsDirectoryPathForResourceWithPath:(NSString *)path;

/**
 Save data to path on filesystem.
 
 If the directory doesn't exist it will be created.
 
 @param data - data to be saved.
 @param path - path that the data will be saved to.
 
 @return BOOL if save was successful.
 */
+ (BOOL)saveData:(NSData *)data toPath:(NSString *)path;

/**
 Creates directory on filesystem.
 
 If the directory doesn't exist it will be created.
 
 @param path - path that will be created.
 
 @return BOOL if creation was successful.
 */
+ (BOOL)createDirectoryAtPath:(NSString *)path;

/**
 Delete data from path.
 
 @param path - path to the file.
 
 @return BOOL if deletion was successful.
 */
+ (BOOL)deleteDataAtPath:(NSString *)path;

@end

@implementation JSCFileManager

#pragma mark - Documents

+ (NSString *)documentsDirectoryPath
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    
    return [directoryURL path];
}

+ (NSString *)documentsDirectoryPathForResourceWithPath:(NSString *)path
{
    NSString *documentsDirectory = [self documentsDirectoryPath];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:kJSCLocalDirectory];
    
    return [documentsDirectory stringByAppendingPathComponent:path];
}

#pragma mark - Retrieval

+ (NSData *)retrieveDataFromDocumentsDirectoryWithPath:(NSString *)path
{
    NSString *extendedPath = [self documentsDirectoryPathForResourceWithPath:path];
    
    return [NSData dataWithContentsOfFile:extendedPath];
}

#pragma mark - Saving

+ (BOOL)saveData:(NSData *)data toDocumentsDirectoryPath:(NSString *)path
{
    NSString *documentsDirectory = [self documentsDirectoryPathForResourceWithPath:path];
    
    return [self saveData:data
                   toPath:documentsDirectory];
}

+ (BOOL)saveData:(NSData *)data
          toPath:(NSString *)path
{
    BOOL success = NO;
    
    if (data.length > 0 &&
        path.length > 0)
    {
        BOOL createdDirectory = YES;
        
        NSString *folderPath = [path stringByDeletingLastPathComponent];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        {
            createdDirectory = [self createDirectoryAtPath:folderPath];
        }
        
        if (createdDirectory)
        {
            NSError *error = nil;
            
            success = [data writeToFile:path
                                options:NSDataWritingAtomic
                                  error:&error];
            
            if (error)
            {
                NSLog(@"Error when attempting to write data to directory: %@", [error userInfo]);
            }
        }
    }
    
    return success;
}

+ (BOOL)createDirectoryAtPath:(NSString *)path
{
    BOOL createdDirectory = NO;
    
    if (path.length > 0)
    {
        NSError *error = nil;
        
        createdDirectory = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                                     withIntermediateDirectories:YES
                                                                      attributes:nil
                                                                           error:&error];
        
        if(error)
        {
            NSLog(@"Error when creating a directory at location: %@", path);
        }
    }
    
    return createdDirectory;
}

#pragma mark - Deletion

+ (BOOL)deleteDataFromDocumentDirectoryWithPath:(NSString *)path
{
    NSString *documentsDirectory = [self documentsDirectoryPathForResourceWithPath:path];
    
    return [self deleteDataAtPath:documentsDirectory];
}

+ (BOOL)deleteDataAtPath:(NSString *)path
{
    NSError *error = nil;
    
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path
                                                              error:&error];
    
    if (error)
    {
        NSLog(@"Error when attempting to delete data from disk: %@", [error userInfo]);
    }
    
    return success;
}

@end
