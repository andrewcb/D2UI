//
//  PieSegmentLayer.m
//  DynamicDataViewTest
//
//  Created by acb on 14/09/2013.
//  Copyright (c) 2013 Andrew C. Bulhak. All rights reserved.
//

#import "PieSegmentLayer.h"

/* Private variables. */
@interface PieSegmentLayer () {
    CGColorRef _fillColor;
}

@end

@implementation PieSegmentLayer

@dynamic startAngle;
@dynamic endAngle;

/* As ARC cannot handle CGColorRef, we need to manually retain/release it, as in the old days. */
- (CGColorRef)fillColor { return _fillColor; }
- (void)setFillColor:(CGColorRef)fillColor {
    CGColorRelease(_fillColor);
    _fillColor = CGColorRetain(fillColor);
}

/* If either start or end angle is changed, redraw the pie slice. */
+ (BOOL)needsDisplayForKey:(NSString *)key {
    return [key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"] || [super needsDisplayForKey:key];
}

/* 
 The animation inbetweening process makes copies of this layer with initWithLayer:; for this to work properly, we need to override the constructor to copy over any other salient attributes; in our case, the fill colour.
 */
- (id) initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if(self) {
        if([layer isKindOfClass:[PieSegmentLayer class]]) {
            self.fillColor = [layer fillColor];
        }
    }
    return self;
}

/* Animate changes to start and end angles. CoreAnimation will compute inbetween values, and will create a duplicate PieSegmentLayer which will draw itself with the inbetween values. */
- (id)actionForKey:(NSString *) aKey {
    if ([aKey isEqualToString:@"startAngle"] || [aKey isEqualToString:@"endAngle"]) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:aKey];
        animation.fromValue = [self.presentationLayer valueForKey:aKey];
        return animation;
    }
    return [super actionForKey:aKey];
}

/* Draw the pie segment. */
- (void)drawInContext:(CGContextRef)context {
    CGPoint center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    CGFloat radius = MIN(center.x, center.y);
    CGContextSetFillColorWithColor(context, _fillColor);
    
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, radius, self.startAngle, self.endAngle, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    [super drawInContext:context];
}
@end

