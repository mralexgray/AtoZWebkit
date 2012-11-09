/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/


#import "DBAntiPhisingValidator.h"


@implementation DBAntiPhisingValidator

- (IBAction)menuHandler:(id)sender {
	NSDictionary *dic = @{@"URLString": @"http://www.antiphishing.org/consumer_recs.html"};
	[AZNOTCENTER postNotificationName:@"DBLoadURLNotification"
														object:self
													  userInfo:dic];
}

+ (BOOL)validateLink:(NSURL *)urlLink {
	//NSString *u = [urlLink absoluteString];
	return YES;
}

@end
