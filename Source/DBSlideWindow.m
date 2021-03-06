	/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBSlideWindow.h"
@implementation DBSlideWindow
@synthesize controller, currentDragMode, dragStartLocation;
@synthesize snapTolerance, snapping, snapsToEdges, clickDistanceFromWindowEdge, minWidth, padding;
typedef NSInteger CGSConnection, CGSWindow;
extern CGSConnection _CGSDefaultConnection();
extern OSStatus CGSGetWindowTags  (const CGSConnection cid, const CGSWindow wid, NSInteger *tags, NSInteger thirtyTwo);
extern OSStatus CGSSetWindowTags  (const CGSConnection cid, const CGSWindow wid, NSInteger *tags, NSInteger thirtyTwo);
extern OSStatus CGSClearWindowTags(const CGSConnection cid, const CGSWindow wid, NSInteger *tags, NSInteger thirtyTwo);
- (void)setSticky:(BOOL)flag
{
	CGSConnection connectionID = _CGSDefaultConnection();
	CGSWindow winNumber = [self windowNumber];
	NSInteger allTags[0];
	NSInteger theTags[2] = {0x0002, 0};
	if(!CGSGetWindowTags(connectionID, winNumber, allTags, 32)) {
		if (flag)	CGSSetWindowTags(connectionID, winNumber, theTags, 32);
		else		CGSClearWindowTags(connectionID, winNumber, theTags, 32);
	}
}
#pragma mark -
- (id)initWithContentRect:(NSR)contentRect styleMask:(NSUI)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
	if (!(self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO])) return nil;
	[self setLevel:NSNormalWindowLevel];
	[self setOpaque:YES];

	NSC* c = [[NSUserDefaults standardUserDefaults]colorForKey:kSliderBGColor] ?: RANDOMCOLOR;

	[self setBackgroundColor:c];//[ leatherTintedWithColor:RANDOMCOLOR]];// blackColor]];
	[self setAlphaValue:1.0];
	[self setHasShadow:YES];
	minWidth = 400.0;
	 return self;
}
- (void) awakeFromNib
{
//	NSIMG * e = [_dragImageViewTopRight image].copy;

	[[_dragImageViewTopRight image]setFlipped:YES];// = [NSIMG swatchWithColor:RED size:AZSizeFromDimension(25)];///	e = [e rotated:90];
//	[_dragImageViewTopRight setImage:e];//[[NSImage systemImages]scaledToMax:15]];
	//	[_dragImageViewTopRight setNeedsDisplay:YES];

}

-(void) setBackgroundColor:(NSColor *)color
{
	_backgroundColor = [NSColor leatherTintedWithColor:color];
	[[NSUserDefaults standardUserDefaults] setColor:_backgroundColor  forKey:kSliderBGColor];
	[self display];
}

#pragma mark -
- (BOOL)canBecomeKeyWindow
{
	return YES;
}
- (BOOL) canBecomeMainWindow
{
	return YES;
}

#pragma mark -
/*
 * 
 *	Mouse event handlers
 *	Since we don't have a titlebar, we handle window-dragging ourselves.
 *
 */
- (void) mouseDown: (NSEvent*) theEvent
{
	currentDragMode		= DragModeNone;
	 dragStartLocation	= [theEvent locationInWindow];
	NSP origin		= [self frame].origin;
	NSSZ	size		= [self frame].size;
		
	if (((origin.x + dragStartLocation.x) < ((origin.x + size.width) - 15) && (origin.x + dragStartLocation.x) >= origin.x) && (((origin.y + dragStartLocation.y) <= (origin.y + 70))))
	{
		// Moving
		
		currentDragMode = DragModeMove;
	}
	else if (origin.y + dragStartLocation.y >= (origin.y + size.height) - 8)
	{
		if (origin.x + dragStartLocation.x >= (origin.x + size.width) - 8)
		{
			// Resizing from top right
			
			currentDragMode						= DragModeResizeFromTopRight;
			clickDistanceFromWindowEdge.width	= (origin.x + size.width) - (origin.x + dragStartLocation.x);
			clickDistanceFromWindowEdge.height	= (origin.y + size.height) - (origin.y + dragStartLocation.y);
		}
		else
		{
			// Resizing from top
			
			currentDragMode						= DragModeResizeFromTop;
			clickDistanceFromWindowEdge.height	= (origin.y + size.height) - (origin.y + dragStartLocation.y);
		}
	}
	else if (origin.x + dragStartLocation.x >= (origin.x + size.width) - 15)
	{
		if (origin.x + dragStartLocation.x >= (origin.x + size.width) - 8)
		{
			// Resizing from right
			
			currentDragMode						= DragModeResizeFromRight;
			clickDistanceFromWindowEdge.width	= (origin.x + size.width) - (origin.x + dragStartLocation.x);
		}
		
		if (origin.y + dragStartLocation.y <= origin.y + 15)
		{
			// Resizing from bottom right
						
			currentDragMode						= DragModeResizeFromBottomRight;
			clickDistanceFromWindowEdge.width	= (origin.x + size.width) - (origin.x + dragStartLocation.x);
			clickDistanceFromWindowEdge.height	= dragStartLocation.y;
		}
	}
}
- (void)mouseDragged:(NSEvent *)theEvent
{
	 if ([theEvent type] == NSLeftMouseDragged) {
		  NSP origin;
		NSSZ	size;
		NSSZ	minSize;
		  NSP newLocation;
		
		NSR		screenRect			= [[self screen] frame];
		
		NSR		newFrameRect		= [self frame];
		NSP		newOrigin			= [self frame].origin;
		NSSZ		newSize				= [self frame].size;
		
		  origin							= [self frame].origin;
		size							= [self frame].size;
		minSize							= [self minSize];
		  newLocation						= [theEvent locationInWindow];
		
		NSSZ		distanceMouseMoved = NSMakeSize(newLocation.x - size.width + clickDistanceFromWindowEdge.width, newLocation.y - clickDistanceFromWindowEdge.height);
		
		  
		switch (currentDragMode)
		{
			case DragModeMove:
			{
				// Move window
				
				newOrigin.x = origin.x;
				newOrigin.y	= origin.y + newLocation.y - dragStartLocation.y;
				
				
				// Make sure we don't move past the menu bar
								
				if (newOrigin.y > origin.y)
				{
					if ((newOrigin.y + size.height) > ((screenRect.origin.y + screenRect.size.height) - 22))
					{
						newOrigin.y = ((screenRect.origin.y + screenRect.size.height) - 22) - size.height;
					}
				}
				
				break;
			}
			case DragModeResizeFromTop: // Resize from top -- CHANGED TO MOVE FROM TOP
			{
				// Move window
				
				newOrigin.x = origin.x;
				newOrigin.y	= origin.y + newLocation.y - dragStartLocation.y;
				
				
				// Make sure we don't move past the menu bar
				
				if (newOrigin.y > origin.y)
				{
					if ((newOrigin.y + size.height) > ((screenRect.origin.y + screenRect.size.height) - 22))
					{
						newOrigin.y = ((screenRect.origin.y + screenRect.size.height) - 22) - size.height;
					}
				}
				
				break;
			}
			case DragModeResizeFromTopRight: // Resize from top right
			{
				// Resize horizontally
				
				newSize.width = size.width + distanceMouseMoved.width;
				
				if (origin.x + newSize.width > screenRect.size.width)
				{
					newSize.width = screenRect.size.width - origin.x;
				}
				
				if (newSize.width < minSize.width)
				{
					newSize.width	= minSize.width;
				}
				
				
				// Resize vertically
				
				distanceMouseMoved.height	= (newLocation.y - newSize.height) + clickDistanceFromWindowEdge.height;
				newSize.height				= size.height + distanceMouseMoved.height;
				
				if (newSize.height < minSize.height)
				{
					newSize.height	= minSize.height;
				}
				
				
				// Make sure we don't resize past the menu bar
				
				if (newOrigin.y + newSize.height > (screenRect.origin.y + screenRect.size.height) - 22)
				{
					newSize.height = ((screenRect.origin.y + screenRect.size.height) - 22) - newOrigin.y;
				}
				
				break;
			}
			case DragModeResizeFromRight: // Resize from right
			{
				// Resize horizontally
				
				newSize.width = size.width + distanceMouseMoved.width;
				
				if (origin.x + newSize.width > screenRect.size.width)
				{
					newSize.width = screenRect.size.width - origin.x;
				}
				
				if (newSize.width < minSize.width)
				{
					newSize.width	= minSize.width;
				}
				
				break;
			}
			case DragModeResizeFromBottomRight: // Resize from bottom right
			{
				// Resize horizontally
				
				newSize.width = size.width + distanceMouseMoved.width;
				
				if (origin.x + newSize.width > screenRect.size.width)
				{
					newSize.width = screenRect.size.width - origin.x;
				}
				
				if (newSize.width < minSize.width)
				{
					newSize.width	= minSize.width;
				}
				
				
				// Resize vertically
				
				newSize.height	= size.height - distanceMouseMoved.height;
				newOrigin.y		= origin.y + distanceMouseMoved.height;
				
				if (newSize.height < minSize.height)
				{
					newOrigin.y		= newOrigin.y - (minSize.height - newSize.height);
					newSize.height	= minSize.height;
				}
				
				break;
			}
			default:
			{
			}
		}
		
		newFrameRect.origin		= newOrigin;
		newFrameRect.size		= newSize;
		
		[self setFrame: newFrameRect display: YES];
	 }
}
- (void) mouseUp: (NSEvent*) theEvent
{
	[self saveFrame];
	
	currentDragMode	= DragModeNone;
}

#pragma mark -
- (void) saveFrame
{
	NSUserDefaults* userDefaults	= [NSUserDefaults standardUserDefaults];
	NSNumber*		y				= [NSNumber numberWithFloat: [self frame].origin.y];
	NSNumber*		width			= [NSNumber numberWithFloat: [self frame].size.width];
	NSNumber*		height			= [NSNumber numberWithFloat: [self frame].size.height];
	
	[userDefaults setValue: y		forKey:	kSlideWindowY];
	[userDefaults setValue: width	forKey:	kSlideWindowWidth];
	[userDefaults setValue: height	forKey:	kSlideWindowHeight];
}
- (void) loadFrame
{
	NSUserDefaults* userDefaults	= [NSUserDefaults standardUserDefaults];
	CGFloat			y				= [userDefaults[kSlideWindowY]		floatValue];
	CGFloat			width			= [userDefaults[kSlideWindowWidth]	floatValue];
	CGFloat			height			= [userDefaults[kSlideWindowHeight]	floatValue];
	NSR			newFrame		= NSMakeRect(-width, y, width, height);
	
	[self setFrame: newFrame display: YES animate: NO];
}

#pragma mark -
/* Accessor methods */
- (void) setOnScreen: (BOOL) flag
{
	NSR	frame		= [self frame];
	NSR	newFrame	= NSZeroRect;
	NSP	origin		= frame.origin;
	NSSZ	size		= frame.size;
	
	if (flag)
	{
		// Show window
		
		newFrame = NSMakeRect(0, origin.y, size.width, size.height);
		[self setIsVisible: flag];
		[self setFrame: newFrame display: YES animate: YES];
	}
	else
	{
		// Hide window
				
		newFrame = NSMakeRect(-size.width, origin.y, size.width, size.height);
		
		[self setFrame: newFrame display: YES animate: YES];
		[self setIsVisible: flag];
	}
}
//- (void)setController:(id)aController {
//	[controller release];
//	controller = [aController retain];
//}

- (void)dealloc
{
	[controller release];
}
@end

