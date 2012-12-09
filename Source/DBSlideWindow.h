/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
/* SlideWindow */

#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>
#import "DeskBrowseConstants.h"


typedef NS_ENUM(NSUI, DBDragMode) //enum
{
	DragModeNone = 0,
	DragModeMove,
	DragModeResizeFromTop,
	DragModeResizeFromRight,
	DragModeResizeFromTopRight,
	DragModeResizeFromBottomRight
};


@interface DBSlideWindow : NSWindow
@property (ASS, NATOM)	BOOL		snapsToEdges;		/* whether or not the window snaps to edges */
@property (ASS, NATOM)	CGFloat		snapTolerance;	/* distance from edge within which snapping occurs */
@property (ASS, NATOM)	BOOL		snapping;		/* whether we're currently snapping to an edge */
@property (ASS, NATOM)	NSP			dragStartLocation;	/* keeps track of last drag's mousedown point */
@property (ASS, NATOM)	CGFloat		padding, minWidth;
@property (ASS, NATOM)	NSSZ		clickDistanceFromWindowEdge;
@property (ASS, NATOM)	DBDragMode	currentDragMode;

@property (unsafe_unretained)	id			controller;
@property (weak)	IBOutlet NSImageView *dragImageViewTopRight;


- (void) saveFrame;
- (void) loadFrame;
	/* Accessor methods */
- (void) setOnScreen: (BOOL) flag;
- (void)setSticky:(BOOL)flag;
- (void)setController:(id)aController;
@end
