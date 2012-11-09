/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>
#import "DBBookmarkBarCell.h"

extern NSS* kDBLoadURLNotification;
extern NSS* kDBDeleteBookmarkNotification;
@interface DBBookmark : NSView <NSCopying>
{
	NSURL*		mURL;
	NSS*	mTitle;

	// Bookmark bar
	
	id <DBBookmarkBarCell>	mBookmarkBarCell;
	
	BOOL					mDragging;
	BOOL					mMouseOver;
	BOOL					mMouseDown;
	
	NSNumber*				mIndex;
}
- (id) initWithDictionary: (NSD*) dictionary;
- (id) initWithURL: (NSURL*) URL title: (NSS*) title;
- (void) load;
- (void) remove;
- (NSMD*) dictionary;
- (NSURL*) URL;
- (void) setURL: (NSURL*) URL;
- (NSS*) URLString;
- (void) setURLString: (NSS*) urlString;
- (NSS*) title;
- (void) setTitle: (NSS*) title;

// Bookmark bar
- (id <DBBookmarkBarCell>) cell;
@end

@interface BookmarkFolder: DBBookmark
{
	NSMutableArray* mContainedBookmarks;
}
- (unsigned) numberOfBookmarks;
- (NSA*) subBookmarks;						// These should not be used by outsiders; they are used only for NSCoding
- (void) setSubBookmarks: (NSA*) bookmarks;	//
- (void) addBookmark: (DBBookmark*) bookmark;
- (void) removeBookmark: (DBBookmark*) bookmark;
- (void) reloadCellMenu;
@end