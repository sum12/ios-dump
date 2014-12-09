//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Sumit Jamgade on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfTypingANumber;
@property (nonatomic , strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize userIsInTheMiddleOfTypingANumber =_userIsInTheMiddleOfTypingANumber;
@synthesize brain = _brain;
@synthesize history = _history;

-(CalculatorBrain *) brain
{
    if(!_brain)
        _brain = [[CalculatorBrain alloc] init];
    return _brain;
}


- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    
    if(self.userIsInTheMiddleOfTypingANumber)
    {
        if ([digit isEqualToString:@"."] && [digit rangeOfString:@"."].location == NSNotFound) {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
        else
            self.display.text = [self.display.text stringByAppendingString:digit];
        NSLog(@"button pressed ");
    }
    else
    {
        if ([digit isEqualToString:@"."] && [digit rangeOfString:@"."].location == NSNotFound) {
            self.display.text = @"0.";
        }
        else{
            self.display.text = digit;
            NSLog(@"button pressed ");
        }
        self.userIsInTheMiddleOfTypingANumber =YES;
    }
}


- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfTypingANumber =NO;
    //self.display.text = @"";
}

- (IBAction)operationPressed:(UIButton *)sender {
    NSString * rsultString;
    if ([sender.currentTitle isEqualToString:@"C"])
    {
        [self.brain clear];
        self.history.text = [self.brain getDescription];
        rsultString = @"";
    }
    else{
        if (self.userIsInTheMiddleOfTypingANumber) [self enterPressed];
        if ([sender.currentTitle isEqualToString:@"pie"]) {
            [self.brain pushOperand:(22.0/7.0)];
            rsultString = [NSString stringWithFormat:@"%g",(22.0/7.0)];
        }
        else {
            [self.brain pushOperation:[sender.currentTitle copy]];
            self.history.text = [self.brain getDescription];
            rsultString = sender.currentTitle;
        }
    }
    self.display.text = rsultString;
}
- (IBAction)variablePressed:(UIButton *)sender {
    if(!self.userIsInTheMiddleOfTypingANumber)
    {
        [self.brain pushVariable:[sender currentTitle]];
    }
}

- (IBAction)evaluate {
    self.history.text = [self.brain getDescription];
    NSSet * variableSet = [CalculatorBrain variablesUsedInPorgram:self.brain.program];
    NSMutableDictionary * vardict;
    if ([variableSet count]) {
        for (NSString * var in variableSet) {
            if ([var isEqualToString:@"x"]) {
                if(! vardict) vardict = [[NSMutableDictionary alloc] init];
                [vardict setObject:[NSNumber numberWithInt:10] forKey:var];
            }
            else if ([var isEqualToString:@"y"]) {
                if(! vardict) vardict = [[NSMutableDictionary alloc] init];
                [vardict setObject:[NSNumber numberWithInt:20] forKey:var];
            }
            else if ([var isEqualToString:@"z"]) {
                if(! vardict) vardict = [[NSMutableDictionary alloc] init];
                [vardict setObject:[NSNumber numberWithInt:30] forKey:var];
            }
        }
        NSLog(@"reached here");
        self.display.text = [NSString stringWithFormat:@"%g",[CalculatorBrain runProgram:self.brain.program usingVaribaleValues:vardict]];
    }
    else
        self.display.text = [NSString stringWithFormat:@"%g",[CalculatorBrain runProgram:self.brain.program]];
}

- (void)viewDidUnload {
    [self setDisplay:nil];
    [super viewDidUnload];
}
@end
