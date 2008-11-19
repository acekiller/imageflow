//
//  IFLayoutParameters.h
//  ImageFlow
//
//  Created by Michel Schinz on 22.09.08.
//  Copyright 2008 Michel Schinz. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IFLayoutParameters : NSObject {
  CGColorRef backgroundColor;
  float nodeInternalMargin;
  float gutterWidth;
  
  CGColorRef nodeBackgroundColor;
  CGColorRef nodeLabelColor;
  
  NSFont* labelFont;
  float labelFontHeight;
  
  CGColorRef connectorColor;
  CGColorRef connectorLabelColor;
  float connectorArrowSize;
  
  CGColorRef displayedImageUnlockedBackgroundColor;
  CGColorRef displayedImageLockedBackgroundColor;
  CGColorRef cursorColor;
  float cursorWidth;
  float selectionWidth;

  CGColorRef templateLabelColor;
  
  CGColorRef highlightBackgroundColor;
  CGColorRef highlightBorderColor;
  
  NSFont* dragBadgeFont;
  float dragBadgeFontHeight;
}

+ (IFLayoutParameters*)sharedLayoutParameters;

@property(readonly) CGColorRef backgroundColor;
@property(readonly) float nodeInternalMargin;
@property(readonly) float gutterWidth;

@property(readonly) CGColorRef nodeBackgroundColor;
@property(readonly) CGColorRef nodeLabelColor;

@property(readonly) NSFont* labelFont;
@property(readonly) float labelFontHeight;

@property(readonly) CGColorRef connectorColor;
@property(readonly) CGColorRef connectorLabelColor;
@property(readonly) float connectorArrowSize;

@property(readonly) CGColorRef displayedImageUnlockedBackgroundColor;
@property(readonly) CGColorRef displayedImageLockedBackgroundColor;
@property(readonly) CGColorRef cursorColor;
@property(readonly) float cursorWidth;
@property(readonly) float selectionWidth;

@property(readonly) CGColorRef templateLabelColor;

@property(readonly) CGColorRef highlightBackgroundColor;
@property(readonly) CGColorRef highlightBorderColor;

@property(readonly) NSFont* dragBadgeFont;
@property(readonly) float dragBadgeFontHeight;

@end
