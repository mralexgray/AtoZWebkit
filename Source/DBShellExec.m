/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBShellExec.h"

@implementation DBShellExec
+ (NSS *)executeShellCommand:(NSS *)command {
	NSS *tmp = @(tmpnam(NULL));
	// set up the command
	NSS *com = [NSString stringWithFormat:@"%@ > %@", command, tmp];
	// execute the command
	system([com UTF8String]);
	// get the result
	NSS *path = [NSString stringWithFormat:@"%@", tmp];
	NSS *result = [NSString stringWithContentsOfFile:path];
	[[NSFileManager defaultManager] removeFileAtPath:path handler:nil];
	return result;
}
@end
