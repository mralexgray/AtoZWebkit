/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBTabBar.h"

@implementation DBTabBar

- (id) initWithFrame: (NSR) frame
{
	 if (self = [super initWithFrame:frame])
	{
		  tabBarImage = [NSImage imageNamed: @"backbar_fill.png"];
		
		[tabBarImage setSize: frame.size];
		
		NSMenu *cmenu = [[NSMenu alloc] init];
		NSMenuItem *newTab = [[NSMenuItem alloc] initWithTitle:@"New Tab"
														action:@selector(askForNewTab)
												 keyEquivalent:@"t"];
		[cmenu addItem:newTab];
		
		[self setMenu:cmenu];
//		
//		[newTab release];
//		[cmenu release];
	 }
	
	 return self;
}
//- (void) dealloc
//{
//	[tabBarImage release];
//	
//}
- (void) drawRect: (NSR) rect
{
	 NSR imageRect;
	
	imageRect.origin	= NSZeroPoint;
	imageRect.size		= [tabBarImage size];
	
	[tabBarImage drawInRect: [self frame]
					fromRect: imageRect
				  operation: NSCompositeCopy
					 fraction: 1.0];
	
	[[NSColor colorWithCalibratedWhite:0.75 alpha:1.0] set];
	[NSBezierPath fillRect:NSInsetRect(rect, 0.0f, 1.0f)];
}
- (void)askForNewTab {
	[AZNOTCENTER postNotificationName:@"DBNewBlankTab"
														object:self
													  userInfo:nil];
}
- (void)mouseDown:(NSEvent*)event
{
	if ([event clickCount] >= 2)
	{
		[self askForNewTab];
	}
	else
	{
		[super mouseDown:event];
	}
}
@end
