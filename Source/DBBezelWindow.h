/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>

#import "DBLeveledWindow.h"


@interface DBBezelWindow : DBLeveledWindow
{
	NSP	dragStartLocation;
	NSView*	subview;
	BOOL	resizing;
	BOOL	moving;
	NSSize	clickDistanceFromWindowEdge;
}

@end
