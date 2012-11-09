/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBBookmarkController.h"

#import "DBBookmark.h"
#import "DBBookmarkBar.h"
#import "DBBookmarkEditWindowController.h"
#import "DBBookmarkImporter.h"
#import "DBBookmarkTableDataSource.h"
#import "DeskBrowseConstants.h"
#import "DBNewBookmarkWindowController.h"


NSString* const kNameOfBookmarkFile				= @"Bookmarks.plist";
NSString* const kBookmarksDidChangeNotification = @"BookmarksDidChangeNotification";
NSString* const DBBookmarkRows					= @"DBBookmarkRows";
NSString* const kBookmarkWindowNibName			= @"Bookmarks";


@interface NSIndexSet (SGSAdditions)

- (NSArray*) arrayOfIndexes;
+ (NSIndexSet*) indexSetFromArray: (NSArray*) array;

@end


@interface NSMutableArray (SGSAdditions)

- (NSInteger) moveObjectsAtIndexes: (NSIndexSet*) indexSet toIndex: (NSInteger) index;

@end


@implementation DBBookmarkController


- (id) init
{
	if (self = [super initWithWindowNibName: kBookmarkWindowNibName])
	{
		mBookmarks = [[NSMutableArray alloc] init];
		
		[self load];
		
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bookmarkDelete:) name: kDBDeleteBookmarkNotification object: nil];
	}
	
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[[NSNotificationCenter defaultCenter] removeObserver: mBookmarkTableView name: kBookmarksDidChangeNotification object: nil];
	
	[mBookmarks release];
	[mBookmarkTableView release];
	[mCurrentNewBookmarkURL release];
	
	[super dealloc];
}

- (void) awakeFromNib
{
	[mBookmarkTableView setTarget: self];
	[mBookmarkTableView setDoubleAction: @selector(tableViewDoubleClick)];
	
	[mBookmarkTableView registerForDraggedTypes: @[DBBookmarkRows]];
	[mBookmarkTableView setDraggingSourceOperationMask: NSTableViewDropAbove forLocal: YES];
	
	[[NSNotificationCenter defaultCenter] addObserver: mBookmarkTableView selector: @selector(reloadData) name: kBookmarksDidChangeNotification object: nil];
	
	[[self window] setFrame: [[self window] frame] display: YES];
}


#pragma mark -

- (void) bookmarksChanged
{
	[[NSNotificationCenter defaultCenter] postNotificationName: kBookmarksDidChangeNotification object: self];
}

- (void)updateBookmarksMenu
{
	NSMenu* bookmarksRoot = [[[NSApp mainMenu] itemWithTitle:@"Bookmarks"] submenu];
	
	NSInteger offset = 3;
	unsigned count = [[bookmarksRoot itemArray] count];
	unsigned i;
	
	for (i = (count - 1); i >= offset; i--)
		[bookmarksRoot removeItemAtIndex:i];
	
	count = [mBookmarks count];
	DBBookmark* bookmark = nil;
	
	for (i = 0; i < count; i++)
	{
		bookmark = mBookmarks[i];
		NSMenuItem* newItem = [bookmarksRoot addItemWithTitle:[bookmark title] action:@selector(load) keyEquivalent:@""];
		[newItem setTarget:bookmark];
		[newItem setToolTip:[bookmark URLString]];
	}
}

#pragma mark -

- (void) newBookmarkWithURL: (NSURL*) URL title: (NSString*) title window: (NSWindow*) window
{	
	DBNewBookmarkWindowController* newBookmarkController = [[DBNewBookmarkWindowController alloc] initWithBookmarkController: self title: title url: URL];
	
	[newBookmarkController runSheetOnWindow: [self window]];
	[newBookmarkController release];
}

- (unsigned) numberOfBookmarks
{
	return [mBookmarks count];
}

- (void) addBookmark: (DBBookmark*) bookmark toFront: (BOOL) toFront
{
	if (bookmark != nil)
	{
		if (toFront)
		{
			[mBookmarks insertObject: bookmark atIndex: 0];
		}
		else
		{
			[mBookmarks addObject: bookmark];
		}
		
		[self bookmarksChanged];
		[self updateBookmarksMenu];
	}
}

