/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBBookmarkBarPopUpButton.h"
#import "DBBookmarkBar.h"


@implementation DBBookmarkBarPopUpButton

- (id) initWithFrame: (NSR) frameRect pullsDown: (BOOL) flag
{
	if (self = [super initWithFrame: frameRect pullsDown: flag])
	{
		[AtoZ sharedInstance];
		mText			=  @"More...";//[[NSString stringWithString: @"More..."] retain];
		mTextFont		= [NSFont fontWithName:@"Ivolkswagen-DemiBold" size: 18];
		mDefaultColor	=  WHITE;//[NSColor colorWithDeviceRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.0];
	}
	
	return self;
}

- (void) drawRect: (NSR) rect
{	
	[self drawBackground];
	[self drawText];
}

- (void) drawBackground
{
	[[NSBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:15]drawWithFill:mDefaultColor andStroke:nil];
}
- (void) drawText
{
	NSR		frame		= [self bounds];
	NSSZ	padding		= NSMakeSize(4.0, 0.0);
	NSR		textFrame	= NSMakeRect(	frame.origin.x + padding.width, frame.origin.y + padding.height,
										frame.size.width - padding.width * 2, frame.size.height - padding.height * 2);

	NSD*	stringAttributes		= [NSDictionary dictionaryWithObjectsAndKeys:WHITE, @"NSColor",mTextFont, NSFontAttributeName,nil];
//	 : mTextFont };
	NSS*	drawText			= [mText truncatedToWidth: textFrame.size.width withAttributes: stringAttributes];
//	NSSZ	stringSize			= [drawText sizeWithAttributes: stringAttributes];

//	if (stringSize.width < textFrame.size.width)
//	{
//		CGFloat extraWidth	= textFrame.size.width - stringSize.width;
//		textFrame.origin.x	= textFrame.origin.x + extraWidth / 2;
//	}
//	textFrame.size.height = stringSize.height;
	[drawText drawInRect: textFrame withAttributes: stringAttributes];
//	[drawText drawInRect:textFrame withFontNamed:[AtoZ randomFontName] andColor:WHITE];

}

#pragma mark -

- (void) mouseDown: (NSEvent*) theEvent
{
	[self removeAllItems];
		
	NSArray* menuItems = [((DBBookmarkBar*)[self superview]) menuItemsForPopUpButton: self];
	
	if ([menuItems count] > 0)
	{
		NSMenu*			menu				= [self menu];
		NSEnumerator*	menuItemEnumerator	= [menuItems objectEnumerator];
		NSMenuItem*	currentMenuItem		= nil;
		
		while ((currentMenuItem = [menuItemEnumerator nextObject]) != nil)
		{
			[menu addItem: currentMenuItem];
		}
		
		[self setMenu: menu];
		[self deselectItems];
		
		[super mouseDown: theEvent];
	}
}
- (void) deselectItems
{
	NSInteger numberOfItems = [self numberOfItems];
	
	if (numberOfItems > 0)
	{
		NSMenu* menu				= [self menu];
		NSInteger		numberOfMenuItems	= [menu numberOfItems];
		
		if (numberOfMenuItems > 0)
		{
			[self selectItemAtIndex: 0];
			
			NSMenuItem* firstItem = [menu itemAtIndex: 0];
			[firstItem setState: NSOffState];
		}
	}
}
- (BOOL) shouldBeFilled
{
	return mShouldBeFilled;
}
@end