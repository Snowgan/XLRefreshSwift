//
//  XLRefreshFooter.swift
//  Pods
//
//  Created by Jennifer on 15/4/2016.
//
//

import UIKit

public class XLRefreshFooter: UIView {
    
    private var scrollView: UIScrollView?
    
    private var textLabel: UILabel!
    
    private var actIndicator: UIActivityIndicatorView?
    
    var stateStr: String = "More..." {
        didSet {
            textLabel.text = stateStr
        }
    }
    
    var refreshAction: (() -> Void)?
    
    var status: XLRefreshStatus {
        didSet {
            switch status {
            case .Normal:
                textLabel.text = stateStr
            case .Refreshing:
                textLabel.hidden = true
                footerRefreshing()
            case .EndRefresh:
                actIndicator?.stopAnimating()
                textLabel.hidden = false
            default:
                break
            }
        }
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        
        status = .Normal
        
        super.init(frame: frame)
        
        self.frame.size.height = XLRefreshFooterHeight
        
        self.textLabel = UILabel()
        self.textLabel.textAlignment = .Center
        self.textLabel.text = stateStr
        self.addSubview(textLabel)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience public init(action: () -> Void) {
        self.init()
        self.refreshAction = action
    }
    
    // MARK: - UIView methods override
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.frame.size = frame.size
        
    }
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        
        super.willMoveToSuperview(newSuperview)
        
        if let superV = superview as? UIScrollView {
            superV.removeObserver(self, forKeyPath: XLContentOffsetPath)
            superV.removeObserver(self, forKeyPath: XLContentSizePath)
        }
        
        if let newView = newSuperview as? UIScrollView {
            
            frame.size.width = newView.frame.width
            frame.origin.x = 0
            
            scrollView = newView
            
            scrollView?.contentInset.bottom += frame.height
            
            scrollView?.addObserver(self, forKeyPath: XLContentOffsetPath, options: [.New, .Old], context: nil)
            scrollView?.addObserver(self, forKeyPath: XLContentSizePath, options: [.New, .Old], context: nil)
            
        }
    }
    
    // MARK: - KVO
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let scrollContentH = scrollView!.contentSize.height
        let visualH = scrollContentH + scrollView!.contentInset.top + scrollView!.contentInset.bottom
        
        if keyPath == XLContentSizePath {
            
            frame.size.width = scrollView!.frame.width
            
            if visualH  < scrollView!.frame.height {
                frame.origin.y = scrollView!.frame.height - scrollView!.contentInset.bottom
            } else {
                frame.origin.y = scrollView!.contentSize.height
            }
            
        }
        
        if keyPath == XLContentOffsetPath {
            
            if status == .EndRefresh {
                status = .Normal
            }
            
            guard status == .Normal else {
                return
            }
            
            let curOffset = change!["new"]?.CGPointValue()
            let curOffsetY = curOffset == nil ? 0 : curOffset!.y
            var pullLen = curOffsetY + scrollView!.frame.height - scrollContentH
            
            if visualH  < scrollView!.frame.height {
                pullLen = curOffsetY + scrollView!.contentInset.top + scrollView!.contentInset.bottom
                if pullLen > scrollView!.contentInset.bottom {
                    status = .Refreshing
                }
            } else {
                if pullLen > -40 {
                    status = .Refreshing
                }
            }
        }
        
    }
    
    // MARK: - Customed refresh action
    func footerRefreshing() {
        if actIndicator == nil {
            actIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            actIndicator!.frame = bounds
            addSubview(actIndicator!)
        }
        
        actIndicator!.startAnimating()
        
        refreshAction?()
    }
    
    func endRefresh() {
        status = .EndRefresh
    }
    
}
