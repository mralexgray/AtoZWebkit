/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBWindowLevel.h"

static NSInteger sWindowLevel;
@implementation DBWindowLevel
+ (NSI) windowLevel {	return sWindowLevel; }
+ (void) setWindowLevel: (NSI) level
{
	level != sWindowLevel ? ^{
		sWindowLevel = level;
		[AZNOTCENTER postNotificationName: kWindowLevelChangedNotification object: nil];
	}() : nil;
}

@end