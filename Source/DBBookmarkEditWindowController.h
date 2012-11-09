/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>
@class DBBetterOutlineView;
@class DBBookmarkController;
@class DBBookmarkOutlineDataSource;
@class DBBookmarkTableDataSource;

@interface DBBookmarkEditWindowController : NSWindowController
{
	DBBookmarkController*			mBookmarkController;
	DBBookmarkOutlineDataSource*	mOutlineDataSource;
	NSFont*						mOutlineViewFont;
	
	IBOutlet DBBetterOutlineView*	mOutlineView;
}
- (id) initWithOutlineDataSource: (DBBookmarkOutlineDataSource*) dataSource bookmarkController: (DBBookmarkController*) bookmarkController;
- (IBAction) closeWindow: (id) sender;
- (IBAction) addBookmark: (id) sender;
- (void) runSheetOnWindow: (NSWindow*) window;
@end