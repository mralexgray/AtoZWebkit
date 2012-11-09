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
+ (NSString*) stringForKeyCode: (unsigned short) keyCode modifiers: (NSUI) modifiers;
+ (NSString*) stringForModifiers: (NSUI) modifiers;
+ (NSString*) stringForKeyCode: (unsigned short) keyCode;

@end
