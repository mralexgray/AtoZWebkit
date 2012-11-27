/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
/* DeskBrowseController */
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <IOKit/IOKitLib.h>
#import "DeskBrowseConstants.h"
#import "ThreadWorker.h"
#import <AtoZ/AtoZ.h>
#import <CoreLocation/CoreLocation.h>


@class 	DBApplication, DeskBrowseConstants, DBActionMenuView, DBActionMenuWindow, Authorizer, DBBookmarkBar, DBBookmarkController,
		DBBookmarkImportWindowController, DBBookmarkWindowController, DBDownloadController, DBHistoryController, DBHistoryWindowController,
		DBHotKeyController, DBLocationTextField, NSFileManagerSGSAdditions, NSWindowFade, DBPlistUtils, DBPreferenceController,
		DBQuickDownload, SearchEngineController, DBSlideWindow, DBTabController, DBTab, DBTabBar, DBURLFormatter,
		DBViewSourceWindowController, WebKitEx, DBWebsposeWindow, DBWindowLevel, DBStatusItemController, DBSymbolicHotKeyController;

@interface DeskBrowseController : NSObject <CLLocationManagerDelegate>
{
	// main browser components
	IBOutlet DBSlideWindow			*slideWindow; // the main window
	IBOutlet DBLocationTextField		*urlField; 	// the location text field
	IBOutlet DBBookmarkBar	*bookmarkBar;
	IBOutlet DBTabBar		*tabBar;
	IBOutlet NSSearchField	*searchField; // the google search field
	IBOutlet NSBox		*webViewBox;
	IBOutlet NSBox		*tabBarBox;
	IBOutlet NSTXTF		*statusField; 				// where the status text is shown
	IBOutlet NSTXTF	*titleField; // where the title of the page is displayed

	IBOutlet NSBUTT		*back;
	IBOutlet NSBUTT		*forward;
	IBOutlet NSBUTT		*stop;
	IBOutlet NSBUTT		*reload;
	IBOutlet NSBUTT		*home;
	IBOutlet NSMI		*backMenuItem;
	IBOutlet NSMI		*forwardMenuItem;
	IBOutlet NSMI		*stopMenuItem;
	IBOutlet NSMI		*reloadMenuItem;


	IBOutlet NSTabView		*tabView; // the tab view
//	IBOutlet NSImageView	*rightbar; // the right edge image view
//	IBOutlet NSImageView	*filler;
	IBOutlet NSWindow 		*quickDownloadWindow;
	IBOutlet NSSplitView	*splitView;
	
	// class variables/objects
	NSString						*loadingState; // used to keep track of the loading status string
	NSString						*homePage; // the home page
	BOOL							windowIsVisible; // used to keep track of whether the window is already slide out or not
	//CGFloat							padding; // added to the zero cord to position the window (TEMORARY)
	
	BOOL spinnerEnabled, stopEnabled, reloadEnabled;
	
	AZSemiResponderWindow			*menuWindow;
	DBActionMenuWindow				*windowControlWindow;
	DBActionMenuView				*windowControlView;

	DBHistoryController				*historyController;
	DBBookmarkController			*bookmarkController;
	DBDownloadController			*downloadController;
	DBPreferenceController			*prefController;
	
	DBHistoryWindowController		*historyWindowController;
	DBBookmarkImportWindowController*bookmarkImportWindowController;
	DBBookmarkWindowController		*bookmarkWindowController;
	DBViewSourceWindowController	*sourceWindowController;
	
	DBStatusItemController			*statusController;
	DBSymbolicHotKeyController	 	*symbolicHotKeyController;
	DBTabController					*tabController;
		
	WebView							*currentWebView;
	NSS								*currentStatus, *currentTitle;
	Authorizer						*auth;

	DBActionMenuWindow				*actionMenuWindow;
	DBActionMenuView				*actionMenu;
	BOOL							windowControlWindowVisible, actionMenuVisible;
	IBOutlet NSBUTT 				*actionMenuButton;
	// Websposé stuff
	BOOL						inWebsposeMode;
	// Websposé outlets
	IBOutlet DBWebsposeWindow		*websposeWindow;
	IBOutlet DBBookmarkBar			*websposeBookmarkBar;
	IBOutlet DBLocationTextField	*websposeURLField;
	IBOutlet NSProgressIndicator	*websposeSpinner;
	IBOutlet NSSearchField			*websposeSearchField;
	
	IBOutlet NSBox		*websposeWebViewBox;
	IBOutlet NSBox		*websposeTabBarBox;
	IBOutlet NSBUTT		*websposeBack;
	IBOutlet NSBUTT		*websposeForward;
	IBOutlet NSBUTT		*websposeStop;
	IBOutlet NSBUTT		*websposeReload;
	IBOutlet NSPanel	*websposePasswordWindow;
	IBOutlet NSTXTF		*websposeStatusField;
	IBOutlet NSTXTF		*websposeTitleField;
	IBOutlet NSTXTF		*websposePasswordField;
	IBOutlet NSTXTF		*websposePasswordStatus;
	IBOutlet NSBUTT		*webpsoseActionMenuButton;

	CLLocationManager *locationManager;

}
- (IBAction) websposeEnterPassword:	(id) sender;
- (IBAction) websposeCancelPassword:(id) sender;
- (IBAction) loadURL:				(id) sender; // called when enter is pushed inside the url field
- (IBAction) googleSearch:			(id) sender; // called when enter is pushed inside the search field
- (IBAction) back:					(id) sender;
- (IBAction) forward:				(id) sender;
- (IBAction) reload:				(id) sender;
- (IBAction) goHome:				(id) sender; // called by the home button
- (IBAction) showDownloadWindow:	(id) sender; // shows the download window
- (IBAction) showPrefWindow: 		(id) sender; // shows the preference window
- (IBAction) showSourceWindow:	 	(id) sender; // shows the source window
- (IBAction) showHistoryWindow: 	(id) sender;
- (IBAction) showBookmarkImportWindow:(id) sender;
- (IBAction) showBookmarkWindow:	(id) sender;
- (IBAction) addBookmark: 			(id) sender;
- (IBAction) toggleWindowControls:	(id) sender;
- (IBAction) toggleActionMenu:		(id) sender;
- (IBAction) toggleBookmarkBar:		(id) sender;
- (IBAction) stopLoading:			(id) sender;
- (IBAction) selectTabRight: 		(id) sender;
- (IBAction) selectTabLeft: 			(id) sender;
- (IBAction) closeAllTabs: 			(id) sender;
- (IBAction) close:					(id) sender;
- (IBAction) newBlankTab:			(id) sender;
- (IBAction) makeTextLarger:			(id) sender;
- (IBAction) makeTextSmaller:		(id) sender;
- (IBAction) saveCurrentPage:		(id) sender;
- (IBAction) openLocation:			(id) sender;
- (IBAction) showQDownloadWindow:	(id) sender;
- (IBAction) showDocumentation:		(id) sender;

- (void) setupTabView;
- (NSW*) currentWindow;
- (void) toggleWebspose;
- (void) lock: 					(BOOL) shouldLock;
- (void) handleNotification:		(NSNOT*)note;
- (void) loadURLNotification: 	(NSNOT*) notification;
- (void) loadURLString: 		(NSS*) URLString;
- (void) slideWindowResized: 	(NSNOT*) notification;
- (void) syncVariablesWithUserPrefs;
- (NSS*) statusText; 									// returns the current status text of the page
- (void) setStatusText:			(NSS*)status; 			// used to set the current status text of the page
- (void) setTitleText:			(NSS*)title; 			// used to	 set the current status text of the page
- (void) setURLText:			(NSS*)URL; 				// used to s	et the current URL text of the page
- (NSS*) titleText; 									// retu	rns the current title text of the page
- (NSS*) URLText; 										// returns the current URL text of the page
- (NSS*) searchFieldText;
- (void) setFavicon: 			(NSIMG*) favicon;
- (DBLocationTextField*) URLField;
- (void) syncLoadingStateWithStatus; 					// used to set the loading to the status bar text

- (void) slideInForcingToFront: 	(BOOL) forceToFront; 	// slides the window in
- (void) slideOut; 										// slides the window out
- (void) toggleSlideBrowse; 								// called when the hotkey is pushed

- (void) filterErrorMessage:		   	(NSS*)msg  forWebView:(WebView*) webView;
- (BOOL) handleFileProtocolForPath: (NSS*)path    webview:(WebView*)wv;
- (void) viewPageSource;
- (void) updateButtons;
- (WebView*) createWebView;
- (void) tabChanged: 			(NSNOT*) notification;
- (BOOL) actionMenuVisible;
- (BOOL) windowControlWindowVisible;

- (BOOL) inWebspose;
- (void) windowDidResignKey:		(NSNOT*)aNotification;
- (void) handleNewTabRequest:	(NSNOT*)notification;
- (void) mouseDown: 			(NSE*) theEvent;
- (void) keyCombinationPressed: (KeyCombination) keys;
- (void) showErrorPageForReason:(NSS*)reason title:(NSS*)title webview:(WebView*)wv;

- (IBAction) reloadAllTabs:		(id)sender;
- (IBAction) clearCache:		(id)sender;

- (IBAction) makeMobile:		(id)sender;

@property (nonatomic, retain)  AZCalculatorController		*calculator;

@end
