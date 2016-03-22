//
//  JSCHomeAdapter.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 12/03/2016.
//
//

import Foundation

import SimpleTableView
import CoreDataServices

/**
 Methods from the adapter.
 */
protocol JSCHomeAdapterDelegate {
    
    /**
     User pressed on the favorites button.
     
     - Parameter post - post cell is showing.
     */
    func didPressFavoritesButton(post: JSCPost)
    
    /**
     User pressed on the comments button.
     
     - Parameter post - post cell is showing.
     */
    func didPressCommentsButton(post: JSCPost)
}

/**
 Manages the tableview for the HomeViewController.
*/
class JSCHomeAdapter: NSObject, UITableViewDataSource, UITableViewDelegate, STVDataRetrievalTableViewDelegate, JSCPostTableViewCellDelegate {
    
    /**
     Delegate of the HSCHomeAdapterDelegate protocol.
     */
    var delegate: JSCHomeAdapterDelegate?
    
    //MARK: Init
    
    override init() {
        
        super.init()
    }
    
    //MARK: TableView
    
    /**
    Shows the content.
    */
    var tableView: STVSimpleTableView? {
        
        didSet {
            
            self.tableView!.dataSource = self
            self.tableView!.delegate = self
            self.tableView!.dataRetrievalDelegate = self
            self.tableView!.fetchedResultsController = self.fetchedResultsController
            
            self.tableView!.registerClass(JSCPostTableViewCell.self, forCellReuseIdentifier: JSCPostTableViewCell.reuseIdentifier())
        }
    }
    
    //MARK: FetchedResultsController
    
    /**
    Fetch request for retrieving posts.
    */
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let _fetchedResultsController = NSFetchedResultsController.init(fetchRequest: self.fetchRequest, managedObjectContext: CDSServiceManager.sharedInstance().mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            
            try _fetchedResultsController.performFetch()
        }
        catch {
            
            let nserror = error as NSError
            
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController
    }()
    
    /**
     Used to connect the TableView with Core Data.
     */
    lazy var fetchRequest: NSFetchRequest = {
        
        let _fetchRequest = NSFetchRequest.init()
        
        _fetchRequest.entity = NSEntityDescription.cds_entityForClass(JSCPost.self, inManagedObjectContext: CDSServiceManager.sharedInstance().mainManagedObjectContext)
        
        _fetchRequest.sortDescriptors = self.sortDescriptorsForFetchRequest
        
        return _fetchRequest
    }()
    
    lazy var sortDescriptorsForFetchRequest: Array <NSSortDescriptor> = {
        
        var postIdSort : NSSortDescriptor = NSSortDescriptor.init(key: "postId", ascending: false)
        
        return [postIdSort];
    }()
    
    //MARK: JSCHomeAdapterDelegate
    
    /**
    Requests and updates the content.
    */
    func refresh() {
        
        JSCFeedAPIManager.retrieveFeedWithMode(JSCDataRetrievalOperationMode.FirstPage, success: { [weak self] (result: AnyObject?) in
            
            let hasContent = self!.fetchedResultsController.fetchedObjects!.count > 0
            
            self!.tableView!.didRefreshWithContent(hasContent)
            self!.tableView!.reloadData()
            }, failure: { [weak self] (error: NSError?) in
                
                let hasContent = self!.fetchedResultsController.fetchedObjects!.count > 0
                
                self!.tableView!.didRefreshWithContent(hasContent)
            })
    }
    
    func paginate() {
        
        self.tableView!.willPaginate()
        
        JSCFeedAPIManager.retrieveFeedWithMode(JSCDataRetrievalOperationMode.NextPage, success: { [weak self] (result :AnyObject?) in
            
            self!.tableView!.didPaginate()
            }, failure: { [weak self] (error : NSError?) in
                
                self!.tableView!.didPaginate()
            })
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let fetchedRowsCount = self.fetchedResultsController.fetchedObjects!.count
        
        return fetchedRowsCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(JSCPostTableViewCell.reuseIdentifier(), forIndexPath: indexPath) as! JSCPostTableViewCell
        
        cell.delegate = self
        
        self.configureCell(cell, indexPath: indexPath)
        
        return cell;
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 220.0
    }
    
    //MARK: JSCPostTableViewCellDelegate
    
    func didPressCommentsButton(post: JSCPost) {
        
        self.delegate!.didPressCommentsButton(post)
    }
    
    func didPressFavoritesButton(post: JSCPost) {
        
        self.delegate!.didPressFavoritesButton(post)
    }
    
    //MARK: CDSTableViewFetchedResultsControllerDataDelegate
    
    func didUpdateItemAtIndexPath(indexPath: NSIndexPath) {
        
        self.configureCell(self.tableView!.cellForRowAtIndexPath(indexPath) as! JSCPostTableViewCell, indexPath: indexPath)
    }
    
    //MARK: CellSetup
    
    func configureCell(cell: JSCPostTableViewCell, indexPath: NSIndexPath) {
        
        let post = self.fetchedResultsController.fetchedObjects![indexPath.row] as! JSCPost
        
        cell.updateWithPost(post)
    }
}
