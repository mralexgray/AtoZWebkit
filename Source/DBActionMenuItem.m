/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBActionMenuItem.h"

@implementation DBActionMenuItem
- (id)initWithFrame:(NSR)frame {
	 return [self initWithFrame:frame label:@""];
}
- (id)initWithFrame:(NSR)frame label:(NSS*) aLabel {
	self = [super initWithFrame:frame];
	if (self) {
		[self setLabel:aLabel];
		_tag = 0;
	}
	return self;
}
//- (void)dealloc {
//	[label release];
//}
- (BOOL)acceptsFirstResponder {
	return YES;
}
- (void)drawRect:(NSR)rect {
	NSMD *textStatic = [[NSMD alloc] init];
	textStatic[NSForegroundColorAttributeName] = [NSColor colorWithDeviceWhite:1.0 alpha:1.0];
	textStatic[NSFontAttributeName] = [NSFont systemFontOfSize:12];
	
	 [label drawInRect:rect withAttributes:textStatic];
	
//	[textStatic release];
}
- (void)mouseEntered:(NSEvent *)theEvent {
}
- (void)mouseDown:(NSEvent *)theEvent {
	NSMD *dic = [[NSMD alloc] init];
	dic[@"sender"] = label;
	[AZNOTCENTER postNotificationName:@"DBActionMenuItemNotification"
														object:self
													  userInfo:dic];
//	[dic release];
}
- (void)setLabel:(NSS*) aLabel {
//	[label release];
	label = aLabel;
}
- (NSS*) label {
	return label;
}
@end
