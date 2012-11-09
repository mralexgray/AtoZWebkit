/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBWebsposeWindow.h"

@implementation DBWebsposeWindow

- (id) initWithContentRect: (NSR) contentRect styleMask: (NSUI) aStyle backing: (NSBackingStoreType) bufferingType defer: (BOOL) flag
{
	if(self = [super initWithContentRect: contentRect styleMask: NSBorderlessWindowMask backing: NSBackingStoreBuffered defer: NO])
	{
		// Switch back to this to have the Webspsosé window above everything else; don't do it if using the Keychain!
		//
		// [self setLevel: NSMainMenuWindowLevel + 1];
		//
		
		[self setBackgroundColor: [NSColor colorWithCalibratedRed:0.282 green:1.000 blue:0.108 alpha:1.000]];
	}
	
	return self;
}
- (BOOL) canBecomeKeyWindow
{
	return YES;
}
- (BOOL) canBecomeMainWindow
{
	return YES;
}

@end