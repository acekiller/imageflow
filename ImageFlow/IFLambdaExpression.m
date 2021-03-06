//
//  IFLambdaExpression.m
//  ImageFlow
//
//  Created by Michel Schinz on 05.09.09.
//  Copyright 2009 Michel Schinz. All rights reserved.
//

#import "IFLambdaExpression.h"

#import "IFExpressionTags.h"

#import <caml/memory.h>
#import <caml/alloc.h>

@implementation IFLambdaExpression

- (IFLambdaExpression*)initWithBody:(IFExpression*)theBody;
{
  if (![super init])
    return nil;
  body = [theBody retain];
  hash = body.hash * 11;
  return self;
}

- (void)dealloc;
{
  OBJC_RELEASE(body);
  [super dealloc];
}

@synthesize body;

- (int)tag;
{
  return IFExpressionTag_Lambda;
}

- (BOOL)isEqual:(id)other;
{
  return [other isKindOfClass:[IFLambdaExpression class]] && [self.body isEqual:((IFLambdaExpression*)other).body];
}

@synthesize hash;

- (NSString*)description;
{
  return [NSString stringWithFormat:@"\\.%@", body];
}

// MARK: XML input/output

- (id)initWithXML:(NSXMLElement*)xmlTree;
{
  return [self initWithBody:[IFExpression expressionWithXML:(NSXMLElement*)[xmlTree childAtIndex:0]]];
}

- (NSXMLElement*)asXML;
{
  NSXMLElement* root = [NSXMLElement elementWithName:@"lambda"];
  [root addChild:[body asXML]];
  return root;
}

// MARK: NSCoding protocol

- (id)initWithCoder:(NSCoder*)decoder;
{
  return [self initWithBody:[decoder decodeObjectForKey:@"body"]];
}

- (void)encodeWithCoder:(NSCoder*)encoder;
{
  [encoder encodeObject:body forKey:@"body"];
}

// MARK: Caml representation

- (value)camlRepresentation;
{
  CAMLparam0();
  CAMLlocal1(block);
  block = caml_alloc(1, IFExpressionTag_Lambda);
  Store_field(block, 0, [body asCaml]);
  CAMLreturn(block);
}

@end
