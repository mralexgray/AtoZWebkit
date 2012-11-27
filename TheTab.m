
#import "TheTab.h"
#import <AtoZ/AtoZ.h>

@implementation TheTab

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(BOOL) isOpaque { return YES; }


- (void)drawRect:(NSRect)dirtyRect
{
	[CLEAR set];
	NSRectFill(dirtyRect);
	NSR pad = AZRectTrimmedOnRight(dirtyRect, 50);
	pad = AZRectExtendedOnLeft(pad, 40);

	NSBP* padP = [NSBezierPath bezierPathWithRightRoundedRect:pad radius:25];
	NSR tab = AZRectBy(50, 100);
	tab = AZCenterRectOnPoint(tab, (NSP){dirtyRect.size.width-30, NSMidY(dirtyRect)});
	NSBP* tabP = [NSBezierPath bezierPathWithRightRoundedRect:tab radius:25];
	NSBP *combo = [padP az_union:tabP];
//	[[NSC leatherTintedWithColor:GRAY8] set];

	NSC* c =[NSC leatherTintedWithColor:GRAY2];
	[c set];
	[combo fill];
	[combo setLineWidth:4];
	[WHITE set];
	[combo strokeInside];
	[RED set];
	[combo setDashPattern:@[@15,@15]];

	[combo strokeInside];
	[c set];
	NSRectFill(NSMakeRect(0, 4, 4, dirtyRect.size.height-8));
	
}

@end
