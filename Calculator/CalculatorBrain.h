//
//  CalculatorBrain.h
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString *)varName;
- (void)pushOperation:(NSString *)op;
- (void)clear;
- (NSString *)getDescription;
- (double)evaluate;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVaribaleValues:(NSDictionary *) variableValues;
+ (NSSet *)variablesUsedInPorgram:(id)program;

@end
