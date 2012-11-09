/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>

@interface DBBezelController : NSObject {
	NSWindow *bezel;
	NSS *file;
	NSTimer *timer;
	NSTextField *filenameDisplay;
	NSImageView *imageView;
	NSImageView *bgView;
}
//- (void)setDownloadFile:(NSS *)filename;
//- (NSS *)downloadFile;
@property (strong, nonatomic) NSS*downloadFile;

- (void)showBezel;
- (void)showBezelForFile:(NSS *)filename;
- (void)hideBezel;
- (void)handleNotification:(NSNotification *)note;
@end
