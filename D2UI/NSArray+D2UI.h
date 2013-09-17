//
//  NSArray+DataUtility.h
//  DynamicDataViewTest
//
//  Created by acb on 12/09/2013.
//  Copyright (c) 2013 Andrew C. Bulhak. All rights reserved.
//

#import <Foundation/Foundation.h>

struct D2UIIntegerExtent {
    NSInteger min;
    NSInteger max;
};

struct D2UIDoubleExtent {
    double min;
    double max;
};

typedef NSInteger (^D2UIIntegerAccessor)(id item);
typedef double (^D2UIDoubleAccessor)(id item);

@interface NSArray (D2UI)

- (double) doubleMean;
- (NSInteger) integerMean;
- (double) doubleMeanWithAccessor:(D2UIDoubleAccessor)accessor;
- (NSInteger) integerMeanWithAccessor:(D2UIIntegerAccessor)accessor;

- (struct D2UIIntegerExtent) integerExtent;
- (struct D2UIIntegerExtent) integerExtentWithAccessor:(D2UIIntegerAccessor)accessor;
- (struct D2UIDoubleExtent) doubleExtent;
- (struct D2UIDoubleExtent) doubleExtentWithAccessor:(D2UIDoubleAccessor)accessor;

- (NSInteger) integerSum;
- (NSInteger) integerSumWithAccessor:(D2UIIntegerAccessor)accessor;
- (double) doubleSum;
- (double) doubleSumWithAccessor:(D2UIDoubleAccessor)accessor;

@end
