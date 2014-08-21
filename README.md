UIViewController+Insets
===========

`UIViewController+Insets` is an iOS category for `UIViewController` that calculates layout insets for a view inside a view controller obstructed by translucent bars.

It looks up the view controller hierarchy, so it will also determine insets for a child view controller that is obstructed by a translucent navigation or tab bar from a parent view controller.

![image](Images/hero.png?raw=true)

Usage
-----

Inside your view controller, simply call the `insetsForView:` method with the view you want to get insets for.

It's recommended to do this in the `viewWillLayoutSubviews:` method.

    //	'self' is a UIViewController
    const UIEdgeInsets insets = [self insetsForView:self.scrollView];
    self.scrollView.contentInset = insets;

Details
-----

`UIViewController+Insets` is compatible with both iOS 6 and iOS 7.