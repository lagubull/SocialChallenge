//
//  JSCTableView.h
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

@class JSCTableView;
@class JSCPaginatingView;

@protocol JSCDataRetrievalTableViewDelegate <NSObject>

@optional

/**
 Called after FSNDataRetrievalTableView instance has asked for data refresh;
 */
- (void)dataRetrievalTableViewDidRequestRefresh:(JSCTableView *)tableView;

/**
 Called when we have past the half of the items in the last page loaded.
 */
- (void)paginate;

/**
 Call when there is an update.
 
 @param indexPath - index path of the updated row.
 */
- (void)didUpdateItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JSCTableView : UITableView

/**
 Delegate of the class.
 */
@property (nonatomic, weak) id <JSCDataRetrievalTableViewDelegate> dataRetrievalDelegate;

/**
 */
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/**
 Pagination content view to show the local user we are retrieving fresh data.
 */
@property (nonatomic, strong) JSCPaginatingView *paginatingView;

/**
 Tells the tableview we are about to paginate.
 */
- (void)willPaginate;

/**
 Tells the tableview pagination has finished.
 */
- (void)didPaginate;

@end