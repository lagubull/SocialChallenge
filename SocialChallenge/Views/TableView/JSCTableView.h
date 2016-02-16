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

- (void)paginate;

@end


@interface JSCTableView : UITableView

@property (nonatomic, weak) id <JSCDataRetrievalTableViewDelegate> dataRetrievalDelegate;

@end
