//
//  IFTypeVar.h
//  ImageFlow
//
//  Created by Michel Schinz on 04.01.07.
//  Copyright 2007 Michel Schinz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IFType.h"

@interface IFTypeVar : IFType {
  int index;
}

+ (IFTypeVar*)typeVariable;

@end
