/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
//-------------------------------------
//
//	SPECIAL THANKS TO NATHAN DAY
//
//-------------------------------------
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface DBKeyStuff : NSObject
{
}
+ (unichar) characterForKeyCode: (unsigned short) keyCode;
+ (NSS*) stringForKeyCode: (unsigned short) keyCode modifiers: (NSUI) modifiers;
+ (NSS*) stringForModifiers: (NSUI) modifiers;
+ (NSS*) stringForKeyCode: (unsigned short) keyCode;
@end
