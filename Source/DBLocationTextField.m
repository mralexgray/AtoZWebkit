/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBLocationTextField.h"

#import "DBLocationTextFieldCell.h"


@interface DBLocationTextField (Private)
- (void) frameDidChange: (NSNotification*) notification;
- (NSR) progressIndicatorRectForFrame: (NSR) frame;
@end


const short kProgressIndicatorPadding = 3;

@implementation DBLocationTextField


+ (void) initialize
{
	if (self == [DBLocationTextField class])
	{
		[self setCellClass: [DBLocationTextFieldCell class]];
	}
}

+ (id) cellClass
{
	return [DBLocationTextFieldCell class];
}


#pragma mark -

- (void) awakeFromNib
{
	[self setImage: [NSImage imageNamed: @"TestImage"]];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(frameDidChange:) name: NSViewFrameDidChangeNotification object: self];
	
	
	mProgressIndicator = [[NSProgressIndicator alloc] initWithFrame: NSZeroRect];
	
	[mProgressIndicator setStyle: NSProgressIndicatorSpinningStyle];
	[mProgressIndicator setDisplayedWhenStopped: NO];
	
	[self addSubview: mProgressIndicator];
}

- (void) dealloc
{
	[mProgressIndicator release];
}


#pragma mark -

- (BOOL) isFlipped
{
	return YES;
}


#pragma mark -

- (NSR) progressIndicatorRectForFrame: (NSR) frame
{
	return NSMakeRect(NSWidth(frame) - NSHeight(frame), 0, NSHeight(frame), NSHeight(frame));
}

- (void) animate: (BOOL) animate
{
	if (animate)
	{
		[mProgressIndicator startAnimation: nil];
		[[self cell] setExtraSpaceOnRight: [self progressIndicatorRectForFrame: [self frame]].size];
	}
	else
	{
		[mProgressIndicator stopAnimation: nil];
		[[self cell] setExtraSpaceOnRight: NSZeroSize];
	}
}

- (void) setImage: (NSImage*) image
{
	[[self cell] setImage: image];
}


#pragma mark -

- (void) frameDidChange: (NSNotification*) notification
{
	NSR spinnerRect = [self progressIndicatorRectForFrame: [self frame]];
	
	[[self cell] setExtraSpaceOnRight: spinnerRect.size];
	
	spinnerRect.origin.y	+= kProgressIndicatorPadding;
	spinnerRect.origin.x	+= kProgressIndicatorPadding;
	spinnerRect.size.width	-= kProgressIndicatorPadding << 1;
	spinnerRect.size.height	-= kProgressIndicatorPadding << 1;
	
	[mProgressIndicator setFrame: spinnerRect];
}


@end
