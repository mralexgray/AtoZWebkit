/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBHistoryView.h"
#import "DBHistoryController.h"

@implementation DBHistoryView

////-------------------------------------------------
//		initWithFrame:
////-------------------------------------------------
- (id) initWithFrame: (NSR) frame
{
	if(self = [super initWithFrame: frame])
	{
		textColor				= [NSColor colorWithDeviceRed: 0.8 green: 0.8 blue: 0.8 alpha: 1.0];
		selectedTextColor		= [NSColor whiteColor];
		finishedTextColor		= [NSColor colorWithDeviceRed: 0.8 green: 0.8 blue: 0.8 alpha: 0.5];
		
		textSize				= 10;
		textAttributes			= [[NSMD alloc] init];
		
		rowHeight				= 18;
		topPadding				= 30;
		
		[textAttributes setValue: textColor								forKey: NSForegroundColorAttributeName];
		[textAttributes setValue: [NSFont systemFontOfSize: textSize]	forKey: NSFontAttributeName];
		
		selectedRow				= -1;
	}
	
	return self;
}

////-------------------------------------------------
//		acceptsFirstResponder
////-------------------------------------------------
- (BOOL) acceptsFirstResponder
{
	return YES;
}

////-------------------------------------------------
//		dealloc
////-------------------------------------------------
//- (void) dealloc
//{
//	[delegate			release];
//	[textColor			release];
//	[selectedTextColor	release];
//	[finishedTextColor	release];
//	[textAttributes		release];
//	
//}

////-------------------------------------------------
//		setDelegate:
////-------------------------------------------------
- (void) setDelegate: (id) object
{
//	[delegate release];
	delegate = object;
	[self setNeedsDisplay: YES];
}

////-------------------------------------------------
//		drawRect:
////-------------------------------------------------
- (void) drawRect: (NSR) rect
{
	if (delegate != nil)
	{
		NSR			displayArea			= NSMakeRect([self frame].origin.x + 20, [self frame].origin.y, [self frame].size.width - 40, [self frame].size.height);
		NSR			dateArea			= NSMakeRect(displayArea.origin.x, displayArea.origin.y, displayArea.size.width, displayArea.size.height);
		NSR			pageArea			= NSMakeRect(displayArea.origin.x + 20, displayArea.origin.y, displayArea.size.width - 20, displayArea.size.height);
		
		NSInteger				dates				= [delegate numberOfDates];
		
		NSInteger				itemsForCurrentDate	= 0;
		NSInteger				currentDrawRow		= 1;
		NSCalendarDate*	currentDate			= nil;
		NSS*		pageString			= nil;
		NSS*		dateString			= nil;
		NSInteger i;
		NSInteger j;
		// Draw history items
		for (i = 0; i < dates; i++)
		{
			if(currentDrawRow == selectedRow)
			{
				[textAttributes setValue: selectedTextColor forKey: NSForegroundColorAttributeName];
			}
			else
			{
				[textAttributes setValue: textColor forKey: NSForegroundColorAttributeName];
			}
			
			currentDate		= [delegate dateAtIndex: i];
			dateString		= [currentDate descriptionWithCalendarFormat: @"%m/%d/%Y"];
			dateString		= [self string: dateString withAttributes: textAttributes constrainedToWidth: dateArea.size.width];
			
			[dateString drawAtPoint: NSMakePoint(dateArea.origin.x, dateArea.size.height - (currentDrawRow * rowHeight))	withAttributes: textAttributes];
			itemsForCurrentDate = [delegate numberOfItemsForDate: currentDate];
			currentDrawRow		+= 1;
			
			for (j = 0; j < itemsForCurrentDate; j++)
			{
				if(currentDrawRow == selectedRow)
				{
					[textAttributes setValue: selectedTextColor forKey: NSForegroundColorAttributeName];
				}
				else
				{
					[textAttributes setValue: textColor forKey: NSForegroundColorAttributeName];
				}
				
				pageString		= [delegate objectForDate: currentDate index: j]; 
				pageString		= [self string: pageString withAttributes: textAttributes constrainedToWidth: pageArea.size.width];
				
				[pageString drawAtPoint: NSMakePoint(pageArea.origin.x, pageArea.size.height - (currentDrawRow * rowHeight))	withAttributes: textAttributes];
				
				currentDrawRow	+= 1;
			}
		}
	}
}

