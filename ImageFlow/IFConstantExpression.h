//
//  IFConstantExpression.h
//  ImageFlow
//
//  Created by Michel Schinz on 20.10.05.
//  Copyright 2005 Michel Schinz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IFExpression.h"

@interface IFConstantExpression : IFExpression {
  NSObject* object;
}

+ expressionWithArray:(NSArray*)theArray;
+ expressionWithObject:(NSObject*)theConstant;
+ expressionWithPointNS:(NSPoint)thePoint;
+ expressionWithRectNS:(NSRect)theRect;
+ expressionWithRectCG:(CGRect)theRect;
+ expressionWithColorNS:(NSColor*)theColor;
+ expressionWithString:(NSString*)theString;
+ expressionWithInt:(int)theInt;
+ expressionWithFloat:(float)theFloat;

- initWithObject:(NSObject*)theConstant;

- (NSArray*)arrayValue;
- (NSArray*)flatArrayValue;
- (NSObject*)objectValue;
- (NSPoint)pointValueNS;
- (NSRect)rectValueNS;
- (CGRect)rectValueCG;
- (NSColor*)colorValueNS;
- (CIColor*)colorValueCI;
- (NSString*)stringValue;
- (int)intValue;
- (BOOL)boolValue;
- (float)floatValue;

- (BOOL)isArray;
- (BOOL)isImage;
- (BOOL)isError;

+ (id)expressionWithCamlValue:(value)camlValue;

@end
