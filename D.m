//
//  Decor.m
//  Decor
//
//  Created by Fawaz Tahir on 1/7/15.
//  Copyright (c) 2015 Fawaz Tahir. All rights reserved.
//

#import "DStyle.h"
#import "DMeasurement.h"
#import "DEdgeMeasurement.h"
#import <objc/runtime.h>

static void *kLayoutTypePropertyKey = &kLayoutTypePropertyKey;
static void *kStylePropertyKey = &kStylePropertyKey;
static void *kLineBreakPointsKey = &kLineBreakPointsKey;
static void *kIgnoreFrameChangeKey = &kIgnoreFrameChangeKey;
static void *kClassKey = &kClassKey;

extern NSString * const kGlobalDecorStylesKey;

@interface UIView (Private)
@property (nonatomic, strong) NSMutableArray *lineBreakPoints;
@property (nonatomic) BOOL ignoreFrameChange;
@end

@implementation UIView (Decor)

+ (void)load
{
    Class class = [self class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(layoutSubviews);
    SEL swizzledSelector = @selector(frameDidChange);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod)
    {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (CGRect)effectiveFrameInRect:(CGRect)rect
{
    CGRect frame = rect;
    NSArray *pixelMeasurements = [DEdgeMeasurement toPixel:self.style.margin maxSize:rect.size];
    DMeasurement *top = pixelMeasurements[topValue];
    DMeasurement *left = pixelMeasurements[leftValue];
    DMeasurement *bottom = pixelMeasurements[bottomValue];
    DMeasurement *right = pixelMeasurements[rightValue];
    frame = CGRectOffset(frame, left.value, top.value);
    frame.size.width -= left.value + right.value;
    frame.size.height -= top.value + bottom.value;
    return frame;
}

- (CGRect)drawFrame
{
    CGRect frame = self.frame;
    NSArray *pixelMeasurements = [DEdgeMeasurement toPixel:self.style.padding maxSize:frame.size];
    DMeasurement *top = pixelMeasurements[topValue];
    DMeasurement *left = pixelMeasurements[leftValue];
    DMeasurement *bottom = pixelMeasurements[bottomValue];
    DMeasurement *right = pixelMeasurements[rightValue];
    frame.origin = CGPointMake(left.value, top.value);
    frame.size.width -= left.value + right.value;
    frame.size.height -= top.value + bottom.value;
    return frame;
}

- (void)frameDidChange
{
    [self frameDidChange];
    
    UIView *view = self;
    while (view.layoutType != LayoutTypeDecor)
    {
        view = view.superview;
        if (!view)
        {
            return;
        }
    }
    
    if (!self.style)
    {
        return;
    }
    
    if (self.ignoreFrameChange)
    {
        self.ignoreFrameChange = NO;
        return;
    }
    
    [self layoutSubviewsInDrawFrame];
}

- (void)resetLineBreakPoints
{
    if (!self.lineBreakPoints)
    {
        self.lineBreakPoints = [NSMutableArray array];
    }
    [self.lineBreakPoints setArray:@[[NSValue valueWithCGPoint:[self drawFrame].origin]]];
}

- (void)layoutSubviewsInDrawFrame
{
    if (self.hidden)
    {
        return;
    }
    
    CGRect rect = [self drawFrame];
    
    if (self.style.width.type == Auto || self.style.height.type == Auto)
    {
        CGRect frame = self.frame;
        NSArray *padding = [DEdgeMeasurement toPixel:self.style.padding maxSize:self.superview.frame.size];
        CGFloat rightPadding = ((DMeasurement *)padding[rightValue]).value;
        CGFloat bottomPadding = ((DMeasurement *)padding[bottomValue]).value;
        
        if ([self isKindOfClass:[UITextView class]] || [self isKindOfClass:[UILabel class]])
        {
            NSString *text = [((id)self) text];
            UIFont *font = [((id)self) font];
            CGSize boundingSize = CGSizeMake((self.style.width.type == Auto) ? CGFLOAT_MAX : frame.size.width,
                                             (self.style.height.type == Auto) ? CGFLOAT_MAX : frame.size.height);
            CGRect textFrame = [text boundingRectWithSize:boundingSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName:font}
                                                  context:nil];
            CGFloat additionalPadding = [self isKindOfClass:[UITextView class]] ? 10.0f : 0.0f;
            
            if (self.style.width.type == Auto)
            {
                frame.size.width = textFrame.size.width + additionalPadding + rightPadding;
            }
            if (self.style.height.type == Auto)
            {
                frame.size.height = textFrame.size.height + additionalPadding + bottomPadding;
            }
        }
        else
        {
            [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
                [subview layoutSubviewsInDrawFrame];
            }];
            
            if (self.style.width.type == Auto)
            {
                frame.size.width = [self sizeOfSubviews].width + rightPadding;
            }
            if (self.style.height.type == Auto)
            {
                frame.size.height = [self sizeOfSubviews].height + bottomPadding;
            }
        }
        
        self.ignoreFrameChange = YES;
        self.frame = frame;
        rect = [self drawFrame];
    }
    
    [self resetLineBreakPoints];
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if (![subview isKindOfClass:[UIView class]])
        {
            return;
        }
        
        if (subview.hidden)
        {
            return;
        }
        
        if (![subview.style isKindOfClass:[DStyle class]])
        {
            return;
        }
        
        CGPoint origin = subview.frame.origin;
        CGSize size = subview.frame.size;
        CGRect viewDrawFrame = rect;
        
        if (subview.style.position == relative)
        {
            for (NSUInteger i = 0; i < subview.style.lineBreak; i++)
            {
                [self.lineBreakPoints removeLastObject];
            }
            
            while (true)
            {
                CGPoint point = [[self.lineBreakPoints lastObject] CGPointValue];
                [self.lineBreakPoints removeLastObject];
                
                CGPoint p1 = point;
                CGPoint p2;
                p2.x = CGRectGetMaxX(rect);
                p2.y = CGRectGetMaxY(rect);
                
                // Create rect from p1 and p2
                viewDrawFrame = CGRectMake(MIN(p1.x, p2.x),
                                           MIN(p1.y, p2.y),
                                           fabs(p1.x - p2.x),
                                           fabs(p1.y - p2.y));
                
                origin = [subview effectiveFrameInRect:viewDrawFrame].origin;
                
                if (subview.style.width.type != Auto)
                {
                    size.width = [DMeasurement toPixel:subview.style.width
                                              maxValue:[subview effectiveFrameInRect:viewDrawFrame].size.width].value;
                }
                if (subview.style.height.type != Auto)
                {
                    size.height = [DMeasurement toPixel:subview.style.height
                                               maxValue:[subview effectiveFrameInRect:viewDrawFrame].size.height].value;
                }
                
                CGRect testRect;
                testRect.origin = origin;
                testRect.size = size;
                BOOL contained = CGRectContainsRect(viewDrawFrame, testRect);
                
                if (contained || [self.lineBreakPoints count] == 0)
                {
                    break;
                }
            }
            
            CGPoint bottomLeft;
            bottomLeft.x = viewDrawFrame.origin.x;
            bottomLeft.y = CGRectGetMaxY(subview.frame);
            
            CGPoint topRight;
            topRight.x = CGRectGetMaxX(subview.frame);
            topRight.y = viewDrawFrame.origin.y;
            
            [self.lineBreakPoints addObject:[NSValue valueWithCGPoint:bottomLeft]];
            [self.lineBreakPoints addObject:[NSValue valueWithCGPoint:topRight]];
        }
        else if (subview.style.position == absolute)
        {
            viewDrawFrame = [subview effectiveFrameInRect:rect];
            
            // Size
            if (subview.style.width.type != Auto)
            {
                size.width = [DMeasurement toPixel:subview.style.width
                                          maxValue:viewDrawFrame.size.width].value;
            }
            if (subview.style.height.type != Auto)
            {
                size.height = [DMeasurement toPixel:subview.style.height
                                           maxValue:viewDrawFrame.size.height].value;
            }
            
            // Origin
            if (subview.style.left)
            {
                origin.x = [DMeasurement toPixel:subview.style.left maxValue:viewDrawFrame.size.width].value;
            }
            else if (subview.style.right)
            {
                origin.x = CGRectGetMaxX(viewDrawFrame) -
                [DMeasurement toPixel:subview.style.right maxValue:viewDrawFrame.size.width].value -
                size.width;
            }
            
            if (subview.style.top)
            {
                origin.y = [DMeasurement toPixel:subview.style.top maxValue:viewDrawFrame.size.height].value;
            }
            else if (subview.style.bottom)
            {
                origin.y = CGRectGetMaxY(viewDrawFrame) -
                [DMeasurement toPixel:subview.style.bottom maxValue:viewDrawFrame.size.height].value -
                size.height;
            }
        }
        
        CGRect frame;
        frame.origin = origin;
        frame.size = size;
        subview.frame = frame;
        
        // Center view horizontally, preserving margins for relatively positioned view
        if (subview.style.center == horizontal)
        {
            if (subview.style.position == absolute)
            {
                subview.center = CGPointMake(CGRectGetMidX(viewDrawFrame), subview.center.y);
                return;
            }
            subview.center = CGPointMake(CGRectGetMidX(viewDrawFrame) + origin.x, subview.center.y);
        }
        
        // Center view vertically, preserving margins for relatively positioned view
        if (subview.style.center == vertical)
        {
            if (subview.style.position == absolute)
            {
                subview.center = CGPointMake(subview.center.x, CGRectGetMidY(viewDrawFrame));
                return;
            }
            subview.center = CGPointMake(subview.center.x, CGRectGetMidY(viewDrawFrame) + origin.y);
        }
    }];
}

#pragma mark Properties

- (NSString *)_class
{
    return objc_getAssociatedObject(self, kClassKey);
}

- (void)set_class:(NSString *)_class
{
    objc_setAssociatedObject(self, kClassKey, _class, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!_class)
    {
        [self.style reset];
        return;
    }
    
    NSMutableDictionary *globalDecorStyles = [DStyle allStyles];
    if (globalDecorStyles && [[globalDecorStyles allKeys] containsObject:_class])
    {
        self.style = globalDecorStyles[_class];
        return;
    }
    
    NSLog(@"Decor: No style defined for class: %@", _class);
}

- (NSMutableArray *)lineBreakPoints
{
    return objc_getAssociatedObject(self, kLineBreakPointsKey);
}

- (void)setLineBreakPoints:(NSMutableArray *)lineBreakPoints
{
    objc_setAssociatedObject(self, kLineBreakPointsKey, lineBreakPoints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DStyle *)style
{
    DStyle *style = objc_getAssociatedObject(self, kStylePropertyKey);
    if (!style)
    {
        style = [[DStyle alloc] init];
        self.style = style;
    }
    return style;
}

- (void)setStyle:(DStyle *)style
{
    objc_setAssociatedObject(self, kStylePropertyKey, style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLayoutType:(LayoutType)layoutType
{
    if (layoutType == LayoutTypeDecor)
    {
        self.clipsToBounds = YES;
        self.autoresizesSubviews = NO;
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    objc_setAssociatedObject(self, kLayoutTypePropertyKey, @(layoutType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LayoutType)layoutType
{
    return [objc_getAssociatedObject(self, kLayoutTypePropertyKey) integerValue];
}

- (void)setIgnoreFrameChange:(BOOL)ignoreFrameChange
{
    objc_setAssociatedObject(self, kIgnoreFrameChangeKey, @(ignoreFrameChange), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreFrameChange
{
    return [objc_getAssociatedObject(self, kIgnoreFrameChangeKey) boolValue];
}

#pragma mark Private Helpers

- (CGSize)sizeOfSubviews
{
    if ([self.subviews count] == 0)
    {
        return CGSizeZero;
    }
    
    __block CGFloat maxWidth = 0.0f;
    __block CGFloat maxHeight = 0.0f;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if (![subview isKindOfClass:[UIView class]])
        {
            return;
        }
        if (subview.hidden)
        {
            return;
        }
        
        if (![subview.style isKindOfClass:[DStyle class]])
        {
            return;
        }
        
        if (subview.style.position != relative)
        {
            return;
        }
        
        CGFloat width = subview.frame.origin.x + subview.frame.size.width;
        if (width > maxWidth)
        {
            maxWidth = width;
        }
        CGFloat height = subview.frame.origin.y + subview.frame.size.height;
        if (height > maxHeight)
        {
            maxHeight = height;
        }
    }];
    
    CGSize size = CGSizeMake(maxWidth, maxHeight);
    return size;
}

@end