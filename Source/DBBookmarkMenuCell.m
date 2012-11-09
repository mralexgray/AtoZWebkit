/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBBookmarkMenuCell.h"

#import "DBBookmarkBarCell.h"




@implementation DBBookmarkMenuCell


- (id) init
{
	if (self = [super init])
	{
		mDefaultColor	= [NSColor colorWithDeviceRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.0];
		mMouseOverColor = [NSColor colorWithDeviceRed: 0.7 green: 0.7 blue: 0.7 alpha: 0.4];
		mMouseDownColor	= [NSColor colorWithDeviceRed: 0.55 green: 0.55 blue: 0.55 alpha: 0.4];
		
		[self setFont: [NSFont systemFontOfSize: 10.0]];
//		[self sendActionOn: 0];
		[self setPullsDown: YES];
	}
	
	return self;
}

- (void) dealloc
{
	[mControlView release];
	[mStringValue release];
	[mDefaultColor release];
	[mMouseOverColor release];
	[mMouseDownColor release];
	
}


#pragma mark -

- (void) setFrame: (NSR) frame
{
	mFrame = frame;
	
	[self resetTrackingRect];
}

- (NSR) frame
{
	return mFrame;
}


#pragma mark -

- (NSR) textFrameForFrame: (NSR) frame
{
	NSR textFrame = NSMakeRect(frame.origin.x + DBPaddingOnSidesOfTextFrame, frame.origin.y, frame.size.width - DBPaddingOnSidesOfTextFrame * 2, frame.size.height);
	
	return textFrame;
}

- (NSD*) textAttributes
{
	return [NSDictionary dictionaryWithObjects: @[[NSColor blackColor], [self font]] forKeys: @[@"NSColor", NSFontAttributeName]];
}


#pragma mark -

- (void) drawBackgroundInFrame: (NSR) frame
{
	NSColor* backgroundColor = mDefaultColor;
		
	if (mMouseDown)
	{
		backgroundColor = mMouseDownColor;
	}
	else if (mMouseOver)
	{
		backgroundColor = mMouseOverColor;
	}
	
	[backgroundColor set];
	[NSBezierPath fillRoundRectInRect: frame radius: 15];
}

- (void) drawTextInFrame: (NSR) frame
{
	NSR			textFrame			= [self textFrameForFrame: frame];
	NSDictionary*	stringAttributes	= [self textAttributes];
	NSString*		drawText			= [[self stringValue] truncatedToWidth: textFrame.size.width withAttributes: stringAttributes];
	NSSize			stringSize			= [drawText sizeWithAttributes: stringAttributes];
	
	if (stringSize.width < textFrame.size.width)
	{
		CGFloat extraWidth	= textFrame.size.width - stringSize.width;
		textFrame.origin.x	= textFrame.origin.x + extraWidth / 2;
	}
	
	if (stringSize.height < NSHeight(textFrame))
	{
		textFrame.origin.y += (NSHeight(textFrame) - stringSize.height) / 2;
	}
	
	textFrame.size.height = stringSize.height;
	
	[drawText drawInRect: textFrame withAttributes: stringAttributes];
}

- (void) drawArrow: (NSR) frame
{
//	[[NSColor colorWithDeviceWhite: 0.85 alpha: 1.0] set];
	[[NSColor blackColor] set];
	
	NSBezierPath* path = [NSBezierPath bezierPath];
	[path moveToPoint: NSMakePoint(NSMinX(frame), NSMaxY(frame))];
	[path lineToPoint: NSMakePoint(NSMaxX(frame), NSMaxY(frame))];
	[path lineToPoint: NSMakePoint(NSMidX(frame), NSMinY(frame))];
	[path lineToPoint: NSMakePoint(NSMinX(frame), NSMaxY(frame))];
	[path fill];
}

