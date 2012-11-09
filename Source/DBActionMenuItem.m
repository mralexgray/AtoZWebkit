/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/


#import "DBActionMenuItem.h"


@implementation DBActionMenuItem

- (id)initWithFrame:(NSRect)frame {
	 return [self initWithFrame:frame label:@""];
}

- (id)initWithFrame:(NSRect)frame label:(NSString *)aLabel {
	self = [super initWithFrame:frame];
	if (self) {
		[self setLabel:aLabel];
		_tag = 0;
	}
	return self;
}

- (void)dealloc {
	[label release];
	[super dealloc];
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)drawRect:(NSRect)rect {
	NSMutableDictionary *textStatic = [[NSMutableDictionary alloc] init];
	textStatic[NSForegroundColorAttributeName] = [NSColor colorWithDeviceWhite:1.0 alpha:1.0];
	textStatic[NSFontAttributeName] = [NSFont systemFontOfSize:12];
	
	 [label drawInRect:rect withAttributes:textStatic];
	
	[textStatic release];
}

- (void)mouseEntered:(NSEvent *)theEvent {
}

- (void)mouseDown:(NSEvent *)theEvent {
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	dic[@"sender"] = label;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DBActionMenuItemNotification"
														object:self
													  userInfo:dic];
	[dic release];
}

- (void)setLabel:(NSString *)aLabel {
	[label release];
	label = [aLabel retain];
}

- (NSString *)label {
	return label;
}

@end
