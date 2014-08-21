//
//  This is free and unencumbered software released into the public domain.
//
//  Anyone is free to copy, modify, publish, use, compile, sell, or
//  distribute this software, either in source code form or as a compiled
//  binary, for any purpose, commercial or non-commercial, and by any
//  means.
//
//  In jurisdictions that recognize copyright laws, the author or authors
//  of this software dedicate any and all copyright interest in the
//  software to the public domain. We make this dedication for the benefit
//  of the public at large and to the detriment of our heirs and
//  successors. We intend this dedication to be an overt act of
//  relinquishment in perpetuity of all present and future rights to this
//  software under copyright law.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  For more information, please refer to <http://unlicense.org/>
//

#import <SenTestingKit/SenTestingKit.h>

#import "VCViewController.h"
#import "VCView.h"
#import "UIViewController+Insets.h"

#define ValueiOS6_7(ios6, ios7) (([UIDevice currentDevice].systemVersion.integerValue >= 7) ? ios7 : ios6)

@interface VCBaseTests : SenTestCase
{
	UIWindow* mainWindow;
}

- (void) pause:(NSTimeInterval) seconds;
- (void) pauseStandard;

@end

@implementation VCBaseTests

#pragma mark -
#pragma mark Super

- (void) setUp
{
	[super setUp];
	
	mainWindow = [UIApplication sharedApplication].keyWindow;
}

- (void) performTest:(SenTestRun *) aRun
{
	[super performTest:aRun];
	
	//	Visually show each test
	[self pauseStandard];
}

#pragma mark -
#pragma mark Private

- (void) pause:(NSTimeInterval) seconds
{
	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:seconds]];
}

- (void) pauseStandard
{
	[self pause:0.15];
}

#pragma mark -
#pragma mark Tests

- (void) test_UIViewControllerView
{
	VCViewController* controller = [[VCViewController alloc] init];
	
	//	Insets before the view controller is presented
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:controller.view], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	
	[mainWindow setRootViewController:controller];
	
	//	Insets after the view controller is presented
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:controller.view], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength), 0, 0, 0)), @"Top view should be inset by full layout guides");
}

- (void) test_UIViewControllerSubview
{
	VCViewController* controller = [[VCViewController alloc] init];
	
	VCView* viewAtTop = [[VCView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[controller.view addSubview:viewAtTop];
	
	VCView* viewBetweenInset = [[VCView alloc] initWithFrame:CGRectMake(110, 5, 100, 100)];
	[controller.view addSubview:viewBetweenInset];
	
	VCView* viewInsetFromTop = [[VCView alloc] initWithFrame:CGRectMake(220, 80, 100, 100)];
	[controller.view addSubview:viewInsetFromTop];
	
	//	Insets before the view controller is presented
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTop], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInset], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTop], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	
	[mainWindow setRootViewController:controller];
	
	//	Insets after the view controller is presented
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTop], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength), 0, 0, 0)), @"Top view should be inset by full layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInset], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength - 5), 0, 0, 0)), @"View between inset should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTop], UIEdgeInsetsMake(0, 0, 0, 0)), @"View inset a lot from the top should not be inset by any layout guides");
}

- (void) test_UIViewControllerSubviewSubview
{
	VCViewController* controller = [[VCViewController alloc] init];
	
	VCView* viewAtTop = [[VCView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	VCView* viewAtTopSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewAtTop];
	[viewAtTop addSubview:viewAtTopSubview];
	
	VCView* viewBetweenInset = [[VCView alloc] initWithFrame:CGRectMake(110, 5, 100, 100)];
	VCView* viewBetweenInsetSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewBetweenInset];
	[viewBetweenInset addSubview:viewBetweenInsetSubview];
	
	VCView* viewInsetFromTop = [[VCView alloc] initWithFrame:CGRectMake(220, 80, 100, 100)];
	VCView* viewInsetFromTopSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 30, 100, 100)];
	[controller.view addSubview:viewInsetFromTop];
	[viewInsetFromTop addSubview:viewInsetFromTopSubview];
	
	//	Insets before the view controller is presented, should all be 0
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	
	[mainWindow setRootViewController:controller];
	
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTopSubview], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength - 5), 0, 0, 0)), @"Top view should be inset by full layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength - 10), 0, 0, 0)), @"View between inset should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"View inset a lot from the top should not be inset by any layout guides");
}

- (void) test_UINavigationControllerView
{
	VCViewController* controller = [[VCViewController alloc] init];
	UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:controller];
	
	//	Insets before the view controller is presented
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:controller.view], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	
	[mainWindow setRootViewController:navigation];
	
	//	Insets after the view controller is presented
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:controller.view], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength), 0, 0, 0)), @"Top view should be inset by full layout guides");
}

- (void) test_UINavigationControllerSubview
{
	VCViewController* controller = [[VCViewController alloc] init];
	UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:controller];
	
	VCView* viewAtTop = [[VCView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[controller.view addSubview:viewAtTop];
	
	VCView* viewBetweenInset = [[VCView alloc] initWithFrame:CGRectMake(110, 40, 100, 100)];
	[controller.view addSubview:viewBetweenInset];
	
	VCView* viewInsetFromTop = [[VCView alloc] initWithFrame:CGRectMake(220, 80, 100, 100)];
	[controller.view addSubview:viewInsetFromTop];
	
	UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:controller.view.bounds];
	[scroll setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	[controller.view addSubview:scroll];
	[scroll setBackgroundColor:[UIColor greenColor]];
	
	//	Insets before the view controller is presented
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTop], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInset], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTop], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	
	[mainWindow setRootViewController:navigation];
	
	//	Insets after the view controller is presented
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTop], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength), 0, 0, 0)), @"Top view should be inset by full layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInset], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength - 40), 0, 0, 0)), @"View between inset should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTop], UIEdgeInsetsMake(0, 0, 0, 0)), @"View inset a lot from the top should not be inset by any layout guides");
	
	const UIEdgeInsets scrollInset = [controller insetsForView:scroll];
	[scroll setContentInset:scrollInset];
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:scroll], scrollInset), @"Insets on scroll views should be the same as before setting them");
}

- (void) test_UINavigationControllerSubviewSubview
{
	VCViewController* controller = [[VCViewController alloc] init];
	UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:controller];
	
	VCView* viewAtTop = [[VCView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	VCView* viewAtTopSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewAtTop];
	[viewAtTop addSubview:viewAtTopSubview];
	
	VCView* viewBetweenInset = [[VCView alloc] initWithFrame:CGRectMake(110, 5, 100, 100)];
	VCView* viewBetweenInsetSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewBetweenInset];
	[viewBetweenInset addSubview:viewBetweenInsetSubview];
	
	VCView* viewInsetFromTop = [[VCView alloc] initWithFrame:CGRectMake(220, 80, 100, 100)];
	VCView* viewInsetFromTopSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 30, 100, 100)];
	[controller.view addSubview:viewInsetFromTop];
	[viewInsetFromTop addSubview:viewInsetFromTopSubview];
	
	//	Insets before the view controller is presented, should all be 0
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	
	[mainWindow setRootViewController:navigation];
	
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTopSubview], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength - 5), 0, 0, 0)), @"Top view should be inset by full layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength - 10), 0, 0, 0)), @"View between inset should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"View inset a lot from the top should not be inset by any layout guides");
}

- (void) test_UINavigationControllerSubviewSubviewHiddenBars
{
	VCViewController* controller = [[VCViewController alloc] init];
	UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:controller];
	[navigation setNavigationBarHidden:YES];
	[navigation setToolbarHidden:YES];
	
	VCView* viewAtTop = [[VCView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	VCView* viewAtTopSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewAtTop];
	[viewAtTop addSubview:viewAtTopSubview];
	
	VCView* viewBetweenInset = [[VCView alloc] initWithFrame:CGRectMake(110, 5, 100, 100)];
	VCView* viewBetweenInsetSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewBetweenInset];
	[viewBetweenInset addSubview:viewBetweenInsetSubview];
	
	VCView* viewInsetFromTop = [[VCView alloc] initWithFrame:CGRectMake(220, 80, 100, 100)];
	VCView* viewInsetFromTopSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 30, 100, 100)];
	[controller.view addSubview:viewInsetFromTop];
	[viewInsetFromTop addSubview:viewInsetFromTopSubview];
	
	//	Insets before the view controller is presented, should all be 0
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	
	[mainWindow setRootViewController:navigation];
	
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTopSubview], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength - 5), 0, 0, 0)), @"Top view should be inset by full layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength - 10), 0, 0, 0)), @"View between inset should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"View inset a lot from the top should not be inset by any layout guides");
}

- (void) test_UIPopoverControllerSubviewSubview
{
	if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
		return;
	
	VCViewController* rootController = [[VCViewController alloc] init];
	[mainWindow setRootViewController:rootController];
	
	VCViewController* controller = [[VCViewController alloc] init];
	UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController:controller];
	
	VCView* viewAtTop = [[VCView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	VCView* viewAtTopSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewAtTop];
	[viewAtTop addSubview:viewAtTopSubview];
	
	VCView* viewBetweenInset = [[VCView alloc] initWithFrame:CGRectMake(110, 5, 100, 100)];
	VCView* viewBetweenInsetSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewBetweenInset];
	[viewBetweenInset addSubview:viewBetweenInsetSubview];
	
	VCView* viewInsetFromTop = [[VCView alloc] initWithFrame:CGRectMake(220, 80, 100, 100)];
	VCView* viewInsetFromTopSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 30, 100, 100)];
	[controller.view addSubview:viewInsetFromTop];
	[viewInsetFromTop addSubview:viewInsetFromTopSubview];
	
	//	Insets before the view controller is presented, should all be 0
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	
	[popover presentPopoverFromRect:CGRectMake(100, 100, 100, 100) inView:mainWindow permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
	
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Top view should be inset by full layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"View between inset should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"View inset a lot from the top should not be inset by any layout guides");
	
	[self pauseStandard];
	
	[popover dismissPopoverAnimated:NO];
}

- (void) test_UIPopoverControllerUINavigationControllerNoBarSubviewSubview
{
	if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
		return;
	
	VCViewController* rootController = [[VCViewController alloc] init];
	[mainWindow setRootViewController:rootController];
	
	VCViewController* controller = [[VCViewController alloc] init];
	UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:controller];
	UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController:navigation];
	
	VCView* viewAtTop = [[VCView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	VCView* viewAtTopSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewAtTop];
	[viewAtTop addSubview:viewAtTopSubview];
	
	VCView* viewBetweenInset = [[VCView alloc] initWithFrame:CGRectMake(110, 5, 100, 100)];
	VCView* viewBetweenInsetSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewBetweenInset];
	[viewBetweenInset addSubview:viewBetweenInsetSubview];
	
	VCView* viewInsetFromTop = [[VCView alloc] initWithFrame:CGRectMake(220, 80, 100, 100)];
	VCView* viewInsetFromTopSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 30, 100, 100)];
	[controller.view addSubview:viewInsetFromTop];
	[viewInsetFromTop addSubview:viewInsetFromTopSubview];
	
	//	Insets before the view controller is presented, should all be 0
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	
	[popover presentPopoverFromRect:CGRectMake(100, 100, 100, 100) inView:mainWindow permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
	
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Top view should be inset by full layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"View between inset should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"View inset a lot from the top should not be inset by any layout guides");
	
	[self pauseStandard];
	
	[popover dismissPopoverAnimated:NO];
}

- (void) test_UIPopoverControllerUINavigationControllerWithBarSubviewSubview
{
	if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
		return;
	
	VCViewController* rootController = [[VCViewController alloc] init];
	[mainWindow setRootViewController:rootController];
	
	VCViewController* controller = [[VCViewController alloc] init];
	UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:controller];
	UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController:navigation];
	
	navigation.navigationBar.barStyle = UIBarStyleBlack;
	if([navigation.navigationBar respondsToSelector:@selector(setBarTintColor:)])
		[navigation.navigationBar setBarTintColor:[UIColor whiteColor]];
	
	VCView* viewAtTop = [[VCView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	VCView* viewAtTopSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewAtTop];
	[viewAtTop addSubview:viewAtTopSubview];
	
	VCView* viewBetweenInset = [[VCView alloc] initWithFrame:CGRectMake(110, 5, 100, 100)];
	VCView* viewBetweenInsetSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewBetweenInset];
	[viewBetweenInset addSubview:viewBetweenInsetSubview];
	
	VCView* viewInsetFromTop = [[VCView alloc] initWithFrame:CGRectMake(220, 80, 100, 100)];
	VCView* viewInsetFromTopSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 30, 100, 100)];
	[controller.view addSubview:viewInsetFromTop];
	[viewInsetFromTop addSubview:viewInsetFromTopSubview];
	
	//	Insets before the view controller is presented, should all be 0
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	
	[popover presentPopoverFromRect:CGRectMake(100, 100, 100, 100) inView:mainWindow permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
	
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTopSubview], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength - 5), 0, 0, 0)), @"Top view should be inset by full layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength - 10), 0, 0, 0)), @"View between inset should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTopSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"View inset a lot from the top should not be inset by any layout guides");
	
	[self pauseStandard];
	
	[popover dismissPopoverAnimated:NO];
}

- (void) test_UIViewControllerNested
{
	VCViewController* rootController = [[VCViewController alloc] init];
	
	VCViewController* nestedRootChildController = [[VCViewController alloc] init];
	[nestedRootChildController willMoveToParentViewController:rootController];
	[nestedRootChildController.view setFrame:CGRectMake(0, 0, 50, 100)];
	[rootController.view addSubview:nestedRootChildController.view];
	[rootController addChildViewController:nestedRootChildController];
	[nestedRootChildController didMoveToParentViewController:rootController];
	
	VCViewController* nestedRootChildChildController = [[VCViewController alloc] init];
	[nestedRootChildChildController willMoveToParentViewController:nestedRootChildController];
	[nestedRootChildChildController.view setFrame:CGRectMake(0, 10, 50, 100)];
	[nestedRootChildController.view addSubview:nestedRootChildChildController.view];
	[nestedRootChildController addChildViewController:nestedRootChildChildController];
	[nestedRootChildChildController didMoveToParentViewController:nestedRootChildController];
	
	VCViewController* nestedRootInsetChildController = [[VCViewController alloc] init];
	[nestedRootInsetChildController willMoveToParentViewController:rootController];
	[nestedRootInsetChildController.view setFrame:CGRectMake(60, 5, 50, 100)];
	[rootController.view addSubview:nestedRootInsetChildController.view];
	[rootController addChildViewController:nestedRootInsetChildController];
	[nestedRootInsetChildController didMoveToParentViewController:rootController];
	
	VCViewController* nestedRootInsetChildChildController = [[VCViewController alloc] init];
	[nestedRootInsetChildChildController willMoveToParentViewController:nestedRootInsetChildController];
	[nestedRootInsetChildChildController.view setFrame:CGRectMake(0, 80, 50, 100)];
	[nestedRootInsetChildController.view addSubview:nestedRootInsetChildChildController.view];
	[nestedRootInsetChildController addChildViewController:nestedRootInsetChildChildController];
	[nestedRootInsetChildChildController didMoveToParentViewController:nestedRootInsetChildController];
	
	VCViewController* nestedTopNavigationViewController = [[VCViewController alloc] init];
	UINavigationController* nestedTopNavigationController = [[UINavigationController alloc] initWithRootViewController:nestedTopNavigationViewController];
	[nestedTopNavigationController willMoveToParentViewController:rootController];
	[nestedTopNavigationController.view setFrame:CGRectMake(130, 0, 50, 100)];
	[rootController.view addSubview:nestedTopNavigationController.view];
	[rootController addChildViewController:nestedTopNavigationController];
	[nestedTopNavigationController didMoveToParentViewController:rootController];
	
	VCViewController* nestedTopNavigationChildViewController = [[VCViewController alloc] init];
	[nestedTopNavigationChildViewController willMoveToParentViewController:nestedTopNavigationViewController];
	[nestedTopNavigationChildViewController.view setFrame:CGRectMake(0, 30, 50, 100)];
	[nestedTopNavigationViewController.view addSubview:nestedTopNavigationChildViewController.view];
	[nestedTopNavigationViewController addChildViewController:nestedTopNavigationChildViewController];
	[nestedTopNavigationChildViewController didMoveToParentViewController:nestedTopNavigationViewController];
	
	VCViewController* nestedInsetNavigationViewController = [[VCViewController alloc] init];
	UINavigationController* nestedInsetNavigationController = [[UINavigationController alloc] initWithRootViewController:nestedInsetNavigationViewController];
	[nestedInsetNavigationController willMoveToParentViewController:rootController];
	[nestedInsetNavigationController.view setFrame:CGRectMake(190, 10, 50, 100)];
	[rootController.view addSubview:nestedInsetNavigationController.view];
	[rootController addChildViewController:nestedInsetNavigationController];
	[nestedInsetNavigationController didMoveToParentViewController:rootController];
	
	VCViewController* nestedInsetNavigationChildViewController = [[VCViewController alloc] init];
	[nestedInsetNavigationChildViewController willMoveToParentViewController:nestedInsetNavigationViewController];
	[nestedInsetNavigationChildViewController.view setFrame:CGRectMake(0, 30, 50, 100)];
	[nestedInsetNavigationViewController.view addSubview:nestedInsetNavigationChildViewController.view];
	[nestedInsetNavigationViewController addChildViewController:nestedInsetNavigationChildViewController];
	[nestedInsetNavigationChildViewController didMoveToParentViewController:nestedInsetNavigationViewController];
	
	//	Insets before the view controller is presented, should all be 0
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedRootChildController insetsForView:nestedRootChildController.view], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedRootChildChildController insetsForView:nestedRootChildChildController.view], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedRootInsetChildController insetsForView:nestedRootInsetChildController.view], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedRootInsetChildChildController insetsForView:nestedRootInsetChildChildController.view], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedTopNavigationViewController insetsForView:nestedTopNavigationViewController.view], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedInsetNavigationViewController insetsForView:nestedInsetNavigationViewController.view], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedTopNavigationChildViewController insetsForView:nestedTopNavigationChildViewController.view], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedInsetNavigationChildViewController insetsForView:nestedInsetNavigationChildViewController.view], UIEdgeInsetsMake(0, 0, 0, 0)), @"Invalid");
	
	[mainWindow setRootViewController:rootController];
	
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedRootChildController insetsForView:nestedRootChildController.view], UIEdgeInsetsMake(ValueiOS6_7(0, rootController.topLayoutGuideLength), 0, 0, 0)), @"Nested controller should be inset by full layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedRootChildChildController insetsForView:nestedRootChildChildController.view], UIEdgeInsetsMake(ValueiOS6_7(0, rootController.topLayoutGuideLength - 10), 0, 0, 0)), @"Nested nested controller should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedRootInsetChildController insetsForView:nestedRootInsetChildController.view], UIEdgeInsetsMake(ValueiOS6_7(0, rootController.topLayoutGuideLength - 5), 0, 0, 0)), @"Nested controller should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedRootInsetChildChildController insetsForView:nestedRootInsetChildChildController.view], UIEdgeInsetsMake(0, 0, 0, 0)), @"View inset a lot from the top should not be inset by any layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedTopNavigationViewController insetsForView:nestedTopNavigationViewController.view], UIEdgeInsetsMake(ValueiOS6_7(0, rootController.topLayoutGuideLength + nestedTopNavigationController.navigationBar.frame.size.height), 0, 0, 0)), @"Navigation view inset should be height of navigation bar + status bar");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedTopNavigationChildViewController insetsForView:nestedTopNavigationChildViewController.view], UIEdgeInsetsMake(ValueiOS6_7(0, rootController.topLayoutGuideLength + nestedTopNavigationController.navigationBar.frame.size.height - 30), 0, 0, 0)), @"Navigation view inset should be height of navigation bar + status bar");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedInsetNavigationViewController insetsForView:nestedInsetNavigationViewController.view], UIEdgeInsetsMake(ValueiOS6_7(0, nestedTopNavigationController.navigationBar.frame.size.height), 0, 0, 0)), @"Navigation view inset should be height of navigation bar");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([nestedInsetNavigationChildViewController insetsForView:nestedInsetNavigationChildViewController.view], UIEdgeInsetsMake(ValueiOS6_7(0, nestedTopNavigationController.navigationBar.frame.size.height - 30), 0, 0, 0)), @"Navigation view inset should be height of navigation bar");
}

- (void) test_UINavigationControllerCustomRootControllerFrame
{
	VCViewController* controller = [[VCViewController alloc] init];
	UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:controller];
	
	[navigation.navigationBar setAlpha:0.5];
	[navigation.navigationBar setAlpha:0.5];
	[navigation.view setBackgroundColor:[UIColor greenColor]];
	
	VCView* viewAtTop = [[VCView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[controller.view addSubview:viewAtTop];
	
	VCView* viewBetweenInset = [[VCView alloc] initWithFrame:CGRectMake(110, 20, 100, 100)];
	VCView* viewBetweenInsetSubview = [[VCView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
	[controller.view addSubview:viewBetweenInset];
	[viewBetweenInset addSubview:viewBetweenInsetSubview];
	
	VCView* viewInsetFromTop = [[VCView alloc] initWithFrame:CGRectMake(220, 150, 100, 100)];
	[controller.view addSubview:viewInsetFromTop];
	
	[mainWindow setRootViewController:navigation];
	
	[controller.view setFrame:CGRectMake(0, -30, controller.view.frame.size.width, controller.view.frame.size.height)];
	
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:controller.view], UIEdgeInsetsMake(ValueiOS6_7(30, controller.topLayoutGuideLength + 30), 0, 0, 0)), @"Controller should be inset by excess origin");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtTop], UIEdgeInsetsMake(ValueiOS6_7(30, controller.topLayoutGuideLength + 30), 0, 0, 0)), @"Top view should be inset by full layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInset], UIEdgeInsetsMake(ValueiOS6_7(10, controller.topLayoutGuideLength - 10), 0, 0, 0)), @"View between inset should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(ValueiOS6_7(5, navigation.navigationBar.frame.size.height), 0, 0, 0)), @"View between inset should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromTop], UIEdgeInsetsMake(0, 0, 0, 0)), @"View inset a lot from the top should not be inset by any layout guides");
}

- (void) test_UITabBarControllerView
{
	VCViewController* controller = [[VCViewController alloc] init];
	UITabBarController* tabBar = [[UITabBarController alloc] init];
	[tabBar.tabBar setAlpha:0.9];
	[tabBar setViewControllers:@[controller]];
	
	[mainWindow setRootViewController:tabBar];
	
	//	Insets after the view controller is presented
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:controller.view], UIEdgeInsetsMake(ValueiOS6_7(0, controller.topLayoutGuideLength), 0, controller.bottomLayoutGuideLength, 0)), @"Top view should be inset by full layout guides");
}

- (void) test_UITabBarControllerSubview
{
	VCViewController* controller = [[VCViewController alloc] init];
	UITabBarController* tabBar = [[UITabBarController alloc] init];
	[tabBar.tabBar setAlpha:0.9];
	[tabBar setViewControllers:@[controller]];
	
	VCView* viewBelowBottom = [[VCView alloc] initWithFrame:CGRectMake(220, controller.view.frame.size.height - 100 + 30, 100, 100)];
	[viewBelowBottom setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin)];
	[controller.view addSubview:viewBelowBottom];
	
	VCView* viewAtBottom = [[VCView alloc] initWithFrame:CGRectMake(0, controller.view.frame.size.height - 100, 100, 100)];
	[viewAtBottom setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin)];
	[controller.view addSubview:viewAtBottom];
	
	VCView* viewBetweenInset = [[VCView alloc] initWithFrame:CGRectMake(110, controller.view.frame.size.height - 100 - 5, 100, 100)];
	[viewAtBottom setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin)];
	[controller.view addSubview:viewBetweenInset];
	
	VCView* viewInsetFromBottom = [[VCView alloc] initWithFrame:CGRectMake(220, controller.view.frame.size.height - 100 - 100, 100, 100)];
	[viewAtBottom setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin)];
	[controller.view addSubview:viewInsetFromBottom];
	
	[mainWindow setRootViewController:tabBar];
	
	//	Insets after the view controller is presented
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBelowBottom], UIEdgeInsetsMake(0, 0, controller.bottomLayoutGuideLength + ValueiOS6_7(0, 30), 0)), @"Bottom view should be inset by full layout guides plus excess");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtBottom], UIEdgeInsetsMake(0, 0, controller.bottomLayoutGuideLength, 0)), @"Bottom view should be inset by full layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInset], UIEdgeInsetsMake(0, 0, controller.bottomLayoutGuideLength - ValueiOS6_7(0, 5), 0)), @"View between inset should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromBottom], UIEdgeInsetsMake(0, 0, 0, 0)), @"View inset a lot from the bottom should not be inset by any layout guides");
}

- (void) test_UITabBarControllerSubviewSubview
{
	VCViewController* controller = [[VCViewController alloc] init];
	UITabBarController* tabBar = [[UITabBarController alloc] init];
	[tabBar.tabBar setAlpha:0.9];
	[tabBar setViewControllers:@[controller]];
	
	VCView* viewAtBottom = [[VCView alloc] initWithFrame:CGRectMake(0, controller.view.frame.size.height - 100, 100, 100)];
	VCView* viewAtBottomSubview = [[VCView alloc] initWithFrame:CGRectMake(0, -20, 100, 100)];
	[viewAtBottom setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin)];
	[controller.view addSubview:viewAtBottom];
	[viewAtBottom addSubview:viewAtBottomSubview];
	
	VCView* viewBetweenInset = [[VCView alloc] initWithFrame:CGRectMake(110, controller.view.frame.size.height - 100 - 5, 100, 100)];
	VCView* viewBetweenInsetSubview = [[VCView alloc] initWithFrame:CGRectMake(0, -20, 100, 100)];
	[viewAtBottom setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin)];
	[controller.view addSubview:viewBetweenInset];
	[viewBetweenInset addSubview:viewBetweenInsetSubview];
	
	VCView* viewInsetFromBottom = [[VCView alloc] initWithFrame:CGRectMake(220, controller.view.frame.size.height - 100 - 100, 100, 100)];
	VCView* viewInsetFromBottomSubview = [[VCView alloc] initWithFrame:CGRectMake(0, -20, 100, 100)];
	[viewAtBottom setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin)];
	[controller.view addSubview:viewInsetFromBottom];
	[viewInsetFromBottom addSubview:viewInsetFromBottomSubview];
	
	[mainWindow setRootViewController:tabBar];
	
	//	Insets after the view controller is presented
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewAtBottomSubview], UIEdgeInsetsMake(0, 0, controller.bottomLayoutGuideLength - ValueiOS6_7(0, 20), 0)), @"Bottom view should be inset by full layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewBetweenInsetSubview], UIEdgeInsetsMake(0, 0, controller.bottomLayoutGuideLength - ValueiOS6_7(0, 25), 0)), @"View between inset should be inset by partial layout guides");
	STAssertTrue(UIEdgeInsetsEqualToEdgeInsets([controller insetsForView:viewInsetFromBottomSubview], UIEdgeInsetsMake(0, 0, 0, 0)), @"View inset a lot from the bottom should not be inset by any layout guides");
}

@end