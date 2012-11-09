/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBBookmarkBarPopUpButton.h"
#import "DBBookmarkBar.h"

#import "NSBezierPathRoundRects.h"
#import "NSStringAdditions.h"


@implementation DBBookmarkBarPopUpButton


- (id) initWithFrame: (NSRect) frameRect pullsDown: (BOOL) flag
{
	if (self = [super initWithFrame: frameRect pullsDown: flag])
	{
		mText			=  @"More...";//[[NSString stringWithString: @"More..."] retain];
		mTextFont		= [[NSFont userFontOfSize: 11.0] retain];
		mDefaultColor	= [[NSColor colorWithDeviceRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.0] retain];
	}
	
	return self;
}

- (void) dealloc
{
	[mText release];
	[mTextFont release];
	[mDefaultColor release];
	
	[super dealloc];
}


#pragma mark -


- (void) drawRect: (NSRect) rect
{	
	[self drawBackground];
	[self drawText];
}

- (void) drawBackground
{
	NSColor* backgroundColor = mDefaultColor;
	
	[backgroundColor set];
	[NSBezierPath fillRoundRectInRect: [self bounds] radius: 15];
}

- (void) drawText
{
	NSRect			frame				= [self bounds];
	NSSize			padding				= NSMakeSize(4.0, 0.0);
	NSRect			textFrame			= NSMakeRect(frame.origin.x + padding.width, frame.origin.y + padding.height, frame.size.width - padding.width * 2, frame.size.height - padding.height * 2);
	NSDictionary*	stringAttributes	= [NSDictionary dictionaryWithObjects: @[[NSColor blackColor], mTextFont] forKeys: @[@"NSColor", NSFontAttributeName]];
	NSString*		drawText			= [mText truncatedToWidth: textFrame.size.width withAttributes: stringAttributes];
	NSSize			stringSize			= [drawText sizeWithAttributes: stringAttributes];
	
	if (stringSize.width < textFrame.size.width)
	{
		CGFloat extraWidth	= textFrame.size.width - stringSize.width;
		textFrame.origin.x	= textFrame.origin.x + extraWidth / 2;
	}
	
	textFrame.size.height = stringSize.height;
	
	[drawText drawInRect: textFrame withAttributes: stringAttributes];
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