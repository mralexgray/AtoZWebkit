/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBBezelTableView.h"


@implementation DBBezelTableView


- (void) awakeFromNib
{
	DBBezelScroller* scroller = [[DBBezelScroller alloc] init];

	[[self enclosingScrollView] setVerticalScroller: scroller];
	[scroller release];

	// This is the color used in all our bezel windows
	//NSColor* backgroundColor = [NSColor colorWithDeviceRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.7];
	NSColor* backgroundColor = [NSColor clearColor];
	
	[self setBackgroundColor: backgroundColor];
	[self setGridColor: backgroundColor];
	[self setGridStyleMask: NSTableViewGridNone];
	[self setIntercellSpacing: NSMakeSize(0, 0)];


	NSEnumerator*	columnEnumerator	= [[self tableColumns] objectEnumerator];
	NSTableColumn*	currentTableColumn	= nil;
	
	while ((currentTableColumn = [columnEnumerator nextObject]) != nil)
	{
		DBBezelDataCell* newDataCell = [[DBBezelDataCell alloc] init];
		
		[currentTableColumn setDataCell: newDataCell];
		[newDataCell release];
	}

	// Have to do this so the columns size themselves properly before display
	NSR frame	= [self frame];
	NSR newFrame	= frame;
	
	newFrame.size.width = newFrame.size.width + 1;
	
	[self setFrame: newFrame];
	[self setFrame: frame];
}

- (BOOL) performKeyEquivalent: (NSEvent*) event
{
	BOOL handled = NO;
	
	if (self == [[self window] firstResponder])
	{
		NSString* characters = [event charactersIgnoringModifiers];
		
		if ([characters length] == 1)
		{
			unichar character = [characters characterAtIndex: 0];
			
			if (character == NSDeleteFunctionKey || character == 0x7F)
			{
				id delegate = [self delegate];
				
				if (delegate != nil)
				{
					if ([delegate respondsToSelector: @selector(tableViewDeleteKeyPressed:)])
					{
						[delegate performSelector:@selector(tableViewDeleteKeyPressed:) withObject:self];
						handled = YES;
					}
				}
			}
		}
	}
	
	if (!handled)
	{
		handled = [super performKeyEquivalent: event];
	}
	
	return handled;
}


#pragma mark -
#pragma mark Drag and Drop

/*- (NSImage*) dragImageForRowsWithIndexes: (NSIndexSet*) dragRows tableColumns: (NSA*) tableColumns event: (NSEvent*) dragEvent offset: (NSPPointer) dragImageOffset
{

	// Get our superclass's image -- it's a good starting point.
	NSImage*	superImage		= [super dragImageForRowsWithIndexes: dragRows tableColumns: tableColumns event: dragEvent offset: dragImageOffset];
	NSSize		superImageSize	= [superImage size];
	
	// Allocate an image which is just a bit larger.
	NSR imageRect;
	imageRect.origin.x		= 0.0f;
	imageRect.origin.y		= 0.0f;
	imageRect.size.width	= superImageSize.width + 3.0f;
	imageRect.size.height	= superImageSize.height + 2.0f;
	
	NSImage* newImage = [[[NSImage alloc] initWithSize: imageRect.size] autorelease];
	[newImage lockFocus];
	
	// Create a transparent row-sized fill.
	[[[NSColor colorWithDeviceRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.77] colorWithAlphaComponent: kDragImageAlpha] set];
//	NSRFill(imageRect);
	
	// Frame it with transparent black.
	[[NSColor blackColor] set];
//	NSFrameRectWithWidthUsingOperation(imageRect, 1.0f, NSCompositeDestinationOver);
	
	// Draw our superclass's image underneath the fill.
	[superImage compositeToPoint: NSMakePoint(1.0f, 1.0f) operation: NSCompositeDestinationOver];
	
	// End drawing
	[newImage unlockFocus];
	
	return newImage;
}*/

- (NSUI) draggingSourceOperationMaskForLocal: (BOOL) isLocal
{
	NSUInteger operation = NSDragOperationNone;
	
	if (isLocal)
	{
		operation = NSDragOperationMove;
	}
	
	return operation;
}


@end