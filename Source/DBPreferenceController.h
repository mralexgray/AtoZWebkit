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
	IBOutlet NSBUTT		*showMenuBarAndDock;
	IBOutlet NSBUTT		*showMenuExtra;
	IBOutlet NSBUTT		*selectNewTabs;
	IBOutlet NSBUTT		*checkForUpdates;
	IBOutlet id			checkForUpdatesIndicator;
	IBOutlet id			homePage;
	IBOutlet NSBUTT		*loadHomePageOnLaunch;
	IBOutlet NSPUBUTT	*browserMode;
	IBOutlet NSBUTT		*allowJavaScript;
	IBOutlet NSBUTT		*allowJava;
	IBOutlet NSBUTT		*allowImages;
	IBOutlet NSBUTT		*allowAnimatedImages;
	IBOutlet NSBUTT		*allowPluginMedia;
	IBOutlet NSBUTT		*blockPopupWindows;
	IBOutlet NSBUTT		*blockWebAds;
	IBOutlet id			sbHotKeyField;
	IBOutlet id			wbHotKeyField;
	IBOutlet id			changePasswordWindow;
	IBOutlet id			changePasswordOld;
	IBOutlet id			changePasswordNew;
	IBOutlet id			changePasswordVerify;
	IBOutlet id			changePasswordStatus;
	IBOutlet NSTXTF		*downloadPathField;
	NSTBAR				*toolbar;
	IBOutlet NSTABV		*tabView;
	NSSZ				sizeOfGeneralPane, sizeOfWebPane, sizeOfWebsposePane;
}
- (IBAction) closeWindow: 			 (id) sender;
- (IBAction) savePreferences: 		 (id) sender;
- (IBAction) resetPreferences: 		 (id) sender;
- (IBAction) checkForUpdates: 		 (id) sender;
- (IBAction) changeSBHotKey: 		 (id) sender;
- (IBAction) changeWBHotKey: 		 (id) sender;
- (IBAction) changePassword: 		 (id) sender;
- (IBAction) savePassword: 			 (id) sender;
- (IBAction) cancelPassword: 		 (id) sender;
- (IBAction) changeDownloadLocation: (id) sender;
- (void) setLevel: (NSI) newLevel;
- (void) syncViewWithUserPrefs;
- (void)showGeneralPane;
- (void)showWebPane;
- (void)showWebsposePane;
@end
