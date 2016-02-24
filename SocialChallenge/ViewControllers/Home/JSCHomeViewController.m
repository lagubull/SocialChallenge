//
//  JSCHomeViewController.m
//  SocialChallenge
//
//  Created by Javier Laguna on 02/08/2015.
//
//

#import "JSCHomeViewController.h"

#import <STVPaginatingView.h>
#import <STVSimpleTableView.h>

#import "JSCHomeAdapter.h"

static const CGFloat kJSCNavigationBarHeight = 44.0f;

@interface JSCHomeViewController () <JSCHomeAdapterDelegate>

/**
 Displays the posts.
 */
@property (nonatomic, strong) STVSimpleTableView *tableView;

/**
 Handles the tableView.
 */
@property (nonatomic, strong) JSCHomeAdapter *adapter;

/**
 Pagination content view to show the local user we are retrieving fresh data.
 */
@property (nonatomic, strong) STVPaginatingView *paginatingView;

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

- (STVSimpleTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[STVSimpleTableView alloc] initWithFrame:CGRectMake(0.0f,
                                                                          kJSCNavigationBarHeight,
                                                                          self.view.bounds.size.width,
                                                                          self.view.bounds.size.height - kJSCNavigationBarHeight)];
        
        _tableView.backgroundColor = [UIColor lightGrayColor];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.paginatingView = self.paginatingView;
        _tableView.paginationOffset = @(5);
    }
    
    return _tableView;
}

- (STVPaginatingView *)paginatingView
{
    if (!_paginatingView)
    {
        _paginatingView = [[STVPaginatingView alloc] initWithFrame:CGRectMake(0.0f,
                                                                              0.0f,
                                                                              self.view.bounds.size.width,
                                                                              kSTVPaginatingViewHeight)];
        
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
