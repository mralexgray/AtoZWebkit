/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>

@class DBBookmark;
@class DBBookmarkController;
@class DBBookmarkBarPopUpButton;


@interface DBBookmarkBar : NSView
{
	DBBookmarkController*		mBookmarkController;
	NSColor*				mBackgroundColor;
	DBBookmarkBarPopUpButton*	mExtraBookmarksPopUpButton;
	
	NSMutableArray*			mBookmarkCells;
	
	BOOL					mDragging;
	CGFloat					mLastMouseX;
	
	NSRect					mLastFrame;
}

- (void) setBookmarkController: (DBBookmarkController*) bookmarkController;
- (void) reloadData;
- (void) setVisiblePosition: (NSPoint) position;
- (NSArray*) menuItemsForPopUpButton: (NSPopUpButton*) popUpButton;

@end