//
//  Decor.h
//  Decor
//
//  Created by Fawaz Tahir on 1/7/15.
//  Copyright (c) 2015 Fawaz Tahir. All rights reserved.
//

#import <UIKit/UIKit.h>

#define zero [DMeasurement zeroMeasurement]
#define pixel(x) [DMeasurement measurementWithType:Pixel value:x]
#define percent(x) [DMeasurement measurementWithType:Percent value:x]
#define autosize [DMeasurement autoMeasurement]
#define absolute PositionTypeAbsolute
#define relative PositionTypeRelative
#define none CenterTypeNone
#define horizontal CenterTypeHorizontal
#define vertical CenterTypeVertical

@class DStyle;

typedef enum : NSUInteger {
    LayoutTypeDefault,
    LayoutTypeDecor
} LayoutType;

@interface UIView (Decor)

@property (nonatomic, copy) NSString *_class;
@property (nonatomic, strong) DStyle *style;
@property (nonatomic) LayoutType layoutType;

@end

#import "DStyle.h"
#import "DMeasurement.h"
#import "DEdgeMeasurement.h"