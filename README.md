# XLRefreshSwift

[![Version](https://img.shields.io/cocoapods/v/XLRefreshSwift.svg?style=flat)](http://cocoapods.org/pods/XLRefreshSwift)
[![License](https://img.shields.io/cocoapods/l/XLRefreshSwift.svg?style=flat)](http://cocoapods.org/pods/XLRefreshSwift)
[![Platform](https://img.shields.io/cocoapods/p/XLRefreshSwift.svg?style=flat)](http://cocoapods.org/pods/XLRefreshSwift)

XLRefreshSwift give you an easy way to add pull-to-refresh in UIScrollView.

## Installation

XLRefreshSwift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XLRefreshSwift', '~> 0.2.0'
```
## Usage

### Pull-to-refresh Header

Adding pull-to-refresh header to a subclass of UIScrollView by setting its **xlheader** property.
You can customize the refresh action when initialize a XLRefreshHeader object.

```Swift
tableView.xlheader = XLRefreshHeader(action: {
    // Put anything you want to do when refreshing
    // Please call UIScrollView's method endHeaderRefresh() when you want to end refreshing status
})
```

### Pull-to-load-more Footer

Adding pull-to-load-more footer to a subclass of UIScrollView by setting its **xlfooter** property.
You can customize the load more action when initialize a XLRefreshFooter object.

```Swift
tableView.xlfooter = XLRefreshFooter(action: {
    // Put anything you want to do when loading
    // Please call UIScrollView's method endFooterRefresh() when you want to end loading status
})
```

## Author

Snowgan, jennifergan@163.com

## License

XLRefreshSwift is available under the MIT license. See the LICENSE file for more info.
