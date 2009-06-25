//
//  IFCompositeLayer.h
//  ImageFlow
//
//  Created by Michel Schinz on 04.09.08.
//  Copyright 2008 Michel Schinz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IFTreeNode.h"

@protocol IFBaseLayer
@property(readonly) IFTreeNode* node;
@end

typedef enum {
  IFLayerCursorIndicatorNone,
  IFLayerCursorIndicatorCursor,
  IFLayerCursorIndicatorSelection
} IFLayerCursorIndicator;

@interface IFCompositeLayer : CALayer {

}

@property(readonly) BOOL isNode;
@property(readonly) BOOL isInputConnector;
@property(readonly) BOOL isOutputConnector;

@property(readonly) CALayer* displayedImageLayer; // optional (can be nil)
@property(readonly) CALayer<IFBaseLayer>* baseLayer;
@property(readonly) CALayer* cursorLayer; // optional (can be nil)
@property(readonly) CALayer* highlightLayer;
@property IFLayerCursorIndicator cursorIndicator;
@property BOOL highlighted;

@property(readonly) IFTreeNode* node;

@end
