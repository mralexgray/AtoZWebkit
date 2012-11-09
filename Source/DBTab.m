/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBTab.h"

#import "NSStringAdditions.h"


@implementation DBTab

- (id) initWithFrame: (NSR) frame
{
	 if (self = [super initWithFrame: frame])
	{
		if (!tabImagesInitialized)
		{
			selectedTabFill			= [NSImage imageNamed: @"actvfill.png"];
			selectedTabRight		= [NSImage imageNamed: @"actvright.png"];
			selectedTabLeft			= [NSImage imageNamed: @"actvleft.png"];
			
			unselectedTabFill		= [NSImage imageNamed: @"disfill.png"];
			unselectedTabRight		= [NSImage imageNamed: @"disright.png"];
			unselectedTabLeft		= [NSImage imageNamed: @"disleft.png"];
			
			tabClose				= [NSImage imageNamed: @"disclose.png"];
			tabCloseMouseOver		= [NSImage imageNamed: @"actvclose.png"];
			tabCloseMouseDown		= [NSImage imageNamed: @"actvcloseclicked.png"];
			
			tabImagesInitialized	= YES;
		}
				
		selected	= NO;
		mouseOver	= NO;
		
		[self setLabel: @"Untitled"];
		
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(frameDidChange:) name: NSViewFrameDidChangeNotification object: self];
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(frameDidChange:) name: NSViewBoundsDidChangeNotification object: self];
		[self setPostsFrameChangedNotifications: YES];
		[self setPostsBoundsChangedNotifications: YES];
				
		// set up the context menu
		NSMenu		*tabMenu	= [[NSMenu alloc] initWithTitle:@"TabMenu"];
		
		NSMenuItem	*close		= [[NSMenuItem alloc] initWithTitle:@"Close Tab"
														action:@selector(sendCloseNotification)
												keyEquivalent:@""];
		
		NSMenuItem *closeAll	= [[NSMenuItem alloc] initWithTitle:@"Close All Tabs"
															 action:@selector(closeAll)
													  keyEquivalent:@""];
		
		NSMenuItem *reload		= [[NSMenuItem alloc] initWithTitle:@"Reload Tab"
															 action:@selector(reload)
													  keyEquivalent:@""];
		
		NSMenuItem *reloadAll	= [[NSMenuItem alloc] initWithTitle:@"Reload All Tabs"
															 action:@selector(reloadAll)
													  keyEquivalent:@""];
		
		// add the items
		[tabMenu	addItem:close];
		[tabMenu	addItem:closeAll];
		[tabMenu	addItem:[NSMenuItem separatorItem]];
		[tabMenu	addItem:reload];
		[tabMenu	addItem:reloadAll];
		
		[self		setMenu:tabMenu];
		
		// clean up
		[tabMenu	release];
		[close		release];
		[closeAll	release];
		[reload		release];
		[reloadAll	release];
	 }
	
	 return self;
}

- (void) viewDidMoveToWindow
{
	[self resetTrackingRect];
}

- (void) closeAll
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DBCloseAllTabs" object:self];
}

- (void) reload
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DBReloadTab" object:self];
}

- (void) reloadAll
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DBReloadAllTabs" object:self];
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	
	if (trackingRectTag > 0)
	{
		[self removeTrackingRect: trackingRectTag];
	}
	
	[label		release];
	[favicon	release];
	[status		release];
	[URLString	release];
	[title		release];
	
}


#pragma mark -
#pragma mark Accessors

- (void) setLabel: (NSString*) newLabel
{
	if (newLabel != label)
	{
		if (newLabel != nil && [newLabel length] > 0)
		{
//			[label release];
			label = [newLabel copy];
		}
		else
		{
//			[label release];
			label = @"Untitled";//[[NSString stringWithString: @"Untitled"] retain];
		}
	}
}

- (NSString *)label
{
	return label;
}

- (void) setSelected: (BOOL) flag
{
	if (flag != selected)
	{
		selected = flag;
	}
}

- (BOOL)selected {return selected; }


#pragma mark -

- (void) setFavicon: (NSImage*) newFavicon
{
	if (newFavicon != favicon)
	{
		[favicon release];
		favicon = newFavicon;
	}
}

- (NSImage*) favicon
{
	return favicon;
}

- (void) setStatus: (NSString*) newStatus
{
	if (newStatus != status)
	{
		[status release];
		status = newStatus;
	}
}

- (NSString*) status
{
	return status;
}

- (void) setURLString: (NSString*) newURLString
{
	if (newURLString != URLString)
	{
		[URLString release];
		URLString = [newURLString copy];
		
		[self setToolTip: URLString];
	}
}

- (NSString*) URLString
{
	return URLString;
}

- (void) setTitle: (NSString*) newTitle
{
	if (newTitle != title)
	{
		[title release];
		title = [newTitle copy];
	}
}

- (NSString*) title
{
	return title;
}

- (void) setLoading: (BOOL) flag
{
	loading = flag;
}

- (BOOL) loading
{
	return loading;
}


#pragma mark -
#pragma mark Drawing

- (void) drawRect: (NSR) rect
{
	[self drawTabInRect: rect];
	[self drawCloseButtonInRect: [self rectForCloseButton]];
	[self drawLabelInRect: NSMakeRect(rect.origin.x + 20, rect.origin.y, rect.size.width - 30, rect.size.height)];
}


#pragma mark -

- (void) drawTabInRect: (NSR) rect
{
	//NSR	frame				= [self frame];
	//NSSize	size				= frame.size;
	//NSP	origin				= frame.origin;
	
	NSColor* bgColor = [NSColor colorWithCalibratedWhite:0.75 alpha:1.0];
	
	if (selected)
		bgColor = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0f];
	
	[bgColor set];
	[NSBezierPath fillRect:NSInsetRect(rect, 0.0f, 1.0f)];
	
	[[NSColor grayColor] set];
	[[NSGraphicsContext currentContext] saveGraphicsState];
	[[NSGraphicsContext currentContext] setShouldAntialias:NO];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(rect.size.width - 1.0f, 0) toPoint:NSMakePoint(rect.size.width - 1.0f, rect.size.height)];
	[[NSGraphicsContext currentContext] restoreGraphicsState];
	
	/*CGFloat	newFillWidth		= size.width - ([selectedTabLeft size].width + [selectedTabRight size].width);
	
	
	if (newFillWidth < 1) // We have to do this because if the width < 0, it won't draw later when we make it wider
	{
		newFillWidth = 1;
	}
	
	[selectedTabFill	setSize: NSMakeSize(newFillWidth, [selectedTabFill size].height)];
	[unselectedTabFill	setSize: NSMakeSize(newFillWidth, [unselectedTabFill size].height)];
	
	NSImage* leftImage	= nil;
	NSImage* fillImage	= nil;
	NSImage* rightImage = nil;
	
	if (selected)
	{
		leftImage	= selectedTabLeft;
		fillImage	= selectedTabFill;
		rightImage	= selectedTabRight;
	}
	else
	{
		leftImage	= unselectedTabLeft;
		fillImage	= unselectedTabFill;
		rightImage	= unselectedTabRight;
	}
	
	NSP leftImageDrawPoint	= rect.origin;
	NSP fillImageDrawPoint	= NSMakePoint(rect.origin.x + [leftImage size].width, rect.origin.y);
	NSP rightImageDrawPoint	= NSMakePoint(fillImageDrawPoint.x + [fillImage size].width, rect.origin.y);
	
	[leftImage drawAtPoint: leftImageDrawPoint
				  fromRect: NSMakeRect(0, 0, [leftImage size].width, [leftImage size].height)
				 operation: NSCompositeSourceOver
				  fraction: 1.0];
	
	[fillImage drawAtPoint: fillImageDrawPoint
				  fromRect: NSMakeRect(0, 0, [fillImage size].width, [fillImage size].height)
				 operation: NSCompositeSourceOver
				  fraction: 1.0];
	
	[rightImage drawAtPoint: rightImageDrawPoint
				  fromRect: NSMakeRect(0, 0, [rightImage size].width, [rightImage size].height)
				 operation: NSCompositeSourceOver
				  fraction: 1.0];*/
}


#pragma mark -

- (void) drawCloseButtonInRect: (NSR) rect
{
	NSImage* closeImage = nil;
	
	if (mouseDownClose)
	{
		closeImage = tabCloseMouseDown;
	}
	else if (mouseOverClose)
	{
		closeImage = tabCloseMouseOver;
	}
	else
	{
		closeImage = tabClose;
	}
			
	[closeImage drawAtPoint: rect.origin
				  fromRect: NSMakeRect(0, 0, [closeImage size].width, [closeImage size].height)
				 operation: NSCompositeSourceOver
				  fraction: 1.0];
}


- (NSR) rectForCloseButton
{
	NSR		closeButtonRect;
	NSImage*	closeButtonImage = nil;
	
	
	// Size
	
	if (mouseOverClose)
	{
		closeButtonImage = tabCloseMouseOver;
	}
	else if (mouseDownClose)
	{
		closeButtonImage = tabCloseMouseDown;
	}
	else
	{
		closeButtonImage = tabClose;
	}
	
	closeButtonRect.size = [closeButtonImage size];
	
	
	// Origin
	
	NSR	bounds			= [self bounds];
	//CGFloat	topOfTabImage	= bounds.size.height;
	
	/*if (selected)
	{
		topOfTabImage = bounds.origin.y + [selectedTabFill size].height;
	}
	else
	{
		topOfTabImage = bounds.origin.y + [unselectedTabFill size].height;
	}*/
	
//	closeButtonRect.origin = NSMakePoint(frame.origin.x + 4, frame.origin.y + ((topOfTabImage - 4) - [closeButtonImage size].height));
	if (!selected)
	{
		closeButtonRect.origin = NSMakePoint(bounds.origin.x + 5, bounds.origin.y + 7);
	}
	else
	{
		closeButtonRect.origin = NSMakePoint(bounds.origin.x + 5, bounds.origin.y + 7);
	}
	
	return closeButtonRect;
}

- (BOOL) pointInCloseButton: (NSP) point
{
	BOOL	pointInCloseButton	= NO;
	NSR  closeButtonRect		= [self rectForCloseButton];
	NSP	rectOrigin			= closeButtonRect.origin;
	NSSize	rectSize			= closeButtonRect.size;
	
	if (point.x >= rectOrigin.x && point.x <= rectOrigin.x + rectSize.width && point.y >= rectOrigin.y && point.y <= rectOrigin.y + rectSize.height)
	{
		pointInCloseButton = YES;
	}
	
	return pointInCloseButton;
}


#pragma mark -

- (void) drawLabelInRect: (NSR) rect
{
	if (label != nil)
	{
		NSMD*	labelAttributes = [NSMD dictionary];
		CGFloat					drawY			= 5;
		
		[labelAttributes setValue: [NSFont systemFontOfSize: 11] forKey: NSFontAttributeName];
		[labelAttributes setValue: (selected ? [NSColor blackColor] : [NSColor colorWithCalibratedWhite:0.2f alpha:1.0f]) forKey:NSForegroundColorAttributeName];
		
		NSString*	stringToDraw	= [label truncatedToWidth: rect.size.width withAttributes: labelAttributes];
		//NSSize		stringSize		= [stringToDraw sizeWithAttributes: labelAttributes];
		NSP		drawPoint		= NSMakePoint(rect.origin.x, rect.origin.y + drawY);
		
//	Use this if we want it centered
//		NSP		drawPoint		= NSMakePoint((rect.origin.x + rect.size.width / 2) - stringSize.width / 2, rect.origin.y + drawY);
		
		NSShadow* whiteShadow = [[NSShadow alloc] init];
		[whiteShadow setShadowColor:[NSColor whiteColor]];
		[whiteShadow setShadowBlurRadius:0.7];
		[whiteShadow setShadowOffset:NSMakeSize(0.0f, -1.0f)];
		[whiteShadow set];
		
		if (selected)
		{
			[stringToDraw drawAtPoint: drawPoint withAttributes: labelAttributes];
		}
		else
		{
			[stringToDraw drawAtPoint: drawPoint withAttributes: labelAttributes];
		}
		
		[whiteShadow release];
	}
}

#pragma mark -
#pragma mark View Management

- (void) removeFromSuperview
{
	 if (trackingRectTag > 0)
	 {
		  [self removeTrackingRect: trackingRectTag];
	 }

	 [super removeFromSuperview];
}

- (void) removeFromSuperviewWithoutNeedingDisplay
{
	 if (trackingRectTag > 0)
	 {
		  [self removeTrackingRect: trackingRectTag];
	 }

	 [super removeFromSuperviewWithoutNeedingDisplay];
}


#pragma mark -
#pragma mark Event Management

- (BOOL) acceptsFirstResponder
{
	return NO;
}


#pragma mark -

- (void) resetTrackingRect
{
	if (trackingRectTag > 0)
	{
		[self removeTrackingRect: trackingRectTag];
	}
	
	NSP mouseLocation	= [[self window] mouseLocationOutsideOfEventStream];
	 //NSR	boundsInWindow	= [self convertRect: [self bounds] toView: nil];
	//NSR	bounds			= [self bounds];
	NSR	trackingRect	= [self rectForCloseButton];
	
	BOOL	mouseInView		= [self pointInCloseButton: mouseLocation];
	
	trackingRectTag = [self addTrackingRect: trackingRect owner: self userData: nil assumeInside: mouseInView];
	
	if (mouseInView)
	 {
		[self mouseEntered: [NSApp currentEvent]];
	 }
	else
	{
		[self mouseExited: [NSApp currentEvent]];
	}
}


#pragma mark -

- (void) mouseEntered: (NSEvent*) theEvent
{
	mouseOver = YES;
	
	NSP mousePoint = [self convertPoint: [theEvent locationInWindow] fromView: nil];
	
	if ([self pointInCloseButton: mousePoint])
	{
		mouseOverClose = YES;
	}
	else
	{
		mouseOverClose = NO;
	}
	
	[self setNeedsDisplay: YES];
}


- (void) mouseExited: (NSEvent*) theEvent
{
	mouseOver		= NO;
	mouseOverClose	= NO;
	mouseDownClose	= NO;
	
	[self setNeedsDisplay: YES];
}

- (void) mouseDown: (NSEvent*) theEvent
{
	if ([theEvent type] == NSLeftMouseDown)
	{
		NSP		clickPoint	= [self convertPoint: [theEvent locationInWindow] fromView: nil];
		//NSP		origin		= [self frame].origin;
		
		if ([self pointInCloseButton: clickPoint])
		{
			mouseDownClose = YES;
			[self setNeedsDisplay: YES];
		}
		else
		{
			NSMD *dic = [[NSMD alloc] init];
			[dic setValue: self forKey: @"clickedTab"];
			
			[[NSNotificationCenter defaultCenter] postNotificationName: @"DBTabClicked"
																object: self
															  userInfo: dic];
			[dic release];
		}
	}
}

- (void) mouseUp: (NSEvent*) theEvent
{
	if ([theEvent type] == NSLeftMouseUp)
	{
		NSP		clickPoint	= [self convertPoint: [theEvent locationInWindow] fromView: nil];
		//NSP		origin		= [self frame].origin;
		
		if ([self pointInCloseButton: clickPoint])
		{
			[self sendCloseNotification];
		}
		
		mouseDownClose = NO;
		
		[self setNeedsDisplay: YES];
	}
}


#pragma mark -
#pragma mark Notifications

- (void)sendCloseNotification {
	NSMD *dic = [[NSMD alloc] init];
	dic[@"sender"] = self;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DBTabWantsToBeClosed"
														object:self
													  userInfo:dic];
	[dic release];
}

- (void) frameDidChange: (NSNotification*) notification
{
	[self resetTrackingRect];
}


@end