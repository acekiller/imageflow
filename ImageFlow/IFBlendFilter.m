//
//  IFBlendFilter.m
//  ImageFlow
//
//  Created by Michel Schinz on 09.12.05.
//  Copyright 2005 Michel Schinz. All rights reserved.
//

#import "IFBlendFilter.h"

#import "IFTreeNode.h"
#import "IFEnvironment.h"
#import "IFBlendFilterAnnotationSource.h"
#import "IFAnnotationRect.h"
#import "IFPair.h"
#import "IFBlendMode.h"
#import "IFFunType.h"
#import "IFBasicType.h"
#import "IFImageType.h"
#import "IFParentExpression.h"
#import "IFOperatorExpression.h"
#import "IFVariableExpression.h"

@implementation IFBlendFilter

static NSArray* parentNames = nil;

+ (void)initialize;
{
  if (self != [IFBlendFilter class])
    return; // avoid repeated initialisation

  parentNames = [[NSArray arrayWithObjects:@"background",@"foreground",nil] retain];
}

- (NSArray*)computePotentialTypesForArity:(unsigned)arity;
{
  if (arity == 2)
    return [NSArray arrayWithObject:
            [IFFunType funTypeWithArgumentTypes:[NSArray arrayWithObjects:[IFImageType imageRGBAType],[IFImageType imageRGBAType],nil]
                                     returnType:[IFImageType imageRGBAType]]];
  else
    return [NSArray array];
}

- (NSArray*)potentialRawExpressionsForArity:(unsigned)arity;
{
  static NSArray* exprs = nil;
  if (exprs == nil) {
    IFExpression* opFgd = [IFOperatorExpression expressionWithOperatorNamed:@"opacity" operands:
      [IFParentExpression parentExpressionWithIndex:1],
      [IFVariableExpression expressionWithName:@"alpha"],
      nil];
    IFExpression* trOpFgd = [IFOperatorExpression expressionWithOperatorNamed:@"translate" operands:
      opFgd,[IFVariableExpression expressionWithName:@"translation"],nil];
    exprs = [[NSArray arrayWithObject:
      [IFOperatorExpression blendBackground:[IFParentExpression parentExpressionWithIndex:0]
                             withForeground:trOpFgd
                                     inMode:[IFVariableExpression expressionWithName:@"mode"]]] retain];
  }
  return (arity == 2) ? exprs : [NSArray array];
}

- (NSString*)nameOfParentAtIndex:(int)index;
{
  return [parentNames objectAtIndex:index];
}

- (NSString*)computeLabel;
{
  return NSStringFromBlendMode([[settings valueForKey:@"mode"] intValue]);
}

- (NSString*)toolTip;
{
  NSPoint translation = [[settings valueForKey:@"translation"] pointValue];
  return [NSString stringWithFormat:@"blend\nmode: %@\nforeground opacity: %d%%\nforeground translation: (%d,%d)",
    NSStringFromBlendMode([[settings valueForKey:@"mode"] intValue]),
    (int)floor(100.0 * [[settings valueForKey:@"alpha"] floatValue]),
    (int)translation.x, (int)translation.y];
}

- (NSArray*)editingAnnotationsForView:(NSView*)view;
{
  IFVariable* source = [IFBlendFilterAnnotationSource blendAnnotationSourceForNode:self];
  return [NSArray arrayWithObject:[IFAnnotationRect annotationRectWithView:view source:source]];
}

- (NSAffineTransform*)transformForParentAtIndex:(int)index;
{
  switch (index) {
    case 0:
      return [NSAffineTransform transform];
    case 1: {
      NSPoint translation = [[settings valueForKey:@"translation"] pointValue];
      NSAffineTransform* transform = [NSAffineTransform transform];
      [transform translateXBy:translation.x yBy:translation.y];
      return transform;
    }
    default:
      NSAssert1(NO, @"invalid parent index %d",index);
      return nil;
  }
}

- (NSArray*)modes;
{
  return [NSArray arrayWithObjects:
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_SourceOver) snd:[NSNumber numberWithInt:IFBlendMode_SourceOver]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_Color) snd:[NSNumber numberWithInt:IFBlendMode_Color]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_ColorBurn) snd:[NSNumber numberWithInt:IFBlendMode_ColorBurn]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_ColorDodge) snd:[NSNumber numberWithInt:IFBlendMode_ColorDodge]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_Darken) snd:[NSNumber numberWithInt:IFBlendMode_Darken]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_Difference) snd:[NSNumber numberWithInt:IFBlendMode_Difference]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_Exclusion) snd:[NSNumber numberWithInt:IFBlendMode_Exclusion]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_HardLight) snd:[NSNumber numberWithInt:IFBlendMode_HardLight]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_Hue) snd:[NSNumber numberWithInt:IFBlendMode_Hue]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_Lighten) snd:[NSNumber numberWithInt:IFBlendMode_Lighten]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_Luminosity) snd:[NSNumber numberWithInt:IFBlendMode_Luminosity]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_Multiply) snd:[NSNumber numberWithInt:IFBlendMode_Multiply]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_Overlay) snd:[NSNumber numberWithInt:IFBlendMode_Overlay]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_Saturation) snd:[NSNumber numberWithInt:IFBlendMode_Saturation]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_Screen) snd:[NSNumber numberWithInt:IFBlendMode_Screen]],
    [IFPair pairWithFst:NSStringFromBlendMode(IFBlendMode_SoftLight) snd:[NSNumber numberWithInt:IFBlendMode_SoftLight]],
    nil];
}

@end
