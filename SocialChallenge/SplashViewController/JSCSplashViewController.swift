//
//  JSCSplashViewController.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 15/03/2016.
//
//

import Foundation

/**
 View controller to show on app start up.
*/
class JSCSplashViewController: UIViewController {
    
    //MARK: ViewLifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //TODO: show something meaningful
        self.view.backgroundColor = .blueColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //TODO: show something meaningful
        UIView.animateWithDuration(2.0, animations: {
            
            self.view.backgroundColor = .whiteColor()
            },
            completion: { (finished: Bool) in
                
                self.hide()
        })
    }
    
    //MARK: Hide
    
    /**
    Dissmises the view countroller
    */
    func hide() {
        
        let splashWindow = UIApplication.sharedApplication().delegate!.window as! JSCWindow
        
        splashWindow.hideSplashScreen()
        
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
}
