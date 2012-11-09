/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

/* SlideWindow */

#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>

#import "DeskBrowseConstants.h"

typedef enum
{
	DragModeNone = 0,
	DragModeMove,
	DragModeResizeFromTop,
	DragModeResizeFromRight,
	DragModeResizeFromTopRight,
	DragModeResizeFromBottomRight
} DBDragMode;

@interface DBSlideWindow : NSWindow

@property (assign, nonatomic)	BOOL		snapsToEdges;		/* whether or not the window snaps to edges */
@property (assign, nonatomic)	 CGFloat		snapTolerance;	/* distance from edge within which snapping occurs */
@property (assign, nonatomic)	 BOOL		snapping;		/* whether we're currently snapping to an edge */
@property (assign, nonatomic)	 NSPoint		dragStartLocation;	/* keeps track of last drag's mousedown point */
 @property (assign, nonatomic)	CGFloat		padding;
@property (assign, nonatomic)	CGFloat		minWidth;
@property (assign, nonatomic)	NSSize		clickDistanceFromWindowEdge;
@property (assign, nonatomic)	DBDragMode	currentDragMode;
@property (unsafe_unretained)	id			controller;

- (void) saveFrame;
- (void) loadFrame;

	/* Accessor methods */
- (void) setOnScreen: (BOOL) flag;

- (void)setSticky:(BOOL)flag;

- (void)setController:(id)aController;

@end

