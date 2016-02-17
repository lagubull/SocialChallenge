//
//  JSCFileManager.m
//  SocialChallenge
//
//  Created by Javier Laguna on 17/02/2016.
//
//

#import "JSCFileManager.h"

static NSString * const kJSCLocalDirectory = @"SocialChallenge";

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
    NSString *documentsDirectory = [self documentsDirectoryPath];
    NSString *extendedPath = [documentsDirectory stringByAppendingPathComponent:path];
    
    return [self saveData:data
                   toPath:extendedPath];
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

#pragma mark - Exists

+ (BOOL)fileExistsInDocumentsDirectory:(NSString *)path
{
    NSString *documentsDirectory = [self documentsDirectoryPath];
    NSString *extendedPath = [documentsDirectory stringByAppendingPathComponent:path];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:extendedPath];
}

+ (BOOL)fileExistsAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (void)fileExistsAtPath:(NSString *)path
              completion:(void (^)(BOOL fileExists))completion
{
    //Used to return the call on the same thread
    NSOperationQueue *callBackQueue = [NSOperationQueue currentQueue];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
                   {
                       BOOL fileExists = [self fileExistsAtPath:path];
                       
                       [callBackQueue addOperationWithBlock:^
                        {
                            if (completion)
                            {
                                completion(fileExists);
                            }
                        }];
                   });
}

#pragma mark - Deletion

+ (BOOL)deleteDataFromDocumentDirectoryWithPath:(NSString *)path
{
    NSString *documentsDirectory = [self documentsDirectoryPath];
    NSString *extendedPath = [documentsDirectory stringByAppendingPathComponent:path];
    
    return [self deleteDataAtPath:extendedPath];
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

#pragma mark - URL

+ (NSURL *)fileURLForPath:(NSString *)path
{
    return [NSURL fileURLWithPath:path];
}

#pragma mark - Move

+ (BOOL)moveFileFromSourcePath:(NSString *)sourcePath
             toDestinationPath:(NSString *)destinationPath
{
    BOOL success = NO;
    BOOL createdDirectory = YES;
    
    destinationPath = [self documentsDirectoryPathForResourceWithPath:destinationPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destinationDirectoryPath = [destinationPath stringByDeletingLastPathComponent];
    
    if (![fileManager fileExistsAtPath:destinationDirectoryPath])
    {
        createdDirectory = [self createDirectoryAtPath:destinationDirectoryPath];
    }
    
    if (createdDirectory)
    {
        NSError *error = nil;
        
        success = [fileManager moveItemAtPath:sourcePath
                                       toPath:destinationPath
                                        error:&error];
        
        if (error)
        {
            NSLog(@"Error when attempting to move data on disk: %@", [error userInfo]);
        }
    }
    
    return success;
}

@end
