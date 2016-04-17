//
//  XLRefreshHeader.swift
//  Pods
//
//  Created by Jennifer on 16/4/2016.
//
//

import UIKit

public class XLRefreshHeader: UIView {
    
    private var scrollView: UIScrollView?
    
    private var contentView: UIView!
    
    private var actIndicator: UIActivityIndicatorView!
    
    private var arrowView: UIImageView!
    
    private var textLabel: UILabel!
    
    public var stateMap: [String: String]? {
        didSet {
            if let state = stateMap?["\(status)"] {
                textLabel.text = state
            }
        }
    }
    
    var status: XLRefreshStatus {
        didSet {
            switch status {
            case .Normal:
                textLabel.text = stateMap?["Normal"] ?? XLStateMap["Normal"]
            case .WillRefresh:
                willRefresh()
            case .Refreshing:
                headerRefresh()
            case .EndRefresh:
                UIView.animateWithDuration(0.4, animations: {
                    self.scrollView?.contentInset.top -= XLRefreshHeaderHeight
                })
                textLabel.text = stateMap?["Normal"] ?? XLStateMap["Normal"]
                actIndicator.stopAnimating()
                arrowView.transform = CGAffineTransformMakeRotation(CGFloat(0))
                arrowView.hidden = false
            }
        }
    }
    
    var refreshAction: (() -> Void)!
    
    // MARK: - Initializer
    override public init(frame: CGRect) {
        status = .Normal
        
        super.init(frame: frame)
        
        self.frame.size.height = XLRefreshHeaderHeight
        
        self.contentView = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 30))
        
        // Arrow
        let arrowV = UIImageView(image: imageWithName("arrow"))
        arrowV.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        arrowV.contentMode = .ScaleAspectFit
        self.arrowView = arrowV
        self.contentView.addSubview(arrowV)
        
        // Text Label
        let textL = UILabel(frame: CGRect(x: 30, y: 0, width: 100, height: 30))
        textL.textAlignment = .Left
        textL.text = XLStateMap["\(XLRefreshStatus.Normal)"]
        self.textLabel = textL
        self.contentView.addSubview(textL)
        
        self.addSubview(self.contentView)
        
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
        contentView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
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
            frame.origin.y = -XLRefreshHeaderHeight - newView.contentInset.top
            
            scrollView = newView
            scrollView?.alwaysBounceVertical = true
            
            scrollView?.addObserver(self, forKeyPath: XLContentOffsetPath, options: [.New, .Old], context: nil)
            scrollView?.addObserver(self, forKeyPath: XLContentSizePath, options: [.New, .Old], context: nil)
            
        }
    }
    
    // MARK: - KVO
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == XLContentSizePath {
            frame.size.width = scrollView!.frame.width
        }
        
        if keyPath == XLContentOffsetPath {
            
            if status == .EndRefresh {
                status = .Normal
            }
            
            guard status != .Refreshing else {
                return
            }
            
            let curOffset = change!["new"]!.CGPointValue()
            let releaseLen = scrollView!.contentInset.top + XLRefreshHeaderHeight
            
            if scrollView!.dragging && status == .Normal && curOffset.y < -releaseLen {
                status = .WillRefresh
            } else if status == .WillRefresh {
                let oldOffset = change!["old"]!.CGPointValue()
                if curOffset.y > oldOffset.y {
                    status = .Refreshing
                }
            }
        }
    }
    
    // MARK: - Customed refresh action
    func willRefresh() {
        textLabel.text = stateMap?["WillRefresh"] ?? XLStateMap["WillRefresh"]
        UIView.animateWithDuration(0.3) {
            self.arrowView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }
    }
    
    func headerRefresh() {
        scrollView?.contentInset.top += XLRefreshHeaderHeight
        arrowView.hidden = true
        textLabel.text = stateMap?["Refreshing"] ?? XLStateMap["Refreshing"]
        if actIndicator == nil {
            actIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            actIndicator.frame = CGRectMake(0, 0, 30, 30)
            contentView.addSubview(actIndicator)
        }
        
        actIndicator.startAnimating()
        refreshAction?()
    }
    
    func endRefresh() {
        status = .EndRefresh
    }
    
    // MARK: - Get resource in self resource bundle
    func imageWithName(name: String) -> UIImage? {
        var img: UIImage?
        let fwBundle = NSBundle(forClass: XLRefreshHeader.self)
        if let resBundlePath = fwBundle.pathForResource("XLRefreshSwift", ofType: "bundle") {
            if let resBundle = NSBundle(path: resBundlePath) {
                img = UIImage(named: name, inBundle: resBundle, compatibleWithTraitCollection: nil)
            }
        }
        return img
    }
}