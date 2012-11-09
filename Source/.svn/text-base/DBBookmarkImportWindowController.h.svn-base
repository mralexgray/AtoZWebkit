/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>

#import "DBBookmarkController.h"
#import "DBBookmarkImporter.h"


@interface DBBookmarkImportWindowController : NSWindowController
{
	IBOutlet NSButton*				mDoneButton;
	IBOutlet NSButton*				mImportButton;
	IBOutlet NSButton*				mSortBookmarksButton;
	IBOutlet NSPopUpButton*			mOtherBrowsersPopUpButton;
	IBOutlet NSProgressIndicator*	mImportingProgressIndicator;
	IBOutlet NSTextField*			mStatusTextField;
	
	DBBookmarkController*				mBookmarkController;
}

- (id) initWithWindowNibName: (NSString*) windowNibName bookmarkController: (DBBookmarkController*) bookmarkController;
- (IBAction) importBookmarksFromSelectedBrowser: (id) sender;
- (void) importBookmarksFromSelectedBrowserInNewThread;
- (void) populatePopUpButtonWithOtherBrowsers: (NSPopUpButton*) popUpButton;

@end