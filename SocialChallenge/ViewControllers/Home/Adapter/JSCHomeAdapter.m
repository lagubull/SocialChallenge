//
//  JSCHomeAdapter.m
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

#import "JSCHomeAdapter.h"

#import "JSCPost.h"
#import "JSCFeedAPIManager.h"
#import "CDSServiceManager.h"
#import "JSCPostTableViewCell.h"

@interface JSCHomeAdapter () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation JSCHomeAdapter

#pragma mark - TableView

- (void)setTableView:(UITableView *)tableView
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(tableView))];
    _tableView = tableView;
    [self didChangeValueForKey:NSStringFromSelector(@selector(tableView))];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[JSCPostTableViewCell class]
           forCellReuseIdentifier:[JSCPostTableViewCell reuseIdentifier]];
}

#pragma mark - JSCHomeAdapterDelegate

- (void)refresh
{
    [JSCFeedAPIManager retrieveFeedWithMode:JSCDataRetrievalOperationModeFirstPage
                                    Success:^(id result)
     {
         //TODO: success block
     }
                                    failure:^(NSError *error)
     {
         //TODO: failure block
     }];
}

- (void)paginate
{
    [JSCFeedAPIManager retrieveFeedWithMode:JSCDataRetrievalOperationModeNextPage
                                    Success:^(id result)
     {
         //TODO: success block
     }
                                    failure:^(NSError *error)
     {
         //TODO: failure block
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger fetchedRowsCount = [self.fetchedResultsController.fetchedObjects count];
    
    return fetchedRowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSCPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JSCPostTableViewCell reuseIdentifier]
                                                                         forIndexPath:indexPath];
    
    [self configureCell:cell
           forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220.0f;
}

#pragma mark - CDSTableViewFetchedResultsControllerDataDelegate

- (void)didUpdateContent
{
    
}

- (void)didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath]
           forIndexPath:indexPath];
}

#pragma mark - FetchResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                        managedObjectContext:[[CDSServiceManager sharedInstance] mainManagedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        
        [_fetchedResultsController performFetch:nil];
    }
    
    return _fetchedResultsController;
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([JSCPost class])
                                      inManagedObjectContext:[[CDSServiceManager sharedInstance] mainManagedObjectContext]];
    
    fetchRequest.predicate = self.predicateForFetchRequest;
    fetchRequest.sortDescriptors = self.sortDescriptorsForFetchRequest;
    
    return fetchRequest;
}

- (NSPredicate *)predicateForFetchRequest
{
    return nil;
}

- (NSArray *)sortDescriptorsForFetchRequest
{
    NSSortDescriptor *postIdSort = [NSSortDescriptor sortDescriptorWithKey:@"postID"
                                                                 ascending:YES];
    
    return @[postIdSort];
}

#pragma mark - CellSetup

- (void)configureCell:(JSCPostTableViewCell *)cell
         forIndexPath:(NSIndexPath *)indexPath
{
    JSCPost *post = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
//    cell.delegate = self;

    
    [cell updateWithPost:post];
}


@end