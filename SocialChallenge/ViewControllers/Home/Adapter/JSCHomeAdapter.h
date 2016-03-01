//
//  JSCHomeAdapter.h
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

@class STVSimpleTableView;
@class JSCPost;

@protocol JSCHomeAdapterDelegate <NSObject>

/**
 User pressed on the favorites button.
 
 @parameter post - post cell is showing.
 */
- (void)didPressFavoritesButton:(JSCPost *)post;

/**
 User pressed on the comments button.
 
 @parameter post - post cell is showing.
 */
- (void)didPressCommentsButton:(JSCPost *)post;

@end

@interface JSCHomeAdapter : NSObject

/**
 Delegate of the HSCHomeAdapterDelegate protocol.
 */
@property (nonatomic, weak) id<JSCHomeAdapterDelegate> delegate;

/**
 Shows the content.
 */
@property (nonatomic, strong) STVSimpleTableView *tableView;

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
