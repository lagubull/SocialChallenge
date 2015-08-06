//
//  JSCHomeAdapter.m
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

#import "JSCHomeAdapter.h"

#import "JSCCDSServiceManager.h"
#import "JSCPost.h"

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
}

#pragma mark - JSCHomeAdapterDelegate

- (void)refresh
{
    //Fetch content
}

- (void)paginate
{
    //fetch next page
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger fetchedRowsCount = [self.fetchedResultsController.fetchedObjects count];
    
    return fetchedRowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableViewDelegate

#pragma mark - FetchResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                        managedObjectContext:[[JSCCDSServiceManager sharedInstance] managedObjectContext]
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
                                      inManagedObjectContext:[[JSCCDSServiceManager sharedInstance] managedObjectContext]];
    
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
    NSSortDescriptor *postIdSort = [NSSortDescriptor sortDescriptorWithKey:@"postId"
                                                                 ascending:YES];
    
    return @[postIdSort];
}

@end
