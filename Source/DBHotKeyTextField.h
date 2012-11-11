/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>
#import "DBKeyStuff.h"

@interface DBHotKeyTextField : NSTextField
{
	UInt32		iKeyCode;
	UInt32		iModifiers;
	NSS*	stringRep;
}
- (UInt32) keyCode;
- (void) setKeyCode: (UInt32) keyCode;
- (UInt32) modifiers;
- (void) setModifiers: (UInt32) modifiers;
- (NSS*) stringRepresentation;
@end