////-------------------------------------------------
//		string:withAttributes:contstrainedToWidth:
////-------------------------------------------------
- (NSS*) string: (NSS*) string withAttributes: (NSD*) attributes constrainedToWidth: (CGFloat) width
{
	NSS*	fixedString		= string;
	NSS*	currentString	= [string stringByAppendingString: @"..."];
	NSSZ		stringSize		= [currentString sizeWithAttributes: attributes];
	
	if(stringSize.width > width)
	{
		NSInteger i = [string length];
		while([currentString sizeWithAttributes: attributes].width > width)
		{
			if(i > 0)
			{
				currentString = [[string substringToIndex: i] stringByAppendingString: @"..."];
				i--;
			}
			else
			{
				currentString = @"";
				break;
			}
		}
		
		fixedString = currentString;
	}
	
	return fixedString;
}

////-------------------------------------------------
//		setTextColor:
////-------------------------------------------------
- (void) setTextColor: (NSColor*) color
{
//	[textColor release];
	textColor = color;
	
	[textAttributes setValue: textColor forKey: NSForegroundColorAttributeName];
}

////-------------------------------------------------
//		setTextSize:
////-------------------------------------------------
- (void) setTextSize: (NSI) size
{
	textSize = size;
	
	[textAttributes setValue: [NSFont systemFontOfSize: textSize] forKey: NSFontAttributeName];
}

////-------------------------------------------------
//		mouseDown:
////-------------------------------------------------
- (void) mouseDown: (NSEvent*) theEvent
{
	if(delegate != nil)
	{
		NSP clickPoint	= [self convertPoint: [theEvent locationInWindow] fromView: nil];
		CGFloat	clickPointY	= (([self frame].origin.y + [self frame].size.height) - 5) - clickPoint.y;
		
		selectedRow			= ceil(clickPointY / rowHeight);
		
		if (selectedRow > [delegate numberOfRows] || [delegate isDateAtIndex: selectedRow - 1])
		{
			selectedRow	= -1;
		}
		else
		{
			[delegate rowClicked: selectedRow];
		}
		
		if ([theEvent clickCount] > 1 && selectedRow > -1) {
			[delegate loadSelected];
		}
		[self setNeedsDisplay: YES];
	}
}

////-------------------------------------------------
//		keyDown:
////-------------------------------------------------
- (void) keyDown: (NSEvent*) theEvent
{
	NSInteger		row			= [self selectedRow];
	NSInteger		keyCode		= [theEvent keyCode];
//	unichar	character	= [DBKeyStuff characterForKeyCode: keyCode];
	if(row > -1)
	{
//		if(character == NSDeleteFunctionKey)
//		{
//			[delegate removeSelected];
//		}
	}
}

////-------------------------------------------------
//		reloadData:
////-------------------------------------------------
- (void) reloadData
{
	if (delegate != nil)
	{
		[self updateSelectedRow];
		
		CGFloat newHeight = ([delegate numberOfRows] * rowHeight);
		
		if ([[self enclosingScrollView] frame].size.height > newHeight)
		{
			newHeight = [[self enclosingScrollView] frame].size.height;
		}
		
		[self setFrame: NSMakeRect([self frame].origin.x, [self frame].origin.y, [self frame].size.width, newHeight)];
		
		[self setNeedsDisplay: YES];
	}
	else
	{
		NSLog(@"HistoryController has no delegate");
	}
}
- (NSI) selectedRow
{
	return selectedRow;
}
- (void) updateSelectedRow
{
	NSInteger numberOfRows = [delegate numberOfRows];
	
	if(selectedRow > numberOfRows - 1 || [delegate isDateAtIndex: selectedRow - 1])
	{
		selectedRow = -1;
	}
}

@end
