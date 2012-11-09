/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>

static NSS* kWindowLevelChangedNotification = @"WindowLevelChanged";
#pragma unused(kWindowLevelChangedNotification)
@interface DBWindowLevel : NSObject
{
}
+ (NSI) windowLevel;
+ (void) setWindowLevel: (NSI) level;
@end