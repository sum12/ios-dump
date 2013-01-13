//
//  CalculatorBrain.m
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;





- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

- (NSString *)getDescription
{
    return [[self class] descriptionOfProgram:[self program]];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSString * result;
    NSMutableArray * stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy]; 
    }
    
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [NSString stringWithFormat:@"%g",[topOfStack doubleValue]];
    }
    
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSArray * binOpeatrorArray = [NSArray arrayWithObjects:@"+",@"-",@"*",@"/",nil];
        NSArray * unaryOperatorArray = [NSArray arrayWithObjects:@"sin",@"cos",@"sqrt",nil];
        NSString *operation = topOfStack;
        if ([binOpeatrorArray containsObject:operation]) {
            NSString* op1  = [self descriptionOfProgram:stack];
            [stack removeLastObject];
            NSString* op2 =  [self descriptionOfProgram:stack];
            [stack removeLastObject];
            result = [op1 stringByAppendingString:operation];
            result = [result stringByAppendingString:op2];
            result = [@"( " stringByAppendingString:[result stringByAppendingString:@" )"]];
        }else if ([unaryOperatorArray containsObject:operation]){
            result = [operation stringByAppendingString:[self descriptionOfProgram:stack]];
            result = [@"( " stringByAppendingString:[result stringByAppendingString:@" )"]];
        }
        
        else if ([operation isEqualToString:@"x"] || [operation isEqualToString:@"y"] || [operation isEqualToString:@"z"]) {
            result = operation;
        }
        
    }
    NSLog(@"pooping:%g",result);
    return result;
}


- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void) pushVariable:(NSString *)varName
{
    [self.programStack addObject:[varName copy]];
}

- (void)pushOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
}

- (double)evaluate
{
    return [[self class] runProgram:self.program];
}

- (void) clear
{
    [self.programStack removeAllObjects];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        }else if ([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffProgramStack:stack]);
        }else if ([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffProgramStack:stack]);
        }else if ([operation isEqualToString:@"sqrt"]){
            double operand = [self popOperandOffProgramStack:stack];
            if (operand > 0) {
                result = sqrt(operand);
            }
            else{
                result = 0;
            }
        }
    }
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}			

+ (double)runProgram:(id)program usingVaribaleValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    int count = [program count];
    stack= [program mutableCopy];
    for (;count!=-1;count--) {
        id element = [stack objectAtIndex:count];
        if([element isKindOfClass:[NSString class]]){
            NSString * value = element;
            if ([value isEqualToString:@"x"]) {
                id dictElement = [variableValues objectForKey:@"x"];
                if (!dictElement) {
                    [stack replaceObjectAtIndex:count withObject:@"0"];
                }
                else{
                    [stack replaceObjectAtIndex:count withObject:dictElement];
                }
            }
        }
    }
    return [self popOperandOffProgramStack:stack];
}

+(NSSet *) variablesUsedInPorgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    else
        return nil;
    NSMutableSet * variableSet = nil;
    int count = [stack count];
    for (; count!=-1; count--) {
        id element = [stack objectAtIndex:count];
        if ([element isKindOfClass:[NSString class]]) {
            NSString * value = element;
            if ([value isEqualToString:@"x"] || [value isEqualToString:@"y"] || [value isEqualToString:@"z"]) {
                if (!variableSet) {
                    variableSet = [[NSMutableSet alloc] init];
                }
                [variableSet addObject:element];
            }
        }
    }
    NSLog(@"variable count is %d",[variableSet count]);
    return [[NSSet alloc] initWithSet:variableSet];
}


@end
