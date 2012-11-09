/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>
#import "ThreadWorker.h"

@interface DBViewSourceWindowController : NSWindowController {
	IBOutlet	NSTextView	*sourceView;
	IBOutlet NSProgressIndicator *status;
	NSS *sourceCode;
}
- (IBAction)saveCode:(id)sender;
- (IBAction)refreshTheSourceCode:(id)sender;
- (void)setSourceCode:(NSS *)aStr;
- (NSS *)sourceCode;
- (void)setTitle:(NSS *)title;
- (void)doColorSyntax;
- (void)coloringDone:(ThreadWorker *)tw;
@end
