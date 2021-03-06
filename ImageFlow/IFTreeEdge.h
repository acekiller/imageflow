//
//  IFTreeEdge.h
//  ImageFlow
//
//  Created by Michel Schinz on 25.10.07.
//  Copyright 2007 Michel Schinz. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IFTreeEdge : NSObject<NSCoding> {
  unsigned targetIndex;
}

+ (id)edgeWithTargetIndex:(unsigned)theTargetIndex;
- (id)initWithTargetIndex:(unsigned)theTargetIndex;

- (IFTreeEdge*)clone;

- (unsigned)targetIndex;

@end
