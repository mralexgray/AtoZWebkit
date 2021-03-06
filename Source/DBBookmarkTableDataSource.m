/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBBookmarkTableDataSource.h"
#import "DBBookmark.h"
#import "DBBookmarkController.h"

NSS* const kTitleIdentifier	= @"Title";
NSS* const kURLIdentifier		= @"URL";
NSS* const kBookmarkDragType	= @"DBBookmarkDragType";

@implementation DBBookmarkTableDataSource

- (id) initWithBookmarkController: (DBBookmarkController*) bookmarkController
{
	if (self = [super init])
	{
		mBookmarkController = bookmarkController;
	}
	
	return self;
}
- (void) dealloc
{
	[mBookmarkController release];
	
}

- (NSI) numberOfRowsInTableView: (NSTableView*) tableView
{
	return [mBookmarkController numberOfBookmarks];
}
- (id) tableView: (NSTableView*) tableView objectValueForTableColumn: (NSTableColumn*) tableColumn row: (NSI) row
{
	id			value				= nil;
	NSS*	columnIdentifier	= [tableColumn identifier];
	
	if ([columnIdentifier isEqualToString: kTitleIdentifier])
	{
		value = [mBookmarkController bookmarkAtIndex: row];
	}
	else if ([columnIdentifier isEqualToString: kURLIdentifier])
	{
	}
	
	return value;
}

@end

@implementation DBBookmarkOutlineDataSource

- (id) initWithBookmarkController: (DBBookmarkController*) bookmarkController
{
	if (self = [super init])
	{
		mBookmarkController = bookmarkController;
	}
	
	return self;
}
- (void) dealloc
{
	[mBookmarkController release];
	[mDraggingBookmarks release];
	
}

- (NSI) outlineView: (NSOutlineView*) outlineView numberOfChildrenOfItem: (id) item
{
	NSInteger numberOfChildren = 0;
	
	if (item != nil && [item respondsToSelector: @selector(subBookmarks)])
	{
		numberOfChildren = [[item subBookmarks] count];
	}
	else
	{
		numberOfChildren = [mBookmarkController numberOfBookmarks];
	}
	
	return numberOfChildren;
}

// PRETTYIZE IT!
- (BOOL) outlineView: (NSOutlineView*) outlineView isItemExpandable: (id) item
{
	return ([item respondsToSelector: @selector(subBookmarks)] && [[item subBookmarks] count] > 0);
}

- (id) outlineView: (NSOutlineView*) outlineView child: (NSI) index ofItem: (id) item
{
	id child = nil;
	
	if (item == nil)
	{
		child = [mBookmarkController bookmarkAtIndex: index];
	}
	else
	{
		child = [item subBookmarks][index];
	}
	
	return child;
}
- (id) outlineView: (NSOutlineView*) outlineView objectValueForTableColumn: (NSTableColumn*) tableColumn byItem: (id) item
{
	id			value				= nil;
	NSS*	columnIdentifier	= [tableColumn identifier];
	
	if ([columnIdentifier isEqualToString: kTitleIdentifier])
	{
		value = [item title];
	}
	else if ([columnIdentifier isEqualToString: kURLIdentifier])
	{
		value = [item URLString];
	}
	
	return value;
}
- (void) outlineView: (NSOutlineView*) outlineView setObjectValue: (id) object forTableColumn: (NSTableColumn*) tableColumn byItem: (id) item
{
	NSS* columnIdentifier = [tableColumn identifier];
	
	if ([columnIdentifier isEqualToString: kTitleIdentifier])
	{
		[item setTitle: object];
	}
	else if ([columnIdentifier isEqualToString: kURLIdentifier])
	{
		[item setURLString: object];
	}
	
	[AZNOTCENTER postNotificationName: kBookmarksDidChangeNotification object: mBookmarkController];
}
- (BOOL) outlineView: (NSOutlineView*) olv writeItems: (NSA*) items toPasteboard: (NSPasteboard*) pboard
{
	BOOL wroteToPasteboard = NO;
	
//	if ([pboard setPropertyList: bookmarkDictionary forType: kBookmarkDragType])
	{
		wroteToPasteboard	= YES;
		mDraggingBookmarks	= [items copy];
		NSLog(@"%@ vs %@", [items class], [mDraggingBookmarks class]);
		NSLog(@"Write item: %@ %@", items[0], [items[0] title]);
	}
	
	return wroteToPasteboard;
}
- (NSDragOperation) outlineView: (NSOutlineView*) olv validateDrop: (id <NSDraggingInfo>) info proposedItem: (id) item proposedChildIndex: (NSI) index
{
	NSDragOperation operation = NSDragOperationGeneric;
	
	return operation;
}
- (BOOL) outlineView: (NSOutlineView*) olv acceptDrop: (id <NSDraggingInfo>) info item: (id) item childIndex: (NSI) index
{
	BOOL			acceptDrop		= NO;
	
	//NSPasteboard*	draggingPboard	= [info draggingPasteboard];
	NSDragOperation	draggingMask	= [info draggingSourceOperationMask];
	
	if (draggingMask == NSTableViewDropAbove)
	{
		//NSD*	bdict		= [draggingPboard propertyListForType: kBookmarkDragType];
		//DBBookmark*		newBookmark = [[DBBookmark alloc] initWithDictionary: bdict];
		//[item addBookmark: newBookmark];
		NSInteger i = [mDraggingBookmarks count];
		while (i--)
		{
			DBBookmark* bookmark	= mDraggingBookmarks[i];
			DBBookmark* copy		= [(DBBookmark*)bookmark copy];
			//NSLog(@"%@", [bookmark class]);
			NSLog(@"%li", [mDraggingBookmarks count]);
			NSLog(@"%@ vs %@", bookmark, copy);
			[item addBookmark: copy];
			[copy release];
		}
		
		[AZNOTCENTER postNotificationName: kBookmarksDidChangeNotification object: mBookmarkController];
		
		[mDraggingBookmarks release];
		mDraggingBookmarks	= nil;
		
		acceptDrop = YES;
		
		[mBookmarkController updateBookmarksMenu];
	}
	
	return acceptDrop;
}

@end