- (BOOL) addBookmarks: (NSArray*) bookmarks
{
	BOOL addedBookmarks	= NO;
	
	if (bookmarks != nil)
	{
		// Make sure they are all Bookmarks
		
		BOOL			shouldAddBookmarks	= YES;
		NSEnumerator*	objectEnumerator	= [bookmarks objectEnumerator];
		id				currentObject		= nil;
		
		while ((currentObject = [objectEnumerator nextObject]) != nil)
		{
			if (![currentObject isKindOfClass: [DBBookmark class]])
			{
				shouldAddBookmarks = NO;
				break;
			}
		}
		
		
		// If they are, add them to our array of bookmarks
		
		if (shouldAddBookmarks)
		{
			[mBookmarks addObjectsFromArray: bookmarks];
			
			addedBookmarks = YES;
		}
	}
	
	
	// If the bookmarks were added, reload bookmarks views and resave bookmarks
	
	if (addedBookmarks)
	{
		[mBookmarkTableView reloadData];
		
		[self bookmarksChanged];
		[self save];
	}
	
	return addedBookmarks;
}

- (DBBookmark*) bookmarkAtIndex: (unsigned) index
{
	DBBookmark* bookmark = nil;
	
	if (index < [mBookmarks count])
	{
		bookmark = mBookmarks[index];
	}
	
	return bookmark;
}

#pragma mark -


- (void) save
{
	if (![self saveBookmarks])
	{
		NSLog(@"*** Failed to save bookmarks ***");
	}
}

- (BOOL) saveBookmarks
{
	NSMutableDictionary*	bookmarksToWrite	= [NSMutableDictionary dictionary];
	NSMutableArray*			bookmarkDicts		= [NSMutableArray array];
	NSEnumerator*			bookmarkEnumerator	= [mBookmarks objectEnumerator];
	DBBookmark*				currentBookmark		= nil;
	
	while ((currentBookmark = [bookmarkEnumerator nextObject]) != nil)
	{
		[bookmarkDicts addObject: [currentBookmark dictionary]];
	}
	
	bookmarksToWrite[@"Bookmarks"] = bookmarkDicts;
	
	BOOL			didSave						= NO;
	NSString*		fullPathOfDeskBrowseFolder	= nil;
	NSString*		fullBookmarkPath			= nil;
	NSFileManager*	fileManager					= nil;
	
	fullPathOfDeskBrowseFolder	= [kPathOfDeskBrowseFolder stringByExpandingTildeInPath];
	fullBookmarkPath			= [fullPathOfDeskBrowseFolder stringByAppendingPathComponent: kNameOfBookmarkFile];
	fileManager					= [NSFileManager defaultManager];
	
	[fileManager createPath: fullPathOfDeskBrowseFolder];

	if ([fileManager fileExistsAtPath: fullPathOfDeskBrowseFolder])
	{
		if (bookmarksToWrite != nil)
		{
			didSave = [bookmarksToWrite writeToFile: fullBookmarkPath atomically: YES];
		}
	}
	
	[self updateBookmarksMenu];
	
	return didSave;
}

- (void) load
{
	if (![self loadBookmarks])
	{
		NSLog(@"Failed to load bookmarks");
	}
}

- (BOOL) loadBookmarks
{
	BOOL			didLoad						= NO;
	NSString*		fullPathOfDeskBrowseFolder	= nil;
	NSString*		fullBookmarkPath			= nil;
	NSFileManager*	fileManager					= nil;
	
	fullPathOfDeskBrowseFolder	= [kPathOfDeskBrowseFolder stringByExpandingTildeInPath];
	fullBookmarkPath			= [fullPathOfDeskBrowseFolder stringByAppendingPathComponent: kNameOfBookmarkFile];
	fileManager					= [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath: fullPathOfDeskBrowseFolder])
	{
		NSDictionary*	loadedBookmarks = [NSDictionary dictionaryWithContentsOfFile: fullBookmarkPath];
		BOOL			resaveBookmarks	= NO;
		
		if (loadedBookmarks == nil)
		{
			NSBundle*	mainBundle				= [NSBundle mainBundle];
			NSString*	defaultBookmarksPath	= [mainBundle pathForResource: [kNameOfBookmarkFile stringByDeletingPathExtension] ofType: @"plist"];
			
			if (defaultBookmarksPath != nil)
			{
				loadedBookmarks = [NSDictionary dictionaryWithContentsOfFile: defaultBookmarksPath];
				resaveBookmarks = YES;
			}
		}
		
		if (loadedBookmarks != nil)
		{
			NSMutableArray* arrayOfBookmarks		= loadedBookmarks[@"Bookmarks"];
			NSEnumerator*	bookmarkDictEnumerator	= [arrayOfBookmarks objectEnumerator];
			NSDictionary*	currentBookmarkDict		= nil;
			
			[mBookmarks release];
			mBookmarks = [[NSMutableArray alloc] init];
			
			while ((currentBookmarkDict = [bookmarkDictEnumerator nextObject]) != nil)
			{
				DBBookmark* newBookmark = [[DBBookmark alloc] initWithDictionary: currentBookmarkDict];
				
				if (newBookmark != nil)
				{
					[mBookmarks addObject: newBookmark];
					[newBookmark release];
				}
			}
			
			if (resaveBookmarks)
			{
				[self save];
			}
			
			didLoad = YES;
		}
	}
	
	if (didLoad)
	{
		[self bookmarksChanged];
		[self updateBookmarksMenu];
	}
	
	return didLoad;
}


#pragma mark -

#pragma mark Interface

// Interface methods

- (IBAction) loadSelectedBookmark: (id) sender
{
	NSInteger selectedRow = [mBookmarkTableView selectedRow];
	
	if (selectedRow > -1 && selectedRow < [mBookmarkTableView numberOfRows])
	{
		[self loadBookmarkAtIndex: selectedRow];
	}
}

- (IBAction) deleteSelectedBookmark: (id) sender
{
	NSInteger selectedRow = [mBookmarkTableView selectedRow];
	
	if (selectedRow > -1 && selectedRow < [mBookmarkTableView numberOfRows])
	{
		[self deleteBookmarkAtIndex: selectedRow];
	}
	
	[mBookmarkTableView reloadData];
	[self bookmarksChanged];
}


#pragma mark -

- (IBAction) cancel: (id) sender
{
	[NSApp endSheet: mNewBookmarkWindow];
}

- (IBAction) ok: (id) sender
{
	NSString* newTitle = [mTitleField stringValue];
	
	if ([newTitle length] <= 0)
	{
		newTitle = [mCurrentNewBookmarkURL absoluteString];
	}
	
	if ([newTitle length] > 0)
	{
		
		DBBookmark* newBookmark = [[DBBookmark alloc] initWithURL: mCurrentNewBookmarkURL title: newTitle];
		
		[mBookmarks insertObject: newBookmark atIndex: 0];
		[newBookmark release];
		
		[mCurrentNewBookmarkURL release];
		mCurrentNewBookmarkURL = nil;
		
		[mBookmarkTableView reloadData];
		
		[self bookmarksChanged];
		[self save];
	}
	
	[NSApp endSheet: mNewBookmarkWindow];
}

#pragma mark -

#pragma mark View

// View methods

- (void) setTableView: (NSTableView*) tableView
{
	if (tableView != mBookmarkTableView)
	{
		[mBookmarkTableView setTarget: self];
		[mBookmarkTableView setDoubleAction: @selector(tableViewDoubleClick)];
		
		[mBookmarkTableView registerForDraggedTypes: @[DBBookmarkRows]];
		[mBookmarkTableView setDraggingSourceOperationMask: NSTableViewDropAbove forLocal: YES];
//		[mBookmarkTableView setDraggingSourceOperationMask: NSDragOperationEvery forLocal: YES];
//		[mBookmarkTableView setDraggingSourceOperationMask: NSDragOperationAll_Obsolete forLocal: NO];
	}
}

- (NSInteger) numberOfRows
{
	NSInteger numberOfRows = [mBookmarks count];
	
	return numberOfRows;
}

- (NSString*) stringForRow: (NSInteger) row
{
	NSString* string = nil;

	if ([mBookmarks count] > row)
	{
		DBBookmark*	bookmark	= mBookmarks[row];
		NSString*	title		= [bookmark title];
		NSString*	URLString	= [[bookmark URL] absoluteString];
				
		if ([title length] > 0)
		{
			string = title;
		}
		else
		{
			string = URLString;
		}
	}
	
	return string;
}

- (void) tableViewDoubleClick
{
	NSInteger row = [mBookmarkTableView selectedRow];
	
	if (row > -1 && row < [mBookmarks count])
	{
		[self loadBookmarkAtIndex: row];
	}
}

- (void) tableViewDeleteKeyPressed: (NSTableView*) tableView
{
	if (tableView == mBookmarkTableView)
	{
		NSInteger row = [mBookmarkTableView selectedRow];
		
		if (row > -1 && row < [mBookmarks count])
		{
			[self deleteBookmarkAtIndex: row];
		}
	}
}

- (void) loadBookmarkAtIndex: (NSInteger) index
{		
	if (index < [mBookmarks count])
	{
		DBBookmark* selectedBookmark = mBookmarks[index];
		
		if (selectedBookmark != nil)
		{
			[selectedBookmark load];
		}
	}
}

- (void) bookmarkDelete: (NSNotification*) notification
{
	DBBookmark* bookmark = [notification object];
	
	if (bookmark != nil && [bookmark isKindOfClass: [DBBookmark class]])
	{
		[self deleteBookmark: bookmark];
	}
}

- (void) deleteBookmark: (DBBookmark*) bookmark
{
	NSInteger index = [mBookmarks indexOfObject: bookmark];
	
	if (index != NSNotFound)
	{
		[mBookmarks removeObjectAtIndex: index];
		
		[self bookmarksChanged];
		
		[mBookmarkTableView deselectAll: nil];
		[mBookmarkTableView reloadData];
	}
}

- (void) deleteBookmarkAtIndex: (NSInteger) index
{	
	DBBookmark* bookmark = mBookmarks[index];
	
	if (bookmark != nil)
	{
		[self deleteBookmark: bookmark];
	}
}


#pragma mark -
#pragma mark Main Window

- (IBAction) openEditWindow: (id) sender
{
	DBBookmarkOutlineDataSource*		outlineDataSource		= [[DBBookmarkOutlineDataSource alloc] initWithBookmarkController: self];
	DBBookmarkEditWindowController*	bookmarkEditController	= [[DBBookmarkEditWindowController alloc] initWithOutlineDataSource: outlineDataSource bookmarkController: self];
	
	[bookmarkEditController runSheetOnWindow: [self window]];
	
	[outlineDataSource release];
	[bookmarkEditController release];
}

- (IBAction) closeEditWindow: (id) sender
{
}


#pragma mark -
#pragma mark Bookmark Bar

- (NSArray*) bookmarks
{
	return mBookmarks;
}

- (NSEnumerator*) bookmarkEnumerator
{
	return [mBookmarks objectEnumerator];
}

- (void) bookmarkDraggedFromIndex: (NSInteger) index toIndex: (NSInteger) newIndex
{
	DBBookmark* draggedBookmark = [mBookmarks[index] retain];
	
	[mBookmarks removeObjectAtIndex: index];
	
	if (index < newIndex)
	{
		newIndex--;
	}
			
	[mBookmarks insertObject: draggedBookmark atIndex: newIndex];
	
	[draggedBookmark release];
	
	[self bookmarksChanged];
	[mBookmarkTableView reloadData];
}


#pragma mark -
#pragma mark Bookmark Editing Window

- (void) newBookmarkFolder
{
}


#pragma mark -

- (id) outlineView: (NSOutlineView*) outlineView child: (NSInteger) index ofItem: (id) item
{
	id childItem = nil;
	
	if (item == nil)
	{
		childItem = mBookmarks[index];
	}
	else
	{
		childItem = [item subBookmarks][index];
	}
	
	return childItem;
}

- (BOOL) outlineView: (NSOutlineView*) outlineView isItemExpandable: (id) item
{
	BOOL isExpandable = NO;
	
	if ([item respondsToSelector: @selector(numberOfBookmarks)] && [item numberOfBookmarks] > 0)
	{
		isExpandable = YES;
	}
	
	return isExpandable;
}

- (NSInteger) outlineView: (NSOutlineView*) outlineView numberOfChildrenOfItem: (id) item
{
	NSInteger numberOfChildren = 0;
	
	if (item == nil)
	{
		numberOfChildren = [mBookmarks count];
	}
	else if ([item respondsToSelector: @selector(numberOfBookmarks)])
	{
		numberOfChildren = [item numberOfBookmarks];
	}
	else
	{
	}
	
	return numberOfChildren;
}

- (id) outlineView: (NSOutlineView*) outlineView objectValueForTableColumn: (NSTableColumn*) tableColumn byItem: (id) item
{
	id			value				= nil;
	NSString*	columnIdentifier	= [tableColumn identifier];
	
	value = [item valueForKey: columnIdentifier];
	
	return value;
}

- (void) outlineView: (NSOutlineView*) outlineView setObjectValue: (id) object forTableColumn: (NSTableColumn*) tableColumn byItem: (id) item
{
	NSString* columnIdentifier = [tableColumn identifier];
	
	[item setValue: object forKey: columnIdentifier];
}


#pragma mark -
#pragma mark NSTableView Data Source Methods

- (NSInteger) numberOfRowsInTableView: (NSTableView*) tableView
{
	return [self numberOfRows];
}

- (id) tableView: (NSTableView*) tableView objectValueForTableColumn: (NSTableColumn*) column row: (NSInteger) row
{	
	return [self stringForRow:row];
}


#pragma mark -
#pragma mark NSTableView Delegate Methods

- (void) tableView: (NSTableView*) tableView willDisplayCell: (id) cell forTableColumn: (NSTableColumn*) tableColumn row: (NSInteger) row
{
	[cell setFont: [NSFont systemFontOfSize: 10.0]];
}


- (BOOL) tableView: (NSTableView*) tableView writeRows: (NSArray*) rows toPasteboard: (NSPasteboard*) pboard
{
	// Put rows in an NSIndexSet
	
	NSMutableIndexSet*	rowIndexes		= [NSMutableIndexSet indexSet];
	
	NSEnumerator*		rowEnumerator	= [rows objectEnumerator];
	NSNumber*			currentRow		= nil;
	
	while ((currentRow = [rowEnumerator nextObject]) != nil)
	{
		[rowIndexes addIndex: [currentRow intValue]];
	}
	
	return [self tableView: tableView writeRowsWithIndexes: rowIndexes toPasteboard: pboard];
}

- (BOOL) tableView: (NSTableView*) tableView writeRowsWithIndexes: (NSIndexSet*) rowIndexes toPasteboard: (NSPasteboard*) pboard
{
	// Replaces tableView:writeRows:toPasteboard: in 10.4
	
	
	BOOL written = NO;
	
	if (tableView == mBookmarkTableView)
	{
		[pboard declareTypes: @[DBBookmarkRows] owner: nil];
		
		if ([pboard setPropertyList: [rowIndexes arrayOfIndexes] forType: DBBookmarkRows])
		{
			written = YES;
		}
	}
	
	return written;
}


- (NSDragOperation) tableView: (NSTableView*) tableView validateDrop: (id <NSDraggingInfo>) info proposedRow: (NSInteger) row proposedDropOperation: (NSTableViewDropOperation) operation
{
	if (row == -1)
	{
		row			= [tableView numberOfRows];
		operation	= NSDragOperationGeneric;
		
		[tableView setDropRow: row dropOperation: operation];
	}
	
	if (operation == NSTableViewDropOn)
	{
		[tableView setDropRow: (row + 1) dropOperation: NSDragOperationGeneric];
	}
	
	return NSDragOperationGeneric;
}


- (BOOL) tableView: (NSTableView*) tableView acceptDrop: (id <NSDraggingInfo>) info row: (NSInteger) dropRow dropOperation: (NSTableViewDropOperation) operation;
{
	BOOL			accepted	= NO;
	NSPasteboard*	pboard		= [info draggingPasteboard];
	
	if (tableView == mBookmarkTableView)
	{
		NSArray* array = [pboard propertyListForType: DBBookmarkRows];
		
		if (array != NULL)
		{
			NSIndexSet* rowIndexes = [NSIndexSet indexSetFromArray: array];
			
			if (rowIndexes != nil)
			{
				dropRow = [mBookmarks moveObjectsAtIndexes: rowIndexes toIndex: dropRow];
			}
			
			if ([tableView selectedRow] > -1)
			{
				[tableView deselectAll: self];
				
				NSInteger index = [rowIndexes lastIndex];
				
				while (index != NSNotFound)
				{
					BOOL extendSelection = ([tableView allowsMultipleSelection] ? YES : NO);
					
					[tableView selectRow: dropRow byExtendingSelection: extendSelection];
					
					dropRow++;
					index = [rowIndexes indexLessThanIndex: index];
				}
			}
			
			[tableView reloadData];
			
			accepted = YES;
		}
	}
	
	if (accepted)
	{
		[self bookmarksChanged];
		[self updateBookmarksMenu];
	}
	
	return accepted;
}


@end


@implementation NSIndexSet (SGSAdditions)


// Creates an array of NSNumbers from the NSIndexSet

- (NSArray*) arrayOfIndexes
{
	NSMutableArray*	arrayOfIndexes	= [NSMutableArray array];
	NSInteger				index			= [self lastIndex];
	NSNumber*		number			= nil;
	
	while (index != NSNotFound)
	{
		number = @(index);
		
		if (number != nil)
		{
			[arrayOfIndexes addObject: number];
		}
		
		index = [self indexLessThanIndex: index];
	}
	
	return arrayOfIndexes;
}


// Creates an NSIndexSet from an array of NSNumbers

+ (NSIndexSet*) indexSetFromArray: (NSArray*) array
{
	NSMutableIndexSet*	indexSet		= [NSMutableIndexSet indexSet];
	NSEnumerator*		arrayEnumerator	= [array objectEnumerator];
	NSNumber*			currentNumber	= nil;
	NSInteger					newIndex		= 0;
	
	while ((currentNumber = [arrayEnumerator nextObject]) != nil)
	{
		if ([currentNumber isKindOfClass: [NSNumber class]])
		{
			newIndex = [currentNumber intValue];
			[indexSet addIndex: newIndex];
		}
	}
	
	return indexSet;
}


@end


@implementation NSMutableArray (SGSAdditions)


- (NSInteger) moveObjectsAtIndexes: (NSIndexSet*) indexSet toIndex: (NSInteger) index
{
	NSInteger				returnVal			= 0;
	NSMutableArray* objectsToMove		= (NSMutableArray*)[self objectsAtIndexes: indexSet];
	NSEnumerator*	objectEnumerator	= [objectsToMove reverseObjectEnumerator];
	id				currentObject		= nil;
	
	while ((currentObject = [objectEnumerator nextObject]) != nil)
	{
		NSInteger indexOfCurrentObject = [self indexOfObject: currentObject];
		
		[self removeObjectAtIndex: indexOfCurrentObject];
		
		if (indexOfCurrentObject <= index)
		{
			index--;
		}
	}
	
	returnVal			= index;
	objectEnumerator	= [objectsToMove reverseObjectEnumerator];
	
	while ((currentObject = [objectEnumerator nextObject]) != nil)
	{
		[self insertObject: currentObject atIndex: index];
	}
	
	return returnVal;
}


@end