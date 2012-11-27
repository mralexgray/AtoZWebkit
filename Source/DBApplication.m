/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBApplication.h"
//#import "DBHotKeyController.h"
#import "DeskBrowseConstants.h"
#import "DeskBrowseController.h"

@implementation DBApplication

- (id) init
{
	if (!(self = [super init])) { NSLog(@"*** - [DBApplication init] : Failure"); return  nil; }
	return self;
}

- (void) sendEvent: (NSEvent*) theEvent
{
	[theEvent type] == NSLeftMouseDown ? [_delegate mouseDown: theEvent] : [theEvent type] == NSKeyDown ? [self handleKeyEvent: theEvent] : nil;
	[super sendEvent: theEvent];
}

// Call it handleKeyEvent so we don't accidently override the keyDown: method (which wasn't being called here, but you never know...)
- (void) handleKeyEvent: (NSEvent*) theEvent
{
	NSS*	characters	= [theEvent charactersIgnoringModifiers];
	//NSS*	characters1	= [theEvent characters];
	
	NSUInteger modifiers	= [theEvent modifierFlags];
	
	/*
	NSLog(@"WARNING: handleKeyEvent in DBApplication STILL ALLOWS FORCE QUIT! -Ian");
	if ([characters isEqualToString: @"="])		//
	{											//	TEMORARY
		[NSApp endSheet: [NSApp keyWindow]];	//
		[NSApp terminate: nil];					//
	}											//
	*/
	
	if ([characters length] == 1)
	{
		if (modifiers & NSCommandKeyMask && modifiers & NSShiftKeyMask)
		{
			unichar	character = [characters characterAtIndex: 0];
			
			if (character == NSRightArrowFunctionKey)
				[_delegate keyCombinationPressed: kCommandShiftRightArrow];
			else if (character == NSLeftArrowFunctionKey)
				[_delegate keyCombinationPressed: kCommandShiftLeftArrow];
		}
		else if (modifiers & NSCommandKeyMask)
		{
			unichar	character = [characters characterAtIndex: 0];
			
			if (character == NSRightArrowFunctionKey)		[_delegate keyCombinationPressed: kCommandRightArrow];
			else if (character == NSLeftArrowFunctionKey)	[_delegate keyCombinationPressed: kCommandLeftArrow];
		}
	}
}

//	Override this so we can close the window after ending its modal session. I'm not sure why this isn't the default implementation.
- (void) endSheet: (NSWindow*) sheet {   !sheet ?: ^{ [super endSheet: sheet];  [sheet orderOut: nil]; }();  }

//	loadHotKeyController
//- (void) initHotKeyController { 	_hotKeyController = [[DBHotKeyController alloc] init]; }

//	hotKeyController
//
// --------------------------------------
//- (DBHotKeyController*) hotKeyController
//{
////	return hotKeyController;
//}
@end