- (void) drawWithFrame: (NSR) cellFrame inView: (NSView*) controlView
{
	if (controlView != mControlView)
	{
		[mControlView release];
		
		mControlView = controlView;
		
		[self resetTrackingRect];
	}
	else if (mTrackingRectTag == 0)
	{
		[self resetTrackingRect];
	}
	
		
	[self drawBackgroundInFrame: cellFrame];
	[self drawTextInFrame: cellFrame];
	NSR arrowRect = NSMakeRect(NSMaxX(cellFrame) - 9, cellFrame.origin.y + 5, 6, NSHeight(cellFrame) - 12);
	[self drawArrow: arrowRect];
}


#pragma mark -

- (void) mouseDown: (NSEvent*) event
{
	mMouseDown = YES;
	
	[mControlView setNeedsDisplayInRect: mFrame];
}

- (void) mouseUp: (NSEvent*) event
{
	mMouseDown = NO;
		
	[mControlView setNeedsDisplayInRect: mFrame];
	
	if (mPopUpMenuVisible)
	{
		[self dismissPopUp];
	}
	else
	{
		[self performClickWithFrame: mFrame inView: mControlView];
	}
}


#pragma mark -

- (void) mouseEntered: (NSEvent*) event
{
	mMouseOver = YES;
	
	[mControlView setNeedsDisplayInRect: mFrame];
}

- (void) mouseExited: (NSEvent*) event
{
	mMouseOver	= NO;
	mMouseDown	= NO;
	
	[mControlView setNeedsDisplayInRect: mFrame];
}

- (void) resetTrackingRect
{
	if (mTrackingRectTag > 0)
	{
		[mControlView removeTrackingRect: mTrackingRectTag];
	}
	
	NSP mouseLocation	= [[mControlView window] mouseLocationOutsideOfEventStream];
	BOOL	mouseInFrame	= NSMouseInRect(mouseLocation, mFrame, NO);
	
	mTrackingRectTag = [mControlView addTrackingRect: mFrame owner: self userData: nil assumeInside: mouseInFrame];


	if (mouseInFrame)
	{
		if (!mMouseOver || !mMouseDown)
		{
			[self mouseEntered: nil];
		}
	}
	else
	{
		if (mMouseOver || mMouseDown)
		{
			[self mouseExited: nil];
		}
	}
}


#pragma mark -

- (NSString*) stringValue
{
	return mStringValue;
}

- (void) setStringValue: (NSString*) stringValue
{
	// I don't know why -[super setStringValue:] doesn't work... it just sets stringValue to 0, so use our own ivar.
	//
	// [super setStringValue: stringValue];
	
	if (stringValue != mStringValue)
	{
		[mStringValue release];
		mStringValue = [stringValue copy];
		
		NSR			frame				= mFrame;
		NSDictionary*	stringAttributes	= [self textAttributes];
		NSSize			stringSize			= [[self stringValue] sizeWithAttributes: stringAttributes];
		CGFloat			desiredWidth		= stringSize.width + DBPaddingOnSidesOfTextFrame * 2;
		CGFloat			newWidth			= (desiredWidth <= DBBookmarkCellMaximumWidth) ? desiredWidth : DBBookmarkCellMaximumWidth;
		
		[self setFrame: NSMakeRect(frame.origin.x, frame.origin.y, newWidth, frame.size.height)];
	}
}

- (void) setMenu: (NSMenu*) menu
{
	[super setMenu: menu];
}


#pragma mark -

- (NSImage*) dragImage
{
	NSImage*	dragImage	= nil;
	NSSize		imageSize	= mFrame.size;


	dragImage = [[[NSImage alloc] initWithSize: imageSize] autorelease];
	
	[dragImage lockFocus];
	{
		[self drawWithFrame: NSMakeRect(0, 0, imageSize.width, imageSize.height) inView: mControlView];
	}
	[dragImage unlockFocus];


	return dragImage;
}

- (NSMenuItem*) menuItem
{
	NSString*	menuItemTitle	= (mStringValue == nil) ? @"" : mStringValue;
	NSMenuItem* menuItem		= [[[NSMenuItem alloc] initWithTitle: menuItemTitle action: [self action] keyEquivalent: @""] autorelease];
	
	[menuItem setSubmenu: [self menu]];
	
	return menuItem;
}


@end