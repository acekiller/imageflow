//
//  IFNodeCompositeLayer.h
//  ImageFlow
//
//  Created by Michel Schinz on 16.08.08.
//  Copyright 2008 Michel Schinz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IFCompositeLayer.h"
#import "IFTreeNode.h"
#import "IFTree.h"
#import "IFVariable.h"
#import "IFLayoutParameters.h"

@interface IFNodeCompositeLayer : IFCompositeLayer {
  // Sublayers (not retained)
  CALayer* displayedImageLayer;
  CALayer<IFBaseLayer>* baseLayer;
  CALayer* cursorLayer;
  CALayer* highlightLayer;
}

+ (id)layerForNode:(IFTreeNode*)theNode ofTree:(IFTree*)theTree layoutParameters:(IFLayoutParameters*)theLayoutParameters canvasBounds:(IFVariable*)theCanvasBoundsVar;
- (id)initWithNode:(IFTreeNode*)theNode ofTree:(IFTree*)theTree layoutParameters:(IFLayoutParameters*)theLayoutParameters canvasBounds:(IFVariable*)theCanvasBoundsVar;

@end
