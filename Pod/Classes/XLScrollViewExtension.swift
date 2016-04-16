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
        static var XLHeader = "XLRefreshHeaderKey"
        static var XLFooter = "XLRefreshFooterKey"
    }
    
    public var xlheader: XLRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.XLHeader) as? XLRefreshHeader
        }
        set {
            if let oldValue = self.xlheader {
                oldValue.removeFromSuperview()
            }
            
            if let newValue = newValue {
                self.addSubview(newValue)
            }
            objc_setAssociatedObject(self, &AssociatedKeys.XLHeader, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
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
    
    public func endHeaderRefresh() {
        self.xlheader?.endRefresh()
    }

    public func endFooterRefresh() {
        self.xlfooter?.endRefresh()
    }
}