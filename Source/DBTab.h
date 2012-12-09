/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
static NSImage*	selectedTabFill;
static NSImage*	selectedTabRight;
static NSImage*	selectedTabLeft;
static NSImage*	unselectedTabFill;
static NSImage*	unselectedTabRight;
static NSImage*	unselectedTabLeft;
static NSImage*	tabClose;
static NSImage*	tabCloseMouseOver;
static NSImage*	tabCloseMouseDown;
static BOOL		tabImagesInitialized;

@interface DBTab : NSView
{
	NSS*	label;
	BOOL		selected;
	BOOL		mouseOver;
	BOOL		mouseOverClose;
	BOOL		mouseDownClose;
	
	NSTrackingRectTag	trackingRectTag;
	
	// WebView information
	NSS*	URLString;
	NSS*	title;
	BOOL		loading;
}
@property (nonatomic, strong) NSS*	status;
@property (nonatomic, strong) NSImage*	favicon;


- (void) drawTabInRect: (NSR) rect;
- (void) drawCloseButtonInRect: (NSR) rect;
- (NSR) rectForCloseButton;
- (BOOL) pointInCloseButton: (NSP) point;
- (void) drawLabelInRect: (NSR) rect;
- (void) setLabel: (NSS*) newLabel;
- (void) setSelected: (BOOL) flag;
- (NSS*) label;
- (BOOL)selected;
- (void)sendCloseNotification;
- (void)closeAll;
- (void)reload;
- (void)reloadAll;
- (void) resetTrackingRect;
- (void) frameDidChange: (NSNotification*) notification;
// WebView information
- (void) setFavicon: (NSImage*) newFavicon;
- (NSImage*) favicon;
- (void) setStatus: (NSS*) newStatus;
- (NSS*) status;
- (void) setURLString: (NSS*) newURLString;
- (NSS*) URLString;
- (void) setTitle: (NSS*) newTitle;
- (NSS*) title;
- (void) setLoading: (BOOL) flag;
- (BOOL) loading;
@end
