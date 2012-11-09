//
//  NSWindowFade.m
//
//  Created by Uli Kusterer on 22.06.05.
//  Copyright 2005 M. Uli Kusterer. All rights reserved.
//

#import "NSWindowFade.h"


@implementation NSWindow (Fade)

-(void)fadeIn {
	[self setAlphaValue:0.0f];
	[[self animator] setAlphaValue:1.0f];
}

-(void)fadeOut {
	[[self animator] setAlphaValue:0.0f];
}

@end
