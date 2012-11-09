/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "DBApplication.h"
#import "DeskBrowseConstants.h"
#import "DBPlistUtils.h"


@interface DBPreferenceController : NSWindowController
{
	IBOutlet NSButton*				showMenuBarAndDock;
	IBOutlet NSButton*				showMenuExtra;
	IBOutlet NSButton*				selectNewTabs;
	IBOutlet NSButton*				checkForUpdates;
	IBOutlet id				checkForUpdatesIndicator;
	IBOutlet id						homePage;
	IBOutlet NSButton*				loadHomePageOnLaunch;
	IBOutlet NSPopUpButton*				browserMode;
	IBOutlet NSButton*				allowJavaScript;
	IBOutlet NSButton*				allowJava;
	IBOutlet NSButton*				allowImages;
	IBOutlet NSButton*				allowAnimatedImages;
	IBOutlet NSButton*				allowPluginMedia;
	IBOutlet NSButton*				blockPopupWindows;
	IBOutlet NSButton*				blockWebAds;
	
	IBOutlet id				sbHotKeyField;
	IBOutlet id				wbHotKeyField;
	
	IBOutlet id				changePasswordWindow;
	IBOutlet id				changePasswordOld;
	IBOutlet id				changePasswordNew;
	IBOutlet id				changePasswordVerify;
	IBOutlet id				changePasswordStatus;
	
	IBOutlet NSTextField	*downloadPathField;
	
	NSToolbar				*toolbar;
	IBOutlet NSTabView		*tabView;
	
	NSSize					sizeOfGeneralPane;
	NSSize					sizeOfWebPane;
	NSSize					sizeOfWebsposePane;
}

- (IBAction) closeWindow: (id) sender;
- (IBAction) savePreferences: (id) sender;
- (IBAction) resetPreferences: (id) sender;
- (IBAction) checkForUpdates: (id) sender;

- (IBAction) changeSBHotKey: (id) sender;
- (IBAction) changeWBHotKey: (id) sender;

- (IBAction) changePassword: (id) sender;
- (IBAction) savePassword: (id) sender;
- (IBAction) cancelPassword: (id) sender;

- (IBAction) changeDownloadLocation: (id) sender;

- (void) setLevel: (NSInteger) newLevel;
- (void) syncViewWithUserPrefs;

- (void)showGeneralPane;
- (void)showWebPane;
- (void)showWebsposePane;

@end
