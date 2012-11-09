/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBWindowLevel.h"


static NSInteger sWindowLevel;

@implementation DBWindowLevel

+ (NSInteger) windowLevel {	return sWindowLevel; }

+ (void) setWindowLevel: (NSInteger) level
{
	level != sWindowLevel ? ^{
		sWindowLevel = level;
		[[NSNotificationCenter defaultCenter] postNotificationName: kWindowLevelChangedNotification object: nil];
	}() : nil;
}


@end