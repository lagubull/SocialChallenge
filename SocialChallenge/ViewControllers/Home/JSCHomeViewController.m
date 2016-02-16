//
//  JSCHomeViewController.m
//  SocialChallenge
//
//  Created by Javier Laguna on 02/08/2015.
//
//

#import "JSCHomeViewController.h"

#import "JSCHomeAdapter.h"

static const CGFloat kJSCNavigationBarHeight = 44.0f;

@interface JSCHomeViewController () <JSCHomeAdapterDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JSCHomeAdapter *adapter;

@end

@implementation JSCHomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
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

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,
                                                                   kJSCNavigationBarHeight,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - kJSCNavigationBarHeight)];
        
        _tableView.backgroundColor = [UIColor lightGrayColor];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
    }
    
    return _tableView;
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