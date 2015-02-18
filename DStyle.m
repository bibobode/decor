//
//  DecorStyle.m
//  Decor
//
//  Created by Fawaz Tahir on 1/7/15.
//  Copyright (c) 2015 Fawaz Tahir. All rights reserved.
//

#import "DStyle.h"
#import "DMeasurement.h"
#import "DEdgeMeasurement.h"
#import "PrivateD.h"

NSString * const kGlobalDecorStylesKey = @"kGlobalDecorStylesKey";

@implementation DStyle

- (instancetype)init
{
    if (self = [super init])
    {
        [self reset];
    }
    return self;
}

- (void)reset
{
    _padding = [DEdgeMeasurement zeroEdgeMeasurement];
    _margin = [DEdgeMeasurement zeroEdgeMeasurement];
    _width = percent(100);
    _height = percent(100);
    _top = _left = _right = _bottom = nil;
    _position = relative;
    _center = none;
    _lineBreak = 0U;
}

- (void)setLeft:(DMeasurement *)left
{
    _left = left;
    _right = nil;
}

- (void)setRight:(DMeasurement *)right
{
    _right = right;
    _left = nil;
}

- (void)setTop:(DMeasurement *)top
{
    _top = top;
    _bottom = nil;
}

- (void)setBottom:(DMeasurement *)bottom
{
    _bottom = bottom;
    _top = nil;
}

- (void)setHeight:(DMeasurement *)height
{
    if (!height)
    {
        height = percent(100);
    }
    _height = height;
}

- (void)setWidth:(DMeasurement *)width
{
    if (!width)
    {
        width = percent(100);
    }
    _width = width;
}

- (void)setPadding:(DEdgeMeasurement *)padding
{
    if (!padding)
    {
        padding = [DEdgeMeasurement zeroEdgeMeasurement];
    }
    _padding = padding;
}

- (void)setMargin:(DEdgeMeasurement *)margin
{
    if (!margin)
    {
        margin = [DEdgeMeasurement zeroEdgeMeasurement];
    }
    _margin = margin;
}

+ (NSMutableDictionary *)allStyles
{
    static NSMutableDictionary *theValue = nil;
    @synchronized([self class]) // in a single threaded app you can omit the sync block
    {
        if (!theValue)
        {
            theValue = [NSMutableDictionary dictionary];
        }
    }
    return theValue;
}

+ (void)setStyle:(DStyle *)style forClass:(NSString *)class
{
    NSMutableDictionary *globalDecorStyles = [[self class] allStyles];
    if (!style)
    {
        [globalDecorStyles removeObjectForKey:class];
    }
    else
    {
        globalDecorStyles[class] = style;
    }
}

@end