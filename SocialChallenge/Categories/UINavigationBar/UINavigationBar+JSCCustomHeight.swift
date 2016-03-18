//
//  UINavigationBar+JSCCustomHeight.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 18/03/2016.
//
//

import Foundation
import UIKit

var AssociatedObjectHandle: UInt8 = 0
/**
constant for the height.
*/
let kJSCHeightKey: String = "Height"

extension UINavigationBar {
    
    var height: CGFloat {
        
        get {
            
            if let unwrappedHeight = objc_getAssociatedObject(self, &AssociatedObjectHandle)
            {
                return unwrappedHeight as! CGFloat
            }
            else {
                
                return 0.0
            }
        }
        set {
            
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /**
     Sets the height of the Navigation Bar.
     
     @param height the height.
     */
    func jsc_setHeight(height: CGFloat) {
        
        self.height = height
    }
    
    //MARK: System
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        
        var newSize: CGSize = super.sizeThatFits(size)
        
        if (height > 0)
        {
            newSize = CGSizeMake(newSize.width, height)
        }
        
        return newSize
    }
    
}