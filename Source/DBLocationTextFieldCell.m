/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBLocationTextFieldCell.h"

@interface NSTextFieldCell (Private)
- (void) _drawFocusRingWithFrame: (NSR) rect;
- (NSR) _focusRingFrameForFrame: (NSR) editFrame cellFrame: (NSR) cellFrame;
@end

const short		kImagePadding		= 3;
NSS* const kDefaultImageName	= @"DefaultLocationFieldIcon";
@implementation DBLocationTextFieldCell

- (id) initTextCell: (NSS*) text
{
	if (self = [super initTextCell: text])
	{
		[self setImage: [NSImage imageNamed: kDefaultImageName]];
	}
	
	return self;
}
- (void) dealloc
{
	[mImage release];
}

#pragma mark -
- (NSImage*) image
{	
	return mImage;
}
- (void) setImage: (NSImage*) image
{
	if (image != mImage)
	{
		[mImage release];
		
		mImage = image;
		
		if (mImage == nil)
		{
			mImage = [NSImage imageNamed: kDefaultImageName];
		}
		
		[mImage setScalesWhenResized: YES];
		
		[[self controlView] setNeedsDisplay: YES];
		[[self controlView] setKeyboardFocusRingNeedsDisplayInRect: [[self controlView] frame]];
	}
}
- (void) setExtraSpaceOnRight: (NSSZ) extraSize
{
	mSpaceOnRight = extraSize;
	[[self controlView] setNeedsDisplay: YES];
}

#pragma mark -
- (NSR) imageRectForFrame: (NSR) frame
{
	return NSMakeRect(NSMinX(frame), NSMinY(frame), NSHeight(frame), NSHeight(frame));
}
- (NSR) textRectForFrame: (NSR) frame
{
	NSR imageRect = [self imageRectForFrame: frame];
	
	// Hack: Subtracting kImagePadding from the origin (and adding to width) because otherwise the text is too far away from the icon. Ick.
	NSR textRect = NSMakeRect(NSMinX(frame) + NSWidth(imageRect) - kImagePadding, NSMinY(frame), NSWidth(frame) - NSWidth(imageRect) + kImagePadding - mSpaceOnRight.width, NSHeight(frame));
	
	return textRect;
}

#pragma mark -
- (void) drawImageWithFrame: (NSR) frameRect inView: (NSView*) controlView
{
	NSGraphicsContext* currentGraphicsContext = [NSGraphicsContext currentContext];
	
	[currentGraphicsContext saveGraphicsState];
	[currentGraphicsContext setImageInterpolation: NSImageInterpolationNone];
	
//	[[self image] setSize: frameRect.size];
//	[[self image] compositeToPoint: frameRect.origin operation: NSCompositeSourceOver];
	{
		NSSZ		newImageSize	= [self imageRectForFrame: frameRect].size;
		NSImageRep* prettyImageRep	= [[self image] bestRepresentationForDevice: nil];
		NSImage*	newImage		= [[NSImage alloc] initWithSize: newImageSize];
		
		[newImage lockFocus];
		
			[[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];
			[prettyImageRep drawInRect: NSMakeRect(0, 0, newImageSize.width, newImageSize.height)];
		
		[newImage unlockFocus];
		
		[newImage compositeToPoint: frameRect.origin operation: NSCompositeSourceOver];
		
		[newImage release];
	}
	[currentGraphicsContext restoreGraphicsState];
}
- (void) drawInteriorWithFrame: (NSR) frameRect inView: (NSView*) controlView
{
	NSR imageRect	= [self imageRectForFrame: frameRect];
	NSR textRect		= [self textRectForFrame: frameRect];
	
	if ([self image] != nil)
	{
		if ([[self controlView] isFlipped])
		{
			imageRect.origin.y	+= NSHeight(imageRect) - kImagePadding;
		}
		else
		{
			imageRect.origin.y	+= kImagePadding;
		}
		
		imageRect.origin.x		+= kImagePadding;
		imageRect.size.width	-= kImagePadding * 2;
		imageRect.size.height	-= kImagePadding * 2;
		
		[self drawImageWithFrame: imageRect inView: controlView];
	}
	
	[super drawInteriorWithFrame: textRect inView: controlView];
}

#pragma mark -
- (void) selectWithFrame: (NSR) frame inView: (NSView*) controlView editor: (NSText*) editor delegate: (id) delegate start: (NSI) selStart length: (NSI) selLength
{
	 [super selectWithFrame: [self textRectForFrame: frame] inView: controlView editor: editor delegate: delegate start: selStart length: selLength];
}
- (void) editWithFrame: (NSR) frame inView: (NSView*) controlView editor: (NSText*) editor delegate: (id) delegate event: (NSEvent*) event
{
	 [super editWithFrame: [self textRectForFrame: frame] inView: controlView editor: editor delegate: delegate event: event];
}
- (void) resetCursorRect: (NSR) cellFrame inView: (NSView*) controlView
{
	[super resetCursorRect: [self textRectForFrame: cellFrame] inView: controlView];
}

@end

@implementation DBLocationTextFieldCell (Private)

- (void) _drawFocusRingWithFrame: (NSR) rect
{
	 [super _drawFocusRingWithFrame: rect];
}
- (NSR) _focusRingFrameForFrame: (NSR) editFrame cellFrame: (NSR) cellFrame
{
	NSR focusRingFrame		= [super _focusRingFrameForFrame: editFrame cellFrame: cellFrame];
	 NSR textRect				= [self textRectForFrame:cellFrame];
	
	 focusRingFrame.origin.x		-= NSMinX(textRect) - NSMinX(cellFrame);
	 focusRingFrame.size.width	+= NSWidth(cellFrame) - NSWidth(textRect);
	
	 return focusRingFrame;
}

@end
