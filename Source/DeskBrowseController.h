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

@class DBApplication;
@class DeskBrowseConstants;
@class DBActionMenuView;
@class DBActionMenuWindow;
@class Authorizer;
@class DBBookmarkBar;
@class DBBookmarkController;
@class DBBookmarkImportWindowController;
@class DBBookmarkWindowController;
@class DBDownloadController;
@class DBHistoryController;
@class DBHistoryWindowController;
@class DBHotKeyController;
@class DBLocationTextField;
@class NSFileManagerSGSAdditions;
@class NSWindowFade;
@class DBPlistUtils;
@class DBPreferenceController;
@class DBQuickDownload;
@class SearchEngineController;
@class DBSlideWindow;
@class DBTabController;
@class DBTab;
@class DBTabBar;
@class DBURLFormatter;
@class DBViewSourceWindowController;
@class WebKitEx;
@class DBWebsposeWindow;
@class DBWindowLevel;
@class DBStatusItemController;
@class DBSymbolicHotKeyController;
@interface DeskBrowseController : NSObject
{
	// main browser components
	 IBOutlet DBSlideWindow			*slideWindow; // the main window
	IBOutlet NSBox*					webViewBox;
	IBOutlet NSBox*					tabBarBox;
	IBOutlet NSButton				*back; // back button
	IBOutlet NSButton				*forward; // forward button
	IBOutlet NSButton				*stop; // stop button
	IBOutlet NSButton				*reload; // reload button
	IBOutlet NSButton				*home; // home button
	IBOutlet NSTextField			*statusField; // where the status text is shown
	IBOutlet DBLocationTextField		*urlField; // the location text field
	IBOutlet NSSearchField			*searchField; // the google search field
	IBOutlet NSTextField			*titleField; // where the title of the page is displayed
	IBOutlet NSTabView				*tabView; // the tab view
	IBOutlet NSImageView			*rightbar; // the right edge image view
	IBOutlet NSImageView			*filler;
	IBOutlet DBBookmarkBar*			bookmarkBar;
	IBOutlet DBTabBar*				tabBar;
	IBOutlet NSMenuItem*			backMenuItem;
	IBOutlet NSMenuItem*			forwardMenuItem;
	IBOutlet NSMenuItem*			stopMenuItem;
	IBOutlet NSMenuItem*			reloadMenuItem;
	IBOutlet NSWindow *				quickDownloadWindow;
	IBOutlet NSSplitView			*splitView;
	
	// class variables/objects
	NSString						*loadingState; // used to keep track of the loading status string
	NSString						*homePage; // the home page
	BOOL							windowIsVisible; // used to keep track of whether the window is already slide out or not
	//CGFloat							padding; // added to the zero cord to position the window (TEMORARY)
	
	BOOL spinnerEnabled, stopEnabled, reloadEnabled;
	
	AZSemiResponderWindow*			menuWindow;
	DBActionMenuWindow			*windowControlWindow;
	DBActionMenuView*			windowControlView;

	DBHistoryController*			historyController;
	DBBookmarkController*			bookmarkController;
	DBDownloadController*			downloadController;
	DBPreferenceController*		prefController;
	
	DBHistoryWindowController*		historyWindowController;
	DBBookmarkImportWindowController*	bookmarkImportWindowController;
	DBBookmarkWindowController*		bookmarkWindowController;
	DBViewSourceWindowController*		sourceWindowController;
	
	DBStatusItemController		*statusController;
	DBSymbolicHotKeyController	 *symbolicHotKeyController;
	DBTabController				*tabController;
		
	WebView*					currentWebView;
	NSS*						currentStatus, *currentTitle;
	Authorizer*					auth;


