/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>

#import "NSFileManagerSGSAdditions.h"

@class DBBookmark;
@class DBBookmarkBar;
@class DBBookmarkImporter;
@class DeskBrowseConstants;


extern NSString* const kNameOfBookmarkFile;
extern NSString* const kBookmarksDidChangeNotification;
extern NSString* const DBBookmarkRows;


@interface DBBookmarkController : NSWindowController
{
	NSMutableArray*			mBookmarks;
	
	
	// Interface related
	
	IBOutlet NSTableView*	mBookmarkTableView;	
	
	// New bookmark window
	
	IBOutlet NSPanel*		mNewBookmarkWindow;
	IBOutlet NSTextField*	mTitleField;
	
	NSURL*					mCurrentNewBookmarkURL;
}

- (void) newBookmarkWithURL: (NSURL*) URL title: (NSString*) title window: (NSWindow*) window;

- (unsigned) numberOfBookmarks;
- (DBBookmark*) bookmarkAtIndex: (unsigned) index;
- (void) addBookmark: (DBBookmark*) bookmark toFront: (BOOL) toFront;
- (BOOL) addBookmarks: (NSArray*) bookmarks;

- (void) save;
- (void) load;
- (BOOL) saveBookmarks;
- (BOOL) loadBookmarks;

// Interface methods
- (IBAction) loadSelectedBookmark: (id) sender;
- (IBAction) deleteSelectedBookmark: (id) sender;

- (IBAction) cancel: (id) sender;
- (IBAction) ok: (id) sender;

// View methods
- (void) setTableView: (NSTableView*) tableView;
- (NSInteger) numberOfRows;
- (NSString*) stringForRow: (NSInteger) row;
- (void) tableViewDoubleClick;
- (void) tableViewDeleteKeyPressed: (NSTableView*) tableView;
- (void) loadBookmarkAtIndex: (NSInteger) index;
- (void) bookmarkDelete: (NSNotification*) notification;
- (void) deleteBookmark: (DBBookmark*) bookmark;
- (void) deleteBookmarkAtIndex: (NSInteger) index;

// Main window
- (IBAction) openEditWindow: (id) sender;
- (IBAction) closeEditWindow: (id) sender;

// Bookmark bar
- (NSArray*) bookmarks;
- (NSEnumerator*) bookmarkEnumerator;
- (void) bookmarkDraggedFromIndex: (NSInteger) index toIndex: (NSInteger) newIndex;

// Bookmark editing window
- (void) newBookmarkFolder;

- (void)updateBookmarksMenu;

@end