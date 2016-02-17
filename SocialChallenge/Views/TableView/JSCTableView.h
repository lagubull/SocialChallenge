//
//  JSCTableView.h
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

@class JSCTableView;

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

@end

@interface JSCTableView : UITableView

/**
 Delegate of the class.
 */
@property (nonatomic, weak) id <JSCDataRetrievalTableViewDelegate> dataRetrievalDelegate;

/**
 Tells the tableview we are about to paginate.
 */
- (void)willPaginate;

/**
 Tells the tableview pagination has finished.
 */
- (void)didPaginate;

@end