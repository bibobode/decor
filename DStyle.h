//
//  DecorStyle.h
//  Decor
//
//  Created by Fawaz Tahir on 1/7/15.
//  Copyright (c) 2015 Fawaz Tahir. All rights reserved.
//

#import "D.h"

@class DMeasurement;
@class DEdgeMeasurement;

NSString * const kGlobalDecorStylesKey;

typedef enum : NSUInteger {
    PositionTypeRelative,
    PositionTypeAbsolute
} PositionType;

typedef enum : NSUInteger {
    CenterTypeNone,
    CenterTypeHorizontal,
    CenterTypeVertical
} CenterType;

@interface DStyle : NSObject

@property (nonatomic, strong) DMeasurement *width;
@property (nonatomic, strong) DMeasurement *height;
@property (nonatomic, strong) DEdgeMeasurement *padding;
@property (nonatomic, strong) DEdgeMeasurement *margin;

@property (nonatomic, strong) DMeasurement *top;
@property (nonatomic, strong) DMeasurement *left;
@property (nonatomic, strong) DMeasurement *bottom;
@property (nonatomic, strong) DMeasurement *right;

@property (nonatomic) PositionType position;
@property (nonatomic) CenterType center;
@property (nonatomic) NSUInteger lineBreak;

- (void)reset;

+ (NSMutableDictionary *)allStyles;
+ (void)setStyle:(DStyle *)style forClass:(NSString *)class;

@end