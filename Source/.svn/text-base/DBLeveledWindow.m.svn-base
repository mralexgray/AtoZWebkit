/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBLeveledWindow.h"

#import "DBWindowLevel.h"


@implementation DBLeveledWindow


- (id) initWithContentRect: (NSRect) contentRect styleMask: (NSUInteger) styleMask backing: (NSBackingStoreType) backingType defer: (BOOL) flag
{
	if (self = [super initWithContentRect: contentRect styleMask: styleMask backing: backingType defer: flag])
	{
		[self setLevel: [DBWindowLevel windowLevel]];
		
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(windowLevelChanged:) name: kWindowLevelChangedNotification object: nil];
	}
	
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	
	[super dealloc];
}


#pragma mark -


- (void) setAboveMainWindowLevel: (BOOL) aboveMainWindowLevel
{
	mAboveMainWindowLevel = aboveMainWindowLevel;
	
	[self windowLevelChanged: nil];
}

- (void) windowLevelChanged: (NSNotification*) notification
{
	NSInteger windowLevel = [DBWindowLevel windowLevel];
	
	if (mAboveMainWindowLevel)
	{
		windowLevel++;
	}
	
	[self setLevel: windowLevel];
}


@end