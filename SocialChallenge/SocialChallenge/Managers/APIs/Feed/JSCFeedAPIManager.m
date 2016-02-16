//
//  JSCFeedAPIManager.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCFeedAPIManager.h"

#import "JSCFeedRetrieveOperation.h"
#import "JSCOperationCoordinator.h"

@implementation JSCFeedAPIManager

+ (void)retrieveFeedWithMode:(JSCDataRetrievalOperationMode)mode
                     Success:(JSCOperationOnSuccessCallback)success
                     failure:(JSCOperationOnFailureCallback)failure
{
    DLog(@"Queuing request to retrieve feed");
    
    JSCFeedRetrieveOperation *operation = [[JSCFeedRetrieveOperation alloc] initWithMode:mode];
    
    operation.onSuccess = success;
    operation.onFailure = failure;
    
    operation.targetSchedulerIdentifier = kJSCNetworkDataOperationSchedulerTypeIdentifier;
    
    [[JSCOperationCoordinator sharedInstance] addOperation:operation];
}

@end
