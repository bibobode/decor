//
//  DecorMeasurement.h
//  DecorTest
//
//  Created by Fawaz Tahir on 1/9/15.
//  Copyright (c) 2015 Fawaz Tahir. All rights reserved.
//

#import "D.h"

typedef enum : NSUInteger {
    Pixel,
    Percent,
    Auto,
    Calculation
} DecorMeasurementType;

@interface DMeasurement : NSObject

@property (nonatomic) DecorMeasurementType type;
@property (nonatomic) CGFloat value;
@property (nonatomic) DMeasurement *min;
@property (nonatomic) DMeasurement *max;

+ (DMeasurement *)measurementWithType:(DecorMeasurementType)type value:(CGFloat)value;
+ (DMeasurement *)zeroMeasurement;
+ (DMeasurement *)autoMeasurement;

+ (DMeasurement *)toPixel:(DMeasurement *)measurement maxValue:(CGFloat)maxValue;

- (DMeasurement *)add:(DMeasurement *)measurement;
- (DMeasurement *)subtract:(DMeasurement *)measurement;

@end