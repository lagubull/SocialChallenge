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
#import "JSCTableView.h"

@interface JSCHomeAdapter () <UITableViewDataSource, UITableViewDelegate, JSCDataRetrievalTableViewDelegate, NSFetchedResultsControllerDelegate>

@end

@implementation JSCHomeAdapter

#pragma mark - TableView

- (void)setTableView:(JSCTableView *)tableView
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(tableView))];
    _tableView = tableView;
    [self didChangeValueForKey:NSStringFromSelector(@selector(tableView))];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.dataRetrievalDelegate = self;
    
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
    [self.tableView willPaginate];
    
    [JSCFeedAPIManager retrieveFeedWithMode:JSCDataRetrievalOperationModeNextPage
                                    Success:^(id result)
     {
         //TODO: success block
         [self.tableView didPaginate];
     }
                                    failure:^(NSError *error)
     {
         //TODO: failure block
         [self.tableView didPaginate];
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
    [self.tableView reloadData];
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
        
        _fetchedResultsController.delegate = self;
        
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
                                                                 ascending:NO];
    
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


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                   forIndexPath:indexPath];
            
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end
