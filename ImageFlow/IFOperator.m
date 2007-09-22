//
//  IFOperator.m
//  ImageFlow
//
//  Created by Michel Schinz on 18.10.05.
//  Copyright 2005 Michel Schinz. All rights reserved.
//

#import "IFOperator.h"
#import "IFXMLCoder.h"
#import "IFDirectoryManager.h"

@interface IFOperator (Private)
- (id)initWithName:(NSString*)theName;
@end

@implementation IFOperator

static NSArray* allOperators = nil;
static NSDictionary* allOperatorsByName;

+ (void)initialize;
{
  if (self != [IFOperator class])
    return; // avoid repeated initialisation
  
  allOperators = [[NSArray arrayWithObjects:
    [[[self alloc] initWithName:@"blend"] autorelease],
    [[[self alloc] initWithName:@"channel-to-mask"] autorelease],
    [[[self alloc] initWithName:@"checkerboard"] autorelease],
    [[[self alloc] initWithName:@"circle"] autorelease],
    [[[self alloc] initWithName:@"color-controls"] autorelease],
    [[[self alloc] initWithName:@"constant-color"] autorelease],
    [[[self alloc] initWithName:@"crop-overlay"] autorelease],
    [[[self alloc] initWithName:@"crop"] autorelease],
    [[[self alloc] initWithName:@"div"] autorelease],
    [[[self alloc] initWithName:@"empty"] autorelease],
    [[[self alloc] initWithName:@"extent"] autorelease],
    [[[self alloc] initWithName:@"file-extent"] autorelease],
    [[[self alloc] initWithName:@"gaussian-blur"] autorelease],
    [[[self alloc] initWithName:@"histogram-rgb"] autorelease],
    [[[self alloc] initWithName:@"invert-mask"] autorelease],
    [[[self alloc] initWithName:@"invert"] autorelease],
    [[[self alloc] initWithName:@"load"] autorelease],
    [[[self alloc] initWithName:@"mask-overlay"] autorelease],
    [[[self alloc] initWithName:@"mask"] autorelease],
    [[[self alloc] initWithName:@"mul"] autorelease],
    [[[self alloc] initWithName:@"nop"] autorelease],
    [[[self alloc] initWithName:@"paint"] autorelease],
    [[[self alloc] initWithName:@"point-mul"] autorelease],
    [[[self alloc] initWithName:@"print"] autorelease],
    [[[self alloc] initWithName:@"rect-mul"] autorelease],
    [[[self alloc] initWithName:@"rect-outset"] autorelease],
    [[[self alloc] initWithName:@"rect-translate"] autorelease],
    [[[self alloc] initWithName:@"rect-union"] autorelease],
    [[[self alloc] initWithName:@"resample"] autorelease],
    [[[self alloc] initWithName:@"save-file"] autorelease],
    [[[self alloc] initWithName:@"opacity"] autorelease],
    [[[self alloc] initWithName:@"single-color"] autorelease],
    [[[self alloc] initWithName:@"threshold"] autorelease],
    [[[self alloc] initWithName:@"translate"] autorelease],
    [[[self alloc] initWithName:@"unsharp-mask"] autorelease],
    nil] retain];
  allOperatorsByName = [[NSDictionary dictionaryWithObjects:allOperators forKeys:(NSArray*)[[allOperators collect] name]] retain];
}

+ (IFOperator*)operatorForName:(NSString*)name;
{
  IFOperator* op = [allOperatorsByName objectForKey:name];
  NSAssert1(op != nil, @"unknown operator name: %@",name);
  return op;
}

- (id)copyWithZone:(NSZone *)zone;
{
  return [self retain];
}

- (NSString*)description;
{
  return name;
}

- (NSString*)name;
{
  return name;
}

@end

@implementation IFOperator (Private)

- (id)initWithName:(NSString*)theName;
{
  if (![super init])
    return nil;
  name = [theName copy];
  return self;
}

- (void) dealloc {
  OBJC_RELEASE(name);
  [super dealloc];
}

@end

