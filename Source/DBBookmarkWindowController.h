/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>
@class DBBookmarkController;

@interface DBBookmarkWindowController : NSWindowController
{
	IBOutlet NSTableView*	mTableView;
	IBOutlet NSOutlineView*	mOutlineView;
	IBOutlet NSWindow*		mEditingWindow;
	
	DBBookmarkController*		mBookmarkController;
}
- (id) initWithWindowNibName: (NSS*) windowNibName bookmarkController: (DBBookmarkController*) controller;
// Window
/*- (IBAction) closeWindow: (id) sender;
- (IBAction) openEditWindow: (id) sender;
- (IBAction) closeEditWindow: (id) sender;
// UI
- (IBAction) remove: (id) sender;
- (IBAction) load: (id) sender;*/
@end