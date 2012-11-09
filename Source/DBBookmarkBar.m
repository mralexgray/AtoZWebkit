/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBBookmarkBar.h"

#import "DBBookmark.h"
#import "DBBookmarkBarCell.h"
#import "DBBookmarkController.h"
#import "DBBookmarkBarPopUpButton.h"


const CGFloat kDistanceBetweenBookmarks = 5;

@interface DBBookmarkBar (Private)

- (CGFloat) maxRightEdgeForCells;

- (void) drawBackgroundInRect: (NSR) rect;
- (void) drawCellsInRect: (NSR) rect;
- (void) drawDragIndicatorInRect: (NSR) rect;

- (void) arrangeDBBookmarkBarCells;

- (void) setUpPopUpButton;
- (void) adjustPopUpButtonPosition;
- (void) removeAllBookmarksFromPopUpButton;
- (void) addBookmarkCellToPopUpButton: (id <DBBookmarkBarCell>) DBBookmarkBarCell;
- (void) removePopUpButton;
- (void) addPopUpButton;

@end


@implementation DBBookmarkBar

- (id) initWithFrame: (NSR) frame
{
	 if (self = [super initWithFrame: frame])
	{
		mBookmarkCells		= [[NSMutableArray alloc] init];
		mBackgroundColor	= [NSColor colorWithDeviceRed: 0.35 green: 0.35 blue: 0.35 alpha: 1.0];
		
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reloadData) name: kBookmarksDidChangeNotification object: nil];
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(frameDidChange:) name: NSViewFrameDidChangeNotification object: self];
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(frameDidChange:) name: NSViewBoundsDidChangeNotification object: self];
		
		[self setPostsFrameChangedNotifications: YES];
		[self setPostsBoundsChangedNotifications: YES];
		
		[self registerForDraggedTypes: @[DBBookmarkCellPboardType]];
	}
	
	return self;
}

- (void) awakeFromNib
{
	[self setUpPopUpButton];
	
	mLastFrame = [self frame];
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	
	[mBookmarkController release];
	[mBackgroundColor release];
	[mExtraBookmarksPopUpButton	release];
	[mBookmarkCells release];
	
}


#pragma mark -

- (void) drawRect: (NSR) rect
{
	[self drawBackgroundInRect: [self bounds]];//rect];
	[self drawCellsInRect: rect];
}


#pragma mark -


- (void) setBookmarkController: (DBBookmarkController*) bookmarkController
{
	if (bookmarkController != mBookmarkController)
	{
		[mBookmarkController release];
		
		mBookmarkController = bookmarkController;
		
		[self reloadData];
	}
}

- (void) frameDidChange: (NSNotification*) notification
{
	NSR frame = [self frame];
	
	if (frame.size.width != mLastFrame.size.width)
	{
		[self arrangeDBBookmarkBarCells];
	}
	
	mLastFrame = frame;
}

- (void) reloadData
{
	[self removeAllBookmarksFromPopUpButton];	
	[mBookmarkCells removeAllObjects];
	
	CGFloat			maxRightEdge		= [self maxRightEdgeForCells];
	
	NSEnumerator*	bookmarkEnumerator	= [mBookmarkController bookmarkEnumerator];
	DBBookmark*		currentBookmark		= nil;
	
	while ((currentBookmark = [bookmarkEnumerator nextObject]) != nil)
	{
		id <DBBookmarkBarCell> DBBookmarkBarCell = [currentBookmark cell];
		
		if (DBBookmarkBarCell != nil)
		{
			[mBookmarkCells addObject: DBBookmarkBarCell];
			
			if (maxRightEdge > NSMaxX([DBBookmarkBarCell frame]))
			{
				[self addBookmarkCellToPopUpButton: DBBookmarkBarCell];
			}
		}
	}
	
	[self arrangeDBBookmarkBarCells];
		
	[self setNeedsDisplay: YES];
}

- (id <DBBookmarkBarCell>) bookmarkCellAtPoint: (NSP) point
{
	id <DBBookmarkBarCell>	bookmarkCell	= nil;
	
	CGFloat					maxRightEdge	= [self maxRightEdgeForCells];
	
	NSEnumerator*			cellEnumerator	= [mBookmarkCells objectEnumerator];
	id <DBBookmarkBarCell>	currentCell		= nil;
	
	while ((currentCell = [cellEnumerator nextObject]) != nil)
	{
		NSR cellFrame = [currentCell frame];
		
		if (NSMaxX(cellFrame) < maxRightEdge)
		{
			if (NSPInRect(point, [currentCell frame]))
			{
				bookmarkCell = currentCell;
				break;
			}
		}
		else
		{
			break;
		}
	}
	
	return bookmarkCell;
}

- (unsigned) indexClosestToPoint: (NSP) point
{
	unsigned returnIndex = 0;
	
	CGFloat						maxRightEdge		= [self maxRightEdgeForCells];
	NSR						lastCellFrame		= NSZeroRect;
	
	NSEnumerator*				cellEnumerator		= [mBookmarkCells objectEnumerator];
	id <DBBookmarkBarCell>	currentCell			= nil;
	unsigned					currentCellIndex	= 0;
	
	while ((currentCell = [cellEnumerator nextObject]) != nil)
	{
		NSR cellFrame = [currentCell frame];
		
		if (NSMaxX(cellFrame) > maxRightEdge || (point.x < NSMidX(cellFrame) && point.x > NSMidX(lastCellFrame)))
		{
			returnIndex = currentCellIndex;
			break;
		}
		
		lastCellFrame = cellFrame;
		
		currentCellIndex++;
	}
	
	return returnIndex;
}

- (void) setVisiblePosition: (NSP) position
{
	NSR frame = [self frame];
	[self setFrame: NSMakeRect(position.x, position.y, frame.size.width, frame.size.height)];
}


#pragma mark -

- (void) mouseDown: (NSEvent*) event
{
	NSP						clickPoint	= [self convertPoint: [event locationInWindow] fromView: nil];
	id <DBBookmarkBarCell>	clickedCell = [self bookmarkCellAtPoint: clickPoint];
	
	[clickedCell mouseDown: event];
}

- (void) mouseUp: (NSEvent*) event
{
	NSP						clickPoint	= [self convertPoint: [event locationInWindow] fromView: nil];
	id <DBBookmarkBarCell>	clickedCell = [self bookmarkCellAtPoint: clickPoint];
	
	[clickedCell mouseUp: event];
}

- (void) mouseDragged: (NSEvent*) event
{
	NSPasteboard*				pboard		= [NSPasteboard pasteboardWithName: NSDragPboard];
	NSP						clickPoint	= [self convertPoint: [event locationInWindow] fromView: nil];
	id <DBBookmarkBarCell>	clickedCell = [self bookmarkCellAtPoint: clickPoint];
	
	if (clickedCell != nil)
	{
		NSInteger			indexOfCellInArray	= [mBookmarkCells indexOfObject: clickedCell];
		NSNumber*	numberIndexOfCell	= @(indexOfCellInArray);
		
		[pboard declareTypes: @[DBBookmarkCellPboardType] owner: self];
		[pboard setPropertyList: numberIndexOfCell forType: DBBookmarkCellPboardType];
		
		
		NSImage* dragImage = [clickedCell dragImage];
		
		if (dragImage != nil)
		{
			[self dragImage: [clickedCell dragImage] at: [clickedCell frame].origin offset: NSZeroSize event: event pasteboard: pboard source: self slideBack: YES];
		}
	}
}


#pragma mark -

- (NSA*) menuItemsForPopUpButton: (NSPopUpButton*) popUpButton
{
	NSMutableArray*				menuItems		= [NSMutableArray array];
	BOOL						fillNow			= NO;
	
	CGFloat						maxRightEdge	= [self maxRightEdgeForCells];
	
	NSEnumerator*				cellEnumerator	= [mBookmarkCells objectEnumerator];
	id <DBBookmarkBarCell>	currentCell		= nil;
	
	while ((currentCell = [cellEnumerator nextObject]) != nil)
	{
		if (!fillNow)
		{
			if (NSMaxX([currentCell frame]) >= maxRightEdge)
			{
				fillNow = YES;
			}
		}
		
		if (fillNow)
		{
			NSMenuItem* cellMenuItem = [currentCell menuItem];
			
			if (cellMenuItem != nil)
			{
				[menuItems addObject: cellMenuItem];
			}
		}
	}
	
	return menuItems;
}


@end

#pragma mark -


@implementation DBBookmarkBar (DraggingDesitination)


- (NSDragOperation) draggingSourceOperationMaskForLocal: (BOOL) flag
{
	NSDragOperation operation = NSDragOperationNone;
	
	if (flag)
	{
		operation = NSDragOperationGeneric;
	}
	
	return operation;
}

- (NSUI) draggingEntered: (id <NSDraggingInfo>) sender
{
	NSDragOperation returnOperation	= NSDragOperationNone;
	NSDragOperation operation		= [sender draggingSourceOperationMask];
	NSPasteboard*	pboard			= [sender draggingPasteboard];
	
	if (operation == NSDragOperationGeneric)
	{
		id <DBBookmarkBarCell> draggedCell = [pboard propertyListForType: DBBookmarkCellPboardType];
		
		if (draggedCell != nil)
		{
			returnOperation	= NSDragOperationGeneric;
			mDragging		= YES;
			
			[self setNeedsDisplay: YES];
		}
	}
	
	return returnOperation;
}

- (NSDragOperation) draggingUpdated: (id <NSDraggingInfo>) sender
{
	NSDragOperation returnOperation	= NSDragOperationNone;
	NSDragOperation operation		= [sender draggingSourceOperationMask];
	NSPasteboard*	pboard			= [sender draggingPasteboard];
	
	if (operation == NSDragOperationGeneric)
	{
		id <DBBookmarkBarCell> draggedCell = [pboard propertyListForType: DBBookmarkCellPboardType];
		
		if (draggedCell != nil)
		{
			NSP mouseLocation = [[self window] convertScreenToBase: [NSEvent mouseLocation]];
			
			if (mouseLocation.x != mLastMouseX)
			{
				mDragging		= YES;
				mLastMouseX		= mouseLocation.x;
				returnOperation	= NSDragOperationGeneric;
				
				[self setNeedsDisplay: YES];
			}
		}
	}
	
	return returnOperation;
}

- (void) draggingExited: (id <NSDraggingInfo>) sender
{
	mDragging = NO;
	[self setNeedsDisplay: YES];
}


#pragma mark -

- (BOOL) prepareForDragOperation: (id <NSDraggingInfo>) sender
{
	return YES;
}

- (BOOL) performDragOperation: (id <NSDraggingInfo>) sender
{
	BOOL			perform					= NO;
	NSP			dragLocation			= [self convertPoint: [sender draggingLocation] fromView: nil];
	NSPasteboard*	pboard					= [sender draggingPasteboard];
	NSNumber*		indexOfDraggedBookmark	= [pboard propertyListForType: DBBookmarkCellPboardType];
	
	if (indexOfDraggedBookmark != nil)
	{
		mDragging			= NO;
		perform				= YES;
		
		unsigned fromIndex	= [indexOfDraggedBookmark intValue];
		unsigned toIndex	= [self indexClosestToPoint: dragLocation];
		
		if (fromIndex != toIndex)
		{
			[mBookmarkController bookmarkDraggedFromIndex: fromIndex toIndex: toIndex];
			
			[self reloadData];
		}
	}
	
	return perform;
}

- (void) concludeDragOperation: (id <NSDraggingInfo>) sender
{
	[self setNeedsDisplay: YES];
}


@end

#pragma mark -


@implementation DBBookmarkBar (Private)


- (CGFloat) maxRightEdgeForCells
{
	CGFloat	maxRightEdge	=  0;
	NSR	frameRect		= [self frame];
	
	if ([mExtraBookmarksPopUpButton superview] == self)
	{
		maxRightEdge = frameRect.size.width - [mExtraBookmarksPopUpButton frame].size.width - kDistanceBetweenBookmarks;
	}
	else
	{
		maxRightEdge = frameRect.size.width - kDistanceBetweenBookmarks;
	}
	
	return maxRightEdge;
}


#pragma mark -

- (void) drawBackgroundInRect: (NSR) rect
{
//	[mBackgroundColor set];
//	[[NSColor whiteColor] set];
	[GRAY3 set];
	NSRFill(rect);
//	NSImage* image = [NSImage imageNamed: @"bb-top-bookmark-stretch"];
//	[image drawInRect: rect fromRect: NSMakeRect(0, 0, [image size].width, [image size].height) operation: NSCompositeCopy fraction: 1.0];
}

- (void) drawCellsInRect: (NSR) rect
{
	NSP					mouseLocation		= [[self window] convertScreenToBase: [NSEvent mouseLocation]];//[self convertPoint: [[[NSApp mainWindow] currentEvent] locationInWindow] fromView: nil];
	NSR					frameRect			= [self frame];
	//NSR					frameMinusPadding	= NSMakeRect(frameRect.origin.x - kDistanceBetweenBookmarks, frameRect.origin.y, frameRect.size.width - (2 * kDistanceBetweenBookmarks), frameRect.size.height);
	
	CGFloat					maxRightEdge		= [self maxRightEdgeForCells];
	NSR					lastCellFrame		= NSZeroRect;
	
	NSEnumerator*			cellEnumerator		= [mBookmarkCells objectEnumerator];
	id <DBBookmarkBarCell>	currentCell			= nil;
	
	while ((currentCell = [cellEnumerator nextObject]) != nil)
	{
		NSR cellFrame = [currentCell frame];
		
		if (mDragging)
		{
			if (mouseLocation.x < NSMidX(cellFrame) && mouseLocation.x > NSMidX(lastCellFrame))
			{
				CGFloat	positionOfIndicator		= NSMaxX(lastCellFrame) + (NSMinX(cellFrame) - NSMaxX(lastCellFrame)) / 2;
				NSR	rectForDragIndicator	= NSMakeRect(positionOfIndicator, 0, 1, NSHeight(frameRect) - 2);
				
				[self drawDragIndicatorInRect: rectForDragIndicator];
			}
		}
		
		if (NSMaxX(cellFrame) < maxRightEdge)
		{
			if (NSIntersectsRect(rect, cellFrame))
			{
				[currentCell drawWithFrame: cellFrame inView: self];
			}
		}
		else
		{
			break;
		}
		
		lastCellFrame = cellFrame;
	}
}

- (void) drawDragIndicatorInRect: (NSR) rect
{
	[[NSColor lightGrayColor] set];

	NSRFill(rect);
}


#pragma mark -

- (void) arrangeDBBookmarkBarCells
{
	[self adjustPopUpButtonPosition];
	
	NSR					frameRect					= [self frame];
	//NSR					frameMinusPadding			= NSMakeRect(frameRect.origin.x - kDistanceBetweenBookmarks, frameRect.origin.y, frameRect.size.width - (2 * kDistanceBetweenBookmarks), frameRect.size.height);
	
	unsigned				currentCellIndex			= 0;
	unsigned				numberOfCells				= [mBookmarkCells count];
	
	NSEnumerator*			DBBookmarkBarCellEnumerator	= [mBookmarkCells objectEnumerator];
	id <DBBookmarkBarCell>	currentCell					= nil;
	NSR					lastCellFrame				= NSMakeRect(0, 3, 0, 16);
	
	while ((currentCell = [DBBookmarkBarCellEnumerator nextObject]) != nil)
	{
		NSR	cellFrame		= [currentCell frame];
		NSR	newCellFrame	= lastCellFrame;
		
		newCellFrame.origin.x	= NSMaxX(lastCellFrame) + kDistanceBetweenBookmarks;
		newCellFrame.size.width = cellFrame.size.width;
		
		
		[currentCell setFrame: newCellFrame];
		
		if (currentCellIndex == numberOfCells - 1)
		{
			if (NSMaxX(newCellFrame) < (frameRect.size.width - kDistanceBetweenBookmarks))
			{
				[self removePopUpButton];
			}
			else
			{
				[self addPopUpButton];
			}
		}
		
		
		lastCellFrame = newCellFrame;
		currentCellIndex++;
	}
}


#pragma mark -

- (void) setUpPopUpButton
{
	NSR popUpButtonFrame		= NSMakeRect(0, 3, 51, 15);
	mExtraBookmarksPopUpButton	= [[DBBookmarkBarPopUpButton alloc] initWithFrame: popUpButtonFrame];
	
	[self adjustPopUpButtonPosition];
}

- (void) adjustPopUpButtonPosition
{
	NSR frame	= [mExtraBookmarksPopUpButton frame];
	frame.origin.x	= NSWidth([self frame]) - NSWidth(frame) - kDistanceBetweenBookmarks;
	
	[mExtraBookmarksPopUpButton setFrame: frame];
}

- (void) removeAllBookmarksFromPopUpButton
{
	[mExtraBookmarksPopUpButton removeAllItems];
}

- (void) addBookmarkCellToPopUpButton: (id <DBBookmarkBarCell>) DBBookmarkBarCell
{
	NSMenu*		menu		= [mExtraBookmarksPopUpButton menu];
	NSMenuItem*	menuItem	= [DBBookmarkBarCell menuItem];
	
	if (menuItem != nil)
	{
		[menu addItem: menuItem];
	}
	
}

- (void) removePopUpButton
{
	if ([mExtraBookmarksPopUpButton superview] == self)
	{
		[mExtraBookmarksPopUpButton removeFromSuperview];
	}
}

- (void) addPopUpButton
{
	if ([mExtraBookmarksPopUpButton superview] != self)
	{
		[self addSubview: mExtraBookmarksPopUpButton];
	}
}


@end