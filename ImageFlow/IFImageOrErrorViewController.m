//
//  IFImageOrErrorViewController.m
//  ImageFlow
//
//  Created by Michel Schinz on 13.11.06.
//  Copyright 2006 Michel Schinz. All rights reserved.
//

#import "IFImageOrErrorViewController.h"

#import "IFErrorConstantExpression.h"
#import "IFOperatorExpression.h"
#import "NSAffineTransformIFAdditions.h"

typedef enum {
  IFFilterDelegateHasMouseDown    = 1<<0,
  IFFilterDelegateHasMouseDragged = 1<<1,
  IFFilterDelegateHasMouseUp      = 1<<2
} IFFilterDelegateCapabilities;

@interface IFImageOrErrorViewController (Private)
- (void)setActiveView:(NSView*)newActiveView;
- (void)setErrorMessage:(NSString*)newErrorMessage;
- (void)setViewedNode:(IFTreeNode*)newViewedNode;
- (void)setExpression:(IFExpression*)newExpression;
- (void)updateImageViewVisibleBounds;
- (void)updateExpression;
- (void)updateAnnotations;
- (void)updateVariants;
@end

@implementation IFImageOrErrorViewController

static NSString* IFViewedExpressionDidChange = @"IFViewedExpressionDidChange";
static NSString* IFEditedNodeDidChange = @"IFEditedNodeDidChange";
static NSString* IFCanvasBoundsDidChange = @"IFCanvasBoundsDidChange";

- (id)init;
{
  if (![super initWithViewNibName:@"IFImageView"])
    return nil;
  mode = IFImageViewModeView;
  expression = nil;
  errorMessage = nil;
  variants = [[NSArray array] retain];
  activeVariant = nil;
  cursors = nil;
  viewedNode = nil;
  canvasBounds = nil;
  marginSize = 200;
  marginDirection = IFDown;
  return self;
}

- (void)dealloc;
{
  OBJC_RELEASE(viewedNode);
  [self setCanvasBounds:nil];
  [self setCursorPair:nil];
  OBJC_RELEASE(activeVariant);
  OBJC_RELEASE(variants);
  OBJC_RELEASE(errorMessage);
  OBJC_RELEASE(expression);
  activeView = nil;
  OBJC_RELEASE(imageView);
  OBJC_RELEASE(imageOrErrorTabView);
  [super dealloc];
}

- (void)awakeFromNib;
{
  NSScrollView* scrollView = [imageView enclosingScrollView];
  [scrollView setHasHorizontalRuler:YES];
  [scrollView setHasVerticalRuler:YES];
  [scrollView setRulersVisible:YES];

  [imageView setDelegate:self];
  
  [self setActiveView:imageOrErrorTabView];
}

- (IFImageView*)imageView;
{
  return imageView;
}

- (NSView*)activeView;
{
  return activeView;
}

- (void)setCursorPair:(IFTreeCursorPair*)newCursors;
{
  if (newCursors == cursors)
    return;
  
  if (cursors != nil) {
    [[cursors viewMark] removeObserver:self forKeyPath:@"node.expression"];
    [[cursors editMark] removeObserver:self forKeyPath:@"node"];
    [cursors release];
  }
  if (newCursors != nil) {
    [[newCursors viewMark] addObserver:self forKeyPath:@"node.expression" options:0 context:IFViewedExpressionDidChange];
    [[newCursors editMark] addObserver:self forKeyPath:@"node" options:0 context:IFEditedNodeDidChange];
    [newCursors retain];
  }
  cursors = newCursors;
}

- (IFTreeCursorPair*)cursorPair;
{
  return cursors;
}

- (void)setMode:(IFImageViewMode)newMode;
{
  if (newMode == mode)
    return;

  mode = newMode;

  [self updateVariants];
  [self updateAnnotations];
}

- (IFImageViewMode)mode;
{
  return mode;
}

- (void)setCanvasBounds:(IFVariable*)newCanvasBounds;
{
  if (newCanvasBounds == canvasBounds)
    return;
  
  if (canvasBounds != nil) {
    [canvasBounds removeObserver:self forKeyPath:@"value"];
    [canvasBounds release];
  }
  canvasBounds = newCanvasBounds;
  if (canvasBounds != nil) {
    [canvasBounds addObserver:self forKeyPath:@"value" options:0 context:IFCanvasBoundsDidChange];
    [canvasBounds retain];
  }
  
  [imageView setCanvasBounds:canvasBounds];
  [self updateImageViewVisibleBounds];
}

- (void)setMarginSize:(float)newMarginSize;
{
  if (newMarginSize == marginSize)
    return;
  marginSize = newMarginSize;
  [self updateImageViewVisibleBounds];
}

- (float)marginSize;
{
  return marginSize;
}

- (void)setMarginDirection:(IFDirection)newMarginDirection;
{
  if (newMarginDirection == marginDirection)
    return;
  marginDirection = newMarginDirection;
  [self updateImageViewVisibleBounds];
}

- (IFDirection)marginDirection;
{
  return marginDirection;
}

- (NSString*)errorMessage;
{
  return errorMessage;
}

- (NSArray*)variants;
{
  return variants;
}

- (void)setVariants:(NSArray*)newVariants;
{
  if (newVariants == variants)
    return;

  if (![newVariants containsObject:[self activeVariant]])
    [self setActiveVariant:[newVariants objectAtIndex:0]];

  [variants release];
  variants = [newVariants copy];
}

- (NSString*)activeVariant;
{
  return activeVariant;
}

- (void)setActiveVariant:(NSString*)newActiveVariant;
{
  if (newActiveVariant == activeVariant)
    return;

  [activeVariant release];
  activeVariant = [newActiveVariant retain];

  [self updateExpression];
}

- (void)handleMouseDown:(NSEvent*)event;
{
  [editedNode mouseDown:event inView:imageView viewFilterTransform:[cursors viewEditTransform]];
}

- (void)handleMouseDragged:(NSEvent*)event;
{
  [editedNode mouseDragged:event inView:imageView viewFilterTransform:[cursors viewEditTransform]];
}

- (void)handleMouseUp:(NSEvent*)event;
{
  [editedNode mouseUp:event inView:imageView viewFilterTransform:[cursors viewEditTransform]];
}

@end

@implementation IFImageOrErrorViewController (Private)

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context;
{
  if (context == IFViewedExpressionDidChange) {
    if ([[cursors viewMark] node] != viewedNode) {
      [self updateVariants];
      [self updateAnnotations];
      [self setViewedNode:[[cursors viewMark] node]];
    }
    [self updateExpression];
  } else if (context == IFEditedNodeDidChange) {
    [self updateAnnotations];

    editedNode = [[cursors editMark] node];
  } else if (context == IFCanvasBoundsDidChange) {
    [self updateImageViewVisibleBounds];
  } else
    NSAssert1(NO, @"unexpected context %@", context);
}

- (void)setActiveView:(NSView*)newActiveView;
{
  activeView = newActiveView;
}

- (void)setErrorMessage:(NSString*)newErrorMessage;
{
  if (newErrorMessage == errorMessage)
    return;
  [errorMessage release];
  errorMessage = [newErrorMessage copy];
}

- (void)setViewedNode:(IFTreeNode*)newViewedNode;
{
  if (newViewedNode == viewedNode)
    return;
  [viewedNode release];
  viewedNode = [newViewedNode retain];
}

- (void)setExpression:(IFExpression*)newExpression;
{
  if (newExpression == expression)
    return;

  IFExpressionEvaluator* evaluator = [IFExpressionEvaluator sharedEvaluator];
  NSRect dirtyRect = (expression == nil || newExpression == nil)
    ? NSRectInfinite()
    : [[cursors editViewTransform] transformRect:[evaluator deltaFromOld:expression toNew:newExpression]];

  [expression release];
  expression = [newExpression retain];

  IFConstantExpression* evaluatedExpr = [evaluator evaluateExpressionAsMaskedImage:expression
                                                                            cutout:[[canvasBounds value] rectValue]];

  if ([evaluatedExpr isError]) {
    [self setErrorMessage:[(IFErrorConstantExpression*)evaluatedExpr message]];
    [imageOrErrorTabView selectTabViewItemAtIndex:1];
    [self setActiveView:imageOrErrorTabView];
    [imageView setImage:nil dirtyRect:NSRectInfinite()];
    [self setMode:IFImageViewModeEdit];
  } else {
    [imageView setImage:[(IFImageConstantExpression*)evaluatedExpr image] dirtyRect:dirtyRect];
    [self setErrorMessage:nil];
    [imageOrErrorTabView selectTabViewItemAtIndex:0];
    [self setActiveView:imageView];
  }
}

- (void)updateImageViewVisibleBounds;
{
  NSRect realCanvasBounds = NSInsetRect([[canvasBounds value] rectValue],-20,-20);
  NSRect marginRect = NSZeroRect;
  switch (marginDirection) {
    case IFUp:
      marginRect = NSMakeRect(NSMinX(realCanvasBounds),NSMaxY(realCanvasBounds),NSWidth(realCanvasBounds),marginSize);
      break;
    case IFRight:
      marginRect = NSMakeRect(NSMaxX(realCanvasBounds),NSMinY(realCanvasBounds),marginSize,NSHeight(realCanvasBounds));
      break;
    case IFDown:
      marginRect = NSMakeRect(NSMinX(realCanvasBounds),NSMinY(realCanvasBounds) - marginSize,NSWidth(realCanvasBounds),marginSize);
      break;
    case IFLeft:
      marginRect = NSMakeRect(NSMinX(realCanvasBounds) - marginSize,NSMinY(realCanvasBounds),marginSize,NSHeight(realCanvasBounds));
      break;
    default:
      NSAssert(NO, @"internal error");
  }
  [imageView setVisibleBounds:NSUnionRect(realCanvasBounds, marginRect)];
  
  // HACK should avoid this, to prevent redrawing of the whole image!
  [self setExpression:[IFOperatorExpression nop]];
  [self updateExpression];
}

- (void)updateExpression;
{
  IFTreeNode* node = [[cursors viewMark] node];
  IFExpression* expr = (node != nil ? [node expression] : [IFOperatorExpression nop]);
  if ([self activeVariant] != nil && ![[self activeVariant] isEqualToString:@""])
    expr = [node variantNamed:[self activeVariant] ofExpression:expr];
  [self setExpression:expr];
}

- (void)updateAnnotations;
{
  if (mode == IFImageViewModeView)
    [imageView setAnnotations:nil];
  else {
    IFTreeNode* nodeToEdit = [[cursors editMark] node];
    [imageView setAnnotations:[nodeToEdit editingAnnotationsForView:imageView]];
  }
}

- (void)updateVariants;
{
  [self setVariants:(mode == IFImageViewModeView
                     ? [[[cursors viewMark] node] variantNamesForViewing]
                     : [[[cursors viewMark] node] variantNamesForEditing])];
}

@end