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

@property (nonatomic, weak) id<JSCHomeAdapterDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong, readonly) NSFetchRequest *fetchRequest;

@property (nonatomic, strong, readonly) NSPredicate *predicateForFetchRequest;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)refresh;

@end
