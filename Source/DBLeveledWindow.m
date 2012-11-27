/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBLeveledWindow.h"
//#import "DBWindowLevel.h"


static NSInteger _windowLevel;

@implementation DBWindowLevel

+ (NSI) windowLevel {	return _windowLevel; }

+ (void) setWindowLevel: (NSI) windowLevel
{
	_windowLevel = _windowLevel != windowLevel ? ^{
		[AZNOTCENTER postNotificationName: kWindowLevelChangedNotification object: nil];
		return windowLevel;
	}() : _windowLevel;
}

@end


@implementation DBLeveledWindow

- (id) initWithContentRect: (NSR) contentRect styleMask: (NSUI) styleMask backing: (NSBackingStoreType) backingType defer: (BOOL) flag
{
	if (self = [super initWithContentRect: contentRect styleMask: styleMask backing: backingType defer: flag])
	{
		[self setLevel: [DBWindowLevel windowLevel]];
		
		[AZNOTCENTER addObserver: self selector: @selector(windowLevelChanged:) name: kWindowLevelChangedNotification object: nil];
	}
	
	return self;
}
//- (void) dealloc
//{
//	[AZNOTCENTER removeObserver: self];
//	
//}


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