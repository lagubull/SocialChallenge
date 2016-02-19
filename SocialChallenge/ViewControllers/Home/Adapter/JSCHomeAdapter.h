//
//  JSCHomeAdapter.h
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

@class JSCTableView;

@protocol JSCHomeAdapterDelegate <NSObject>

@end

@interface JSCHomeAdapter : NSObject

/**
 Delegate of the HSCHomeAdapterDelegate protocol.
 */
@property (nonatomic, weak) id<JSCHomeAdapterDelegate> delegate;

/**
 Shows the content.
 */
@property (nonatomic, strong) JSCTableView *tableView;

/**
 Fetch request for retrieving posts.
 */
@property (nonatomic, strong, readonly) NSFetchRequest *fetchRequest;

/**
 Used to connect the TableView with Core Data.
 */
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/**
 Requests and updated of the content.
 */
- (void)refresh;

@end
