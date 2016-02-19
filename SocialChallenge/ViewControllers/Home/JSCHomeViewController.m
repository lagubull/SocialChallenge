//
//  JSCHomeViewController.m
//  SocialChallenge
//
//  Created by Javier Laguna on 02/08/2015.
//
//

#import "JSCHomeViewController.h"

#import "JSCHomeAdapter.h"
#import "JSCTableView.h"
#import "JSCPaginatingView.h"

static const CGFloat kJSCNavigationBarHeight = 44.0f;

@interface JSCHomeViewController () <JSCHomeAdapterDelegate>

/**
 Displays the posts.
 */
@property (nonatomic, strong) JSCTableView *tableView;

/**
 Handles the tableView.
 */
@property (nonatomic, strong) JSCHomeAdapter *adapter;

/**
 Pagination content view to show the local user we are retrieving fresh data.
 */
@property (nonatomic, strong) JSCPaginatingView *paginatingView;

@end

@implementation JSCHomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.adapter.tableView = self.tableView;
    self.adapter.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    [self.adapter refresh];
}

#pragma mark - Subviews

- (JSCTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[JSCTableView alloc] initWithFrame:CGRectMake(0.0f,
                                                                   kJSCNavigationBarHeight,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - kJSCNavigationBarHeight)];
        
        _tableView.backgroundColor = [UIColor lightGrayColor];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.paginatingView = self.paginatingView;
    }
    
    return _tableView;
}

- (JSCPaginatingView *)paginatingView
{
    if (!_paginatingView)
    {
        _paginatingView = [[JSCPaginatingView alloc] initWithFrame:CGRectMake(0.0f,
                                                                              0.0f,
                                                                              self.view.bounds.size.width,
                                                                              kJSCPaginatingViewHeight)];
        
        _paginatingView.loadingLabel.text = NSLocalizedString(@"Loading", nil);
    }
    
    return _paginatingView;
}

#pragma mark - Getters

- (JSCHomeAdapter *)adapter
{
    if (!_adapter)
    {
        _adapter = [[JSCHomeAdapter alloc] init];
    }
    
    return _adapter;
}

@end
