/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBPlistUtils.h"


@implementation DBPlistUtils

/*+ (void) setIsBackgroundApp: (BOOL) flag
{
	NSDictionary* plistTags = (NSD*) CFBundleGetLocalInfoDictionary(CFBundleGetMainBundle());applicationservices
	
	if (flag)
	{
		[plistTags setValue: @"1" forKey: @"NSUIElement"];
	}
	else
	{
		[plistTags setValue: @"0" forKey: @"NSUIElement"];
	}
	
	[plistTags writeToFile: [self plistFilePath] atomically: YES];
}*/

+ (void)setIsBackgroundApp:(BOOL)bgappflag {
	NSDictionary *plistTags = [NSDictionary dictionaryWithContentsOfFile:[self plistFilePath]];
	if (bgappflag) {
		[plistTags setValue:@"1" forKey:@"NSUIElement"];
	} else {
		[plistTags setValue:@"0" forKey:@"NSUIElement"];
	}
	[plistTags writeToFile:[self plistFilePath] atomically:YES];
	[[NSWorkspace sharedWorkspace] noteFileSystemChanged];
	[self updateApp];
}

+ (BOOL)isBackgroundApp {
	NSDictionary *plistTags = [NSDictionary dictionaryWithContentsOfFile:[self plistFilePath]];
	if ([plistTags[@"NSUIElement"] isEqualTo:@"1"]) {
		return YES;
	} else {
		return NO;
	}
}

+ (NSString *)plistFilePath {
	return [NSString stringWithFormat:@"%@/Contents/Info.plist", [[NSBundle mainBundle] bundlePath]];
}

+ (void)updateApp {
	NSTask *touch = [[NSTask alloc] init];
	[touch setLaunchPath:@"/usr/bin/touch"];
	[touch setArguments:@[[[NSBundle mainBundle] bundlePath]]];
	[touch launch];
	[touch waitUntilExit];
	[touch release];
}

@end