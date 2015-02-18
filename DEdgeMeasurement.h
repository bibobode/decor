//
//  DecorEdgeMeasurement.h
//  DecorTest
//
//  Created by Fawaz Tahir on 1/9/15.
//  Copyright (c) 2015 Fawaz Tahir. All rights reserved.
//

#import "D.h"

@class DMeasurement;

extern const NSUInteger topValue;
extern const NSUInteger leftValue;
extern const NSUInteger bottomValue;
extern const NSUInteger rightValue;

@interface DEdgeMeasurement : NSObject

@property (nonatomic, strong) DMeasurement *top;
@property (nonatomic, strong) DMeasurement *left;
@property (nonatomic, strong) DMeasurement *bottom;
@property (nonatomic, strong) DMeasurement *right;

- (void)setAll:(DMeasurement *)measurement;

+ (DEdgeMeasurement *)zeroEdgeMeasurement;

+ (NSArray *)toPixel:(DEdgeMeasurement *)edgeMeasurement maxSize:(CGSize)size;

@end