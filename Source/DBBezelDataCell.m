/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBBezelDataCell.h"

@implementation DBBezelDataCell
- (id) init
{
	if (self = [super init])
	{
		[self setFocusRingType: NSFocusRingTypeNone];
	}
	
	return self;
}
- (void) drawInteriorWithFrame: (NSR) cellFrame inView: (NSView*) controlView
{
//	NSMD *attrs = [NSMD dictionaryWithDictionary:[[self attributedStringValue] attributesAtIndex:0 effectiveRange:NULL]];
	NSMD *attrs = [NSMD dictionary];
	if ([self isHighlighted])
	{
		[attrs setValue: [NSColor whiteColor] forKey: NSForegroundColorAttributeName];
	}
	else
	{
		[attrs setValue: [NSColor colorWithDeviceRed: 0.8 green: 0.8 blue: 0.8 alpha: 1.0] forKey: NSForegroundColorAttributeName];
	}
	
	[attrs setValue: [self font] forKey: NSFontAttributeName];
	
	NSR		drawFrame	= NSMakeRect(cellFrame.origin.x + 10, cellFrame.origin.y + 2, cellFrame.size.width - 20, cellFrame.size.height);
	NSS*	drawString	= [[self stringValue] truncatedToWidth: drawFrame.size.width withAttributes: attrs];
	
	[drawString drawInRect: drawFrame withAttributes: attrs];
}
- (NSColor*) highlightColorWithFrame: (NSR) cellFrame inView: (NSView*) controlView
{
	return [NSColor colorWithDeviceRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.7];
}

@end