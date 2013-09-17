//
//  PieSegmentLayer.h
//  DynamicDataViewTest
//
//  Created by acb on 14/09/2013.
//  Copyright (c) 2013 Andrew C. Bulhak. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

/**
 A PieSegmentLayer is a layer which renders a pie segment, from a start angle to an end angle, within the largest square to fit (centred) in its rectangle.
*/

@interface PieSegmentLayer : CALayer

/** The start angle of the pie segment, in radians. */
@property (nonatomic) CGFloat startAngle;
/** The end angle of the pie segment, in radians. */
@property (nonatomic) CGFloat endAngle;
/** The colour to fill the pie slice with. */
@property (nonatomic) CGColorRef fillColor;

@end
