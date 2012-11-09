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
	
	BOOL spinnerEnabled;
	BOOL stopEnabled;
	BOOL reloadEnabled;
	
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
	NSS*					currentStatus;
	NSS*					currentTitle;
	Authorizer*					auth;
	
	DBActionMenuWindow			*actionMenuWindow;
	DBActionMenuView			*actionMenu;
	BOOL						actionMenuVisible;
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
- (IBAction) websposeEnterPassword: (id) sender;
- (IBAction) websposeCancelPassword: (id) sender;
- (IBAction)loadURL:(id)sender; // called when enter is pushed inside the url field
- (IBAction)googleSearch:(id)sender; // called when enter is pushed inside the search field
- (IBAction)back:(id)sender;
- (IBAction)forward:(id)sender;
- (IBAction)reload:(id)sender;
- (IBAction)goHome:(id)sender; // called by the home button
- (IBAction)showDownloadWindow:(id)sender; // shows the download window
- (IBAction) showPrefWindow: (id) sender; // shows the preference window
- (IBAction) showSourceWindow: (id) sender; // shows the source window
- (IBAction) showHistoryWindow: (id) sender;
- (IBAction) showBookmarkImportWindow: (id) sender;
- (IBAction) showBookmarkWindow: (id) sender;
- (IBAction) addBookmark: (id) sender;
- (IBAction)toggleActionMenu:(id)sender;
- (IBAction)toggleBookmarkBar:(id)sender;
- (IBAction)stopLoading:(id)sender;
- (IBAction) selectTabRight: (id) sender;
- (IBAction) selectTabLeft: (id) sender;
- (IBAction) closeAllTabs: (id) sender;
- (IBAction)close:(id)sender;
- (IBAction)newBlankTab:(id)sender;
- (IBAction)makeTextLarger:(id)sender;
- (IBAction)makeTextSmaller:(id)sender;
- (IBAction)saveCurrentPage:(id)sender;
- (IBAction)openLocation:(id)sender;
- (IBAction)showQDownloadWindow:(id)sender;
- (IBAction)showDocumentation:(id)sender;
- (void) setupTabView;
- (NSWindow*) currentWindow;
- (void)handleNotification:(NSNotification *)note;
- (void) toggleWebspose;
- (void) lock: (BOOL) shouldLock;
- (void) loadURLNotification: (NSNotification*) notification;
- (void) loadURLString: (NSS*) URLString;
- (void) slideWindowResized: (NSNotification*) notification;
- (void) syncVariablesWithUserPrefs;
- (void)setStatusText:(NSS *)status; // used to set the current status text of the page
- (NSS *)statusText; // returns the current status text of the page
- (void)setTitleText:(NSS *)title; // used to set the current status text of the page
- (NSS *)titleText; // returns the current title text of the page
- (DBLocationTextField*) URLField;
- (void)setURLText:(NSS *)URL; // used to set the current URL text of the page
- (NSS *)URLText; // returns the current URL text of the page
- (NSS*) searchFieldText;
- (void) setFavicon: (NSImage*) favicon;
- (void)syncLoadingStateWithStatus; // used to set the loading to the status bar text
- (void)slideInForcingToFront: (BOOL) forceToFront; // slides the window in
- (void)slideOut; // slides the window out
- (void)toggleSlideBrowse; // called when the hotkey is pushed
- (void)filterErrorMessage:(NSS *)msg forWebView: (WebView*) webView;
- (BOOL)handleFileProtocolForPath:(NSS *)path webview:(WebView *)wv;
- (void)viewPageSource;
- (void) updateButtons;
- (WebView*) createWebView;
- (void) tabChanged: (NSNotification*) notification;
- (BOOL)actionMenuVisible;
- (BOOL)inWebspose;
- (void)windowDidResignKey:(NSNotification *)aNotification;
- (void) handleNewTabRequest:(NSNotification *)notification;
- (void) mouseDown: (NSEvent*) theEvent;
- (void) keyCombinationPressed: (KeyCombination) keys;
- (void) showErrorPageForReason:(NSS *)reason title:(NSS *)title webview:(WebView *)wv;
- (IBAction)reloadAllTabs:(id)sender;
- (IBAction)clearCache:(id)sender;
@end
