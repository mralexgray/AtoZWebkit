/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>
@class DBBookmarkController;

extern NSS* const kBookmarkDragType;
@interface DBBookmarkTableDataSource : NSObject
{
@private
	DBBookmarkController* mBookmarkController;
}
- (id) initWithBookmarkController: (DBBookmarkController*) bookmarkController;
@end

@interface DBBookmarkOutlineDataSource : NSObject
{
@private
	DBBookmarkController* mBookmarkController;
	NSArray*			mDraggingBookmarks;
}
- (id) initWithBookmarkController: (DBBookmarkController*) bookmarkController;
@end