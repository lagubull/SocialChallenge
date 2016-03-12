//
//  JSCHomeViewController.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 12/03/2016.
//
//

import Foundation

import SimpleTableView
import EasyAlert

/**
Constant to define the height of the navigation bar.s
*/
let kJSCNavigationBarHeight = 44.0 as CGFloat

class JSCHomeViewController: UIViewController, JSCHomeAdapterDelegate {
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.jsc_setHeight(kJSCNavigationBarHeight)
        self.navigationController!.navigationBar.translucent = false
        self.navigationController!.navigationBar.barTintColor = .blueColor()
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.title = NSLocalizedString("postsTitle", comment: "")
        
        self.view.backgroundColor = .blueColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.view.addSubview(self.tableView)
        
        self.adapter.refresh()
    }
    
    //MARK: Subviews
    
    /**
    Displays the posts.
    */
    lazy var tableView: STVSimpleTableView = {
        
        let _tableView = STVSimpleTableView.init(frame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height))
        
        _tableView.backgroundColor = .lightGrayColor()
        
        _tableView.separatorStyle = .None
        _tableView.allowsSelection = false
        _tableView.paginatingView = self.paginatingView
        _tableView.loadingView = self.loadingView
        _tableView.emptyView = self.emptyView
        _tableView.paginationOffset = 5
        
        return _tableView
    }()
    
    /**
     Pagination content view to show the local user we are retrieving fresh data.
     */
    lazy var paginatingView: STVPaginatingView = {
        
        let _paginatingView = STVPaginatingView.init(frame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, kSTVPaginatingViewHeight))
        
        _paginatingView.loadingLabel.text = NSLocalizedString("LoadingMessage", comment: "")
        
        return _paginatingView
    }()
    
    /**
     View to show when no data is available.
     */
    lazy var emptyView: JSCEmptyView = {
        
        let _emptyView = JSCEmptyView.init(frame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height))
        
        _emptyView.messageLabel.text = NSLocalizedString("NoContentBody", comment: "")
        
        return _emptyView
    }()
    
    /**
     View to show while data is being loaded.
     */
    lazy var loadingView: JSCLoadingView = {
        
        let _loadingView = JSCLoadingView.init(frame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height))
        
        return _loadingView
    }()
    
    //MARK: Getters
    
    /**
    Handles the tableView.
    */
    lazy var adapter: JSCHomeAdapter = {
        
        let _adapter = JSCHomeAdapter.init()
        
        _adapter.delegate = self
        _adapter.tableView = self.tableView
        
        return _adapter
    }()
    
    //MARK: JSCHomeAdapterDelegate
    
    func didPressCommentsButton(post: JSCPost)
    {
        LEAAlertController.dismissibleAlertViewWithTitle(NSLocalizedString("CommentsMessageTitle", comment: ""), message: NSLocalizedString("CommentsMessageBody", comment: ""), cancelButtonTitle: NSLocalizedString("AcceptNav", comment: "")).showInViewController(self)
    }
    
    func didPressFavoritesButton(post: JSCPost) {
        
        LEAAlertController.dismissibleAlertViewWithTitle(NSLocalizedString("FavoritesMessageTitle", comment: ""), message: NSLocalizedString("FavoritesMessageBody", comment: ""),
            cancelButtonTitle: NSLocalizedString("AcceptNav", comment: "")).showInViewController(self)
    }
}
