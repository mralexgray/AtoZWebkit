/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBBezelWindow.h"

@implementation DBBezelWindow

- (id) initWithContentRect: (NSR) contentRect styleMask: (NSUI) aStyle backing: (NSBackingStoreType) bufferingType defer: (BOOL) flag
{
	if (self = [super initWithContentRect: contentRect styleMask: NSBorderlessWindowMask backing: bufferingType defer: flag])
	{
//		[self setAboveMainWindowLevel: YES]; // Only use this if you want the bezel windows to CGFloat
		[self setOpaque: YES];
		[self setBackgroundColor: BLACK];//[NSColor clearColor]];
		[self setAlphaValue: 1.0];
		[self setHasShadow: YES];
	}
	
	 return self;
}
- (BOOL) canBecomeKeyWindow
{
	return YES;
}
- (BOOL) acceptsFirstResponder
{
	return YES;
}
- (void) mouseDown: (NSEvent*) theEvent
{
	 dragStartLocation	= [theEvent locationInWindow];
	NSP origin		= [self frame].origin;
	NSSZ	size		= [self frame].size;
	/*if (((origin.y + dragStartLocation.y) > ((origin.y + size.height) - 19)))
	{
		moving		= YES;
		resizing	= NO;
	}
	else*/ if ((origin.x + dragStartLocation.x) >= ((origin.x + size.width) - 15) && (origin.y + dragStartLocation.y) <= origin.y + 15)
	{
		moving		= NO;
		resizing	= YES;
		
		clickDistanceFromWindowEdge.width	= (origin.x + size.width) - (origin.x + dragStartLocation.x);
		clickDistanceFromWindowEdge.height	= dragStartLocation.y;
	}
	else
	{
		moving		= YES;
		resizing	= NO;
	}
}
- (void) mouseDragged: (NSEvent*) theEvent
{
	 if ([theEvent type] == NSLeftMouseDragged)
	{
		  NSP origin;
		NSSZ	size;
		NSSZ	minSize;
		  NSP newLocation;
		
		NSR		screenRect	= [[self screen] frame];
		
		NSR		newFrameRect;
		NSP		newOrigin	= [self frame].origin;
		NSSZ		newSize		= [self frame].size;
		
		  origin		= [self frame].origin;
		size		= [self frame].size;
		minSize		= [self minSize];
		  newLocation = [theEvent locationInWindow];
						  
		if (moving)
		{
			//
			// Move stuff
			//
			
			newOrigin.x = origin.x + newLocation.x - dragStartLocation.x;
			newOrigin.y	= origin.y + newLocation.y - dragStartLocation.y;
			
			CGFloat maxHeight;
			
			if ([self level] < NSMainMenuWindowLevel) // if our level is less than the main menu level
			{
				maxHeight = screenRect.origin.y + screenRect.size.height - 22;  // the menubar is 22 pixels high
			}
			else
			{
				maxHeight = screenRect.origin.y + screenRect.size.height;
			}
			
			if (newOrigin.y + size.height > maxHeight)
			{
				newOrigin.y = maxHeight - size.height;
			}
		}
		else if (resizing)
		{
			//
			// Resize stuff
			//
			
			NSSZ	distanceMoved;
			
			distanceMoved.width		= newLocation.x - size.width + clickDistanceFromWindowEdge.width;
			distanceMoved.height	= newLocation.y - clickDistanceFromWindowEdge.height;
			newSize.width		= size.width + distanceMoved.width;
			newSize.height		= size.height - distanceMoved.height;
			
			newOrigin.y			= origin.y + distanceMoved.height;
			
			if (origin.x + newSize.width > screenRect.size.width)
			{
				newSize.width = screenRect.size.width - origin.x;
			}
			
			if (newSize.width < minSize.width)
			{
				newSize.width	= minSize.width;
			}
			if (newSize.height < minSize.height)
			{
				newOrigin.y		= newOrigin.y - (minSize.height - newSize.height);
				newSize.height	= minSize.height;
			}
		}
		
		newFrameRect.origin		= newOrigin;
		newFrameRect.size		= newSize;
		
		[self setFrame: newFrameRect display: YES];
	 }
}
- (void) mouseUp: (NSEvent*) theEvent
{
	moving		= NO;
	resizing	= NO;
}

@end