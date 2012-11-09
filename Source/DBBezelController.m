/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/


#import "DBBezelController.h"


@implementation DBBezelController
- (id)init {
	self = [super init];
	
	if (self) {
		NSR screen = [[NSScreen mainScreen] frame];
		CGFloat width = 220;
		CGFloat height = 186;
		bezel = [[NSWindow alloc] initWithContentRect:NSMakeRect(((screen.size.width/2) - (width/2)), ((screen.size.height/2) - height), width, height) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
		[bezel setOpaque:NO];
		[bezel setLevel:NSStatusWindowLevel];
		[bezel setBackgroundColor:[NSColor clearColor]];
		[bezel setHasShadow:YES];
		
		bgView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 220, 186)];
		[bgView setImage:[NSImage imageNamed:@"dlcb"]];
		[[bezel contentView] addSubview:bgView];
		
		imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(12, 40, (width - 26), (height - 26))];
		[imageView setImage:[NSImage imageNamed:@"downloadComplete"]];
		[[bezel contentView] addSubview:imageView];
		
		filenameDisplay = [[NSTextField alloc] initWithFrame:NSMakeRect(5, 20, (width - 10), 20)];
		[filenameDisplay setEditable:NO];
		[filenameDisplay setFont:[NSFont boldSystemFontOfSize:12]];
		[filenameDisplay setTextColor:[NSColor whiteColor]];
		[filenameDisplay setDrawsBackground:NO];
		[filenameDisplay setBezeled:NO];
		[filenameDisplay setBordered:NO];
		[filenameDisplay setAlignment:NSCenterTextAlignment];
		
		[[bezel contentView] addSubview:filenameDisplay];
		
		file = [[NSString alloc] initWithString:@""];
		
		[AZNOTCENTER addObserver:self selector:@selector(handleNotification:) name:@"DBNotification" object:nil];
	}
	return self;
}

- (void)dealloc {
	[AZNOTCENTER removeObserver:self];
	[bezel release];
	[file release];
	[timer release];
	[filenameDisplay release];
	[imageView release];
	[bgView release];
	
}

- (void)handleNotification:(NSNotification *)note {
	NSString *type = ((NSString *)[note userInfo][@"notificationType"]);
	if ([type isEqualToString:@"showBezelForFile"]) {
		NSString *tFile = ((NSString *)[note userInfo][@"filename"]);
		[self showBezelForFile:tFile];
		[tFile release];
	}
}

- (void)setDownloadFile:(NSString *)filename {
	[file release];
	file = filename;
}

- (NSString *)downloadFile {
	return file;
}

- (void)showBezel {
	[filenameDisplay setStringValue:file];
	[bezel setAlphaValue:0.0];
	[bezel setIsVisible:YES];
	[bezel display];
	[bezel invalidateShadow];
	timer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(fadeInWindow:) userInfo:nil repeats:YES];
}

- (void)showBezelForFile:(NSString *)filename {
	[self setDownloadFile:filename];
	[self showBezel];
}

- (void)hideBezel {
	timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fadeOutWindow:) userInfo:nil repeats:YES];
}

- (void)fadeOutWindow:(NSTimer *)theTimer {
	 if ([bezel alphaValue] > 0.0) {
		  [bezel setAlphaValue:[bezel alphaValue] - 0.1];
	 } else {
		  [timer invalidate];
		  [timer release];
		timer = nil;
	 }
}

- (void)fadeInWindow:(NSTimer *)theTimer {
	 if ([bezel alphaValue] < 1.0) {
		  [bezel setAlphaValue:[bezel alphaValue] + 0.2];
	 } else {
		  [timer invalidate];
		  [timer release];
		  timer = nil;
		  
		  [bezel setAlphaValue:1.0];
		timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideBezel) userInfo:nil repeats:NO];
	 }
}

@end