	DBActionMenuWindow			*actionMenuWindow;
	DBActionMenuView			*actionMenu;
	BOOL						windowControlWindowVisible, actionMenuVisible;
	IBOutlet NSButton *			actionMenuButton;
	// Websposé stuff
	BOOL						inWebsposeMode;
	// Websposé outlets
	IBOutlet DBWebsposeWindow*		websposeWindow;
	IBOutlet NSBox*					websposeWebViewBox;
	IBOutlet NSBox*					websposeTabBarBox;
	IBOutlet NSButton*				websposeBack;
	IBOutlet NSButton*				websposeForward;
	IBOutlet NSButton*				websposeStop;
	IBOutlet NSButton*				websposeReload;
	IBOutlet NSPanel*				websposePasswordWindow;
	IBOutlet NSProgressIndicator*	websposeSpinner;
	IBOutlet NSSearchField*			websposeSearchField;
	IBOutlet NSTextField*			websposeStatusField;
	IBOutlet NSTextField*			websposeTitleField;
	IBOutlet DBLocationTextField*		websposeURLField;
	IBOutlet NSTextField*			websposePasswordField;
	IBOutlet NSTextField*			websposePasswordStatus;
	IBOutlet NSButton*				webpsoseActionMenuButton;
	IBOutlet DBBookmarkBar*			websposeBookmarkBar;
}
- (IBA) websposeEnterPassword: 	(id) sender;
- (IBA) websposeCancelPassword: (id) sender;
- (IBA) loadURL:				(id) sender; // called when enter is pushed inside the url field
- (IBA) googleSearch:			(id) sender; // called when enter is pushed inside the search field
- (IBA) back:					(id) sender;
- (IBA) forward:				(id) sender;
- (IBA) reload:					(id) sender;
- (IBA) goHome:					(id) sender; // called by the home button
- (IBA) showDownloadWindow:		(id) sender; // shows the download window
- (IBA) showPrefWindow: 		(id) sender; // shows the preference window
- (IBA) showSourceWindow:	 	(id) sender; // shows the source window
- (IBA) showHistoryWindow: 		(id) sender;
- (IBA) showBookmarkImportWindow:(id) sender;
- (IBA) showBookmarkWindow: 		(id) sender;
- (IBA) addBookmark: 			(id) sender;
- (IBA) toggleWindowControls:	(id) sender;
- (IBA) toggleActionMenu:		(id) sender;
- (IBA) toggleBookmarkBar:		(id) sender;
- (IBA) stopLoading:			(id) sender;
- (IBA) selectTabRight: 		(id) sender;
- (IBA) selectTabLeft: 			(id) sender;
- (IBA) closeAllTabs: 			(id) sender;
- (IBA) close:					(id) sender;
- (IBA) newBlankTab:			(id) sender;
- (IBA) makeTextLarger:			(id) sender;
- (IBA) makeTextSmaller:		(id) sender;
- (IBA) saveCurrentPage:		(id) sender;
- (IBA) openLocation:			(id) sender;
- (IBA) showQDownloadWindow:		(id) sender;
- (IBA) showDocumentation:		(id) sender;
- (void) setupTabView;
- (NSW*) currentWindow;
- (void) handleNotification:		(NSNOT*)note;
- (void) toggleWebspose;
- (void) lock: 					(BOOL) shouldLock;
- (void) loadURLNotification: 	(NSNOT*) notification;
- (void) loadURLString: 		(NSS*) URLString;
- (void) slideWindowResized: 	(NSNOT*) notification;
- (void) syncVariablesWithUserPrefs;
- (void) setStatusText:			(NSS*)status; 			// used to set the current status text of the page
- (NSS*) statusText; 									// returns the current status text of the page
- (void) setTitleText:			(NSS*)title; 			// used to	 set the current status text of the page
- (NSS*) titleText; 									// retu	rns the current title text of the page
- (void) setURLText:			(NSS*)URL; 				// used to s	et the current URL text of the page
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
- (void) tabChanged: (NSNotification*) notification;
- (BOOL) actionMenuVisible;
- (BOOL) windowControlWindowVisible;

- (BOOL) inWebspose;
- (void) windowDidResignKey:		(NSNOT*)aNotification;
- (void) handleNewTabRequest:	(NSNOT*)notification;
- (void) mouseDown: 			(NSEvent*) theEvent;
- (void) keyCombinationPressed: (KeyCombination) keys;
- (void) showErrorPageForReason:(NSS*)reason title:(NSS *)title webview:(WebView *)wv;
- (IBA) reloadAllTabs:(id)sender;
- (IBA) clearCache:(id)sender;


@property (nonatomic, retain)  AZCalculatorController		*calculator;
@end
