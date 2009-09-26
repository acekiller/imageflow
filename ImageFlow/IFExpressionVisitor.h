//
//  IFExpressionVisitor.h
//  ImageFlow
//
//  Created by Michel Schinz on 30.10.05.
//  Copyright 2005 Michel Schinz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IFLambdaExpression.h"
#import "IFMapExpression.h"
#import "IFApplyExpression.h"
#import "IFPrimitiveExpression.h"
#import "IFVariableExpression.h"
#import "IFArgumentExpression.h"
#import "IFConstantExpression.h"

@interface IFExpressionVisitor : NSObject {

}

- (void)caseLambdaExpression:(IFLambdaExpression*)expression;
- (void)caseMapExpression:(IFMapExpression*)expression;
- (void)caseApplyExpression:(IFApplyExpression*)expression;
- (void)casePrimitiveExpression:(IFPrimitiveExpression*)expression;
- (void)caseVariableExpression:(IFVariableExpression*)expression;
- (void)caseArgumentExpression:(IFArgumentExpression*)expression;
- (void)caseConstantExpression:(IFConstantExpression*)expression;

@end
