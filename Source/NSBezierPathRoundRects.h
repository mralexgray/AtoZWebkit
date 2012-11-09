//
//  NSBezierPathRoundRects.m
//  UKDockableWindow
//
//  Created by Uli Kusterer on Wed Feb 04 2004.
//  Based on code by John C. Randolph.
//  Copyright (c) 2004 M. Uli Kusterer. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSBezierPath (RoundRects)

+(void)			fillRoundRectInRect:(NSR)rect radius:(CGFloat) radius;
+(void)			strokeRoundRectInRect:(NSR)rect radius:(CGFloat) radius;
+(NSBezierPath*)		  bezierPathWithRoundRectInRect:(NSR)rect radius:(CGFloat) radius;
NSP  UKCenterOfRect( NSR rect );
NSP  UKTopCenterOfRect( NSR rect );
NSP  UKTopLeftOfRect( NSR rect );
NSP  UKTopRightOfRect( NSR rect );
NSP  UKLeftCenterOfRect( NSR rect );
NSP  UKBottomCenterOfRect( NSR rect );
NSP  UKBottomLeftOfRect( NSR rect );
NSP  UKBottomRightOfRect( NSR rect );
NSP  UKRightCenterOfRect( NSR rect );

@end
