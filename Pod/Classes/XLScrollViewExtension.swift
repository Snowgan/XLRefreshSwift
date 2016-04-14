//
//  XLScrollViewExtension.swift
//  Pods
//
//  Created by Jennifer on 14/4/2016.
//
//

import UIKit

extension UIScrollView {
    
    private struct AssociatedKeys {
        static var XLFooter = "XLRefreshFooterKey"
    }
    
    public var xlfooter: XLRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.XLFooter) as? XLRefreshFooter
        }
        set {
            if let oldValue = self.xlfooter {
                oldValue.removeFromSuperview()
            }
            
            if let newValue = newValue {
                self.addSubview(newValue)
            }
            objc_setAssociatedObject(self, &AssociatedKeys.XLFooter, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addFooterAction(action: () -> Void) {
        
    }
    
    func addFooter() {
        let footer = XLRefreshFooter()
        addSubview(footer)
    }
    
    public func endRefresh() {
        self.xlfooter?.endRefresh()
    }
}