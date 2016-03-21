//
//  JSCRootNavigationController.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 15/03/2016.
//
//

import Foundation
import UIKit

/**
 Handles the navigation in the app.
*/
class JSCRootNavigationController: UINavigationController, UINavigationControllerDelegate {

    var homeViewController: JSCHomeViewController?
    
    //MARK: Init
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        
        self.init(rootViewController: JSCHomeViewController.init())
        
        self.delegate = self
    }
    
    override init(rootViewController: UIViewController) {
        
        super.init(rootViewController: rootViewController)
        
        self.homeViewController = rootViewController as? JSCHomeViewController;
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
