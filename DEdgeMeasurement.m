//
//  DecorEdgeMeasurement.m
//  DecorTest
//
//  Created by Fawaz Tahir on 1/9/15.
//  Copyright (c) 2015 Fawaz Tahir. All rights reserved.
//

#import "DEdgeMeasurement.h"
#import "DMeasurement.h"

const NSUInteger topValue = 0;
const NSUInteger leftValue = 1;
const NSUInteger bottomValue = 2;
const NSUInteger rightValue = 3;

@implementation DEdgeMeasurement

- (instancetype)init
{
    if (self = [super init])
    {
        _top = pixel(0);
        _left = pixel(0);
        _bottom = pixel(0);
        _right = pixel(0);
    }
    return self;
}

- (void)setAll:(DMeasurement *)measurement
{
    self.top =
    self.left =
    self.right =
    self.bottom = measurement;
}

+ (DEdgeMeasurement *)zeroEdgeMeasurement
{
    return [[DEdgeMeasurement alloc] init];
}

+ (NSArray *)toPixel:(DEdgeMeasurement *)edgeMeasurement maxSize:(CGSize)size
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4U];
    
    array[topValue] = [DMeasurement toPixel:edgeMeasurement.top maxValue:size.height];
    array[leftValue] = [DMeasurement toPixel:edgeMeasurement.left maxValue:size.width];
    array[bottomValue] = [DMeasurement toPixel:edgeMeasurement.bottom maxValue:size.height];
    array[rightValue] = [DMeasurement toPixel:edgeMeasurement.right maxValue:size.width];
    
    return array;
}

@end