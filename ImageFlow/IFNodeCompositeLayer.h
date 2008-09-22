//
//  IFNodeCompositeLayer.h
//  ImageFlow
//
//  Created by Michel Schinz on 16.08.08.
//  Copyright 2008 Michel Schinz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IFCompositeLayer.h"

@interface IFNodeCompositeLayer : IFCompositeLayer {
}

+ (id)layerForNode:(IFTreeNode*)theNode;
- (id)initWithNode:(IFTreeNode*)theNode;

@end
