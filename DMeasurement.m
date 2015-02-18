//
//  DecorMeasurement.m
//  DecorTest
//
//  Created by Fawaz Tahir on 1/9/15.
//  Copyright (c) 2015 Fawaz Tahir. All rights reserved.
//

#import "DMeasurement.h"
#import "DEdgeMeasurement.h"

@interface DMeasurement ()

@property (nonatomic, strong) NSMutableArray *componentMeasurements;

@end

@implementation DMeasurement

- (instancetype)init
{
    if (self = [super init])
    {
        _type = Pixel;
        _value = 0.0f;
        _componentMeasurements = [@[] mutableCopy];
    }
    return self;
}

+ (DMeasurement *)measurementWithType:(DecorMeasurementType)type value:(CGFloat)value
{
    DMeasurement *measurement = [[DMeasurement alloc] init];
    measurement.type = type;
    measurement.value = value;
    return measurement;
}

+ (DMeasurement *)zeroMeasurement
{
    return [[DMeasurement alloc] init];
}

+ (DMeasurement *)autoMeasurement
{
    DMeasurement *measurement = [[DMeasurement alloc] init];
    measurement.type = Auto;
    return measurement;
}

+ (DMeasurement *)toPixel:(DMeasurement *)measurement maxValue:(CGFloat)maxValue
{
    if (measurement.type == Percent)
    {
        maxValue = maxValue * (measurement.value / 100.0f);
        DMeasurement *result = [DMeasurement measurementWithType:Pixel value:maxValue];
        measurement = result;
    }
    else if (measurement.type == Calculation)
    {
        DMeasurement *result = [[DMeasurement alloc] init];
        result.type = Pixel;
        for (DMeasurement *m in measurement.componentMeasurements)
        {
            result.value += [DMeasurement toPixel:m maxValue:maxValue].value;
        }
        measurement = result;
    }
    
    if (measurement.min)
    {
        measurement.value = fmaxf(measurement.value,
                                  [[self class] toPixel:measurement.min maxValue:maxValue].value);
    }
    if (measurement.max)
    {
        measurement.value = fminf(measurement.value,
                                  [[self class] toPixel:measurement.max maxValue:maxValue].value);
    }
    return measurement;
}

- (DMeasurement *)add:(DMeasurement *)measurement
{
    DMeasurement *result = [[DMeasurement alloc] init];
    result.type = Calculation;
    [result.componentMeasurements addObject:self];
    [result.componentMeasurements addObject:measurement];
    return result;
}

- (DMeasurement *)subtract:(DMeasurement *)measurement
{
    return [self add:[DMeasurement measurementWithType:measurement.type value:-measurement.value]];
}

@end