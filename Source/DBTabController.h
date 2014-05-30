/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
@class DBTabBar;
@class DBTab;

@interface DBTabController : NSObject
{
	NSMutableArray*	tabs;
	NSTabView*		tabView;
	DBTabBar*			tabBar;

	CGFloat			tabWidth;
}
@property (nonatomic, strong) 	WebView*		defaultWebView;

- (id) initWithTabBar: (DBTabBar*) bar tabView: (NSTabView*) view;
- (void) tabClicked: (NSNotification*) notification;
- (void) tabWantsToClosed:(NSNotification *)notification;
- (void) slideWindowResized: (NSNotification*) notification;
- (void) newTabWithWebView: (WebView*) webView select: (BOOL) selectNewTab;
- (void) newTabWithWebView: (WebView*) webView select: (BOOL) selectNewTab URLString:(NSS*) URLString;
- (void) removeTab: (DBTab*) tab redraw: (BOOL) redraw resize: (BOOL) resize;
- (void) removeAllTabs;
- (void) updateTabSize;
- (BOOL) canFitMoreTabs;
- (void) selectTab:(DBTab *)aTab refresh: (BOOL) refresh;
- (void) selectTabRight;
- (void) selectTabLeft;
- (DBTab *)selectedTab;
- (DBTab*) tabWithWebView: (WebView*) webView;
- (WebView *)defaultWebView;
- (void)setDefaultWebView:(WebView *)aWebView;
- (DBTabBar *)tabBar;
- (NSI)tabCount;
- (void)reloadTab;
- (void)reloadAllTabs;
- (void) frameDidChange;
@end
