//
//  IFDisplayedImageLayer.m
//  ImageFlow
//
//  Created by Michel Schinz on 28.08.08.
//  Copyright 2008 Michel Schinz. All rights reserved.
//

#import "IFDisplayedImageLayer.h"
#import "IFLayoutParameters.h"

@implementation IFDisplayedImageLayer

static NSImage* lockLockedImage;
static NSImage* lockUnlockedImage;

+ (void)initialize;
{
  if (self != [IFDisplayedImageLayer class])
    return; // avoid repeated initialisation
  lockLockedImage = [[NSImage imageNamed:NSImageNameLockLockedTemplate] retain];
  lockUnlockedImage = [[NSImage imageNamed:NSImageNameLockUnlockedTemplate] retain];
}

+ (id)displayedImageLayer;
{
  return [[[self alloc] init] autorelease];
}

- (id)init;
{
  if (![super init])
    return nil;
  self.backgroundColor = [IFLayoutParameters sharedLayoutParameters].displayedImageBackgroundColor;
  
  NSSize lockSize = [lockLockedImage size];
  float lockMaxSize = fmax(lockSize.width, lockSize.height) + 4.0;
  
  // Create sublayers, whose contents is provided by this layer (which is the sublayers' delegate)
  lockLayer = [CALayer layer];
  lockLayer.frame = CGRectMake(3, CGRectGetHeight(self.bounds) - 15, lockMaxSize, lockMaxSize); // TODO: use image size to place lock correctly
  lockLayer.autoresizingMask = kCALayerMaxXMargin | kCALayerMinYMargin;
  lockLayer.delegate = self;
  [self addSublayer:lockLayer];
  [lockLayer setNeedsDisplay];
  
  return self;
}

// delegate methods

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx;
{
  NSAssert(layer == lockLayer, @"unexpected layer");
  
  NSGraphicsContext *nsGraphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO];
  [NSGraphicsContext saveGraphicsState];
  [NSGraphicsContext setCurrentContext:nsGraphicsContext];
  if (layer == lockLayer) {
    [[NSColor colorWithCalibratedWhite:0.5 alpha:0.5] setFill];
    [[NSBezierPath bezierPathWithOvalInRect:NSRectFromCGRect(layer.bounds)] fill];
    [lockLockedImage compositeToPoint:NSMakePoint(4, 4) operation:NSCompositeSourceOver];
  }
  [NSGraphicsContext restoreGraphicsState];
}

@end