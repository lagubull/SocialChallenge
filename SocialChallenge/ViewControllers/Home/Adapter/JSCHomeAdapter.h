//
//  JSCHomeAdapter.h
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

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
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong, readonly) NSFetchRequest *fetchRequest;

@property (nonatomic, strong, readonly) NSPredicate *predicateForFetchRequest;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/**
 Requests and updated of the content.
 */
- (void)refresh;

@end
