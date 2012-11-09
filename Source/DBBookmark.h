/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>

#import "DBBookmarkBarCell.h"


extern NSString* kDBLoadURLNotification;
extern NSString* kDBDeleteBookmarkNotification;

@interface DBBookmark : NSView <NSCopying>
{
	NSURL*		mURL;
	NSString*	mTitle;
	
	
	// Bookmark bar
	
	id <DBBookmarkBarCell>	mBookmarkBarCell;
	
	BOOL					mDragging;
	BOOL					mMouseOver;
	BOOL					mMouseDown;
	
	NSNumber*				mIndex;
}

- (id) initWithDictionary: (NSD*) dictionary;
- (id) initWithURL: (NSURL*) URL title: (NSString*) title;
- (void) load;
- (void) remove;
- (NSMD*) dictionary;

- (NSURL*) URL;
- (void) setURL: (NSURL*) URL;

- (NSString*) URLString;
- (void) setURLString: (NSString*) urlString;

- (NSString*) title;
- (void) setTitle: (NSString*) title;


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