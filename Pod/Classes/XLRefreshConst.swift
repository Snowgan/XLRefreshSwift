//
//  XLRefreshConst.swift
//  Pods
//
//  Created by Jennifer on 14/4/2016.
//
//

enum XLRefreshStatus: Int {
    case Normal
    case WillRefresh
    case Refreshing
    case EndRefresh
}

let XLStateMap = ["\(XLRefreshStatus.Normal)": "Pull down",
                  "\(XLRefreshStatus.WillRefresh)": "Release",
                  "\(XLRefreshStatus.Refreshing)": "Loading",
                  "\(XLRefreshStatus.EndRefresh)": "Pull down"]

let XLRefreshHeaderHeight: CGFloat = 44
let XLRefreshFooterHeight: CGFloat = 40

let XLContentOffsetPath = "contentOffset"
let XLContentSizePath = "contentSize"
