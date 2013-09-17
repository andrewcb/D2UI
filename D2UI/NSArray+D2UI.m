//
//  NSArray+DataUtility.m
//  DynamicDataViewTest
//
//  Created by acb on 12/09/2013.
//  Copyright (c) 2013 Andrew C. Bulhak. All rights reserved.
//

#import "NSArray+D2UI.h"

static D2UIIntegerAccessor intIdentityAccessor = ^(id v) { return [v integerValue]; };
static D2UIDoubleAccessor doubleIdentityAccessor = ^(id v) { return [v doubleValue]; };

@implementation NSArray (D2UI)

- (double) doubleMean {
    return [self doubleMeanWithAccessor:doubleIdentityAccessor];
}

- (NSInteger) integerMean {
    return [self integerMeanWithAccessor:intIdentityAccessor];
}

- (double) doubleMeanWithAccessor:(D2UIDoubleAccessor)accessor {
    return [self doubleSumWithAccessor:accessor]/self.count;
}

- (NSInteger) integerMeanWithAccessor:(D2UIIntegerAccessor)accessor {
    return [self integerSumWithAccessor:accessor]/self.count;
}

- (struct D2UIIntegerExtent) integerExtent {
    return [self integerExtentWithAccessor:intIdentityAccessor];
}

- (struct D2UIIntegerExtent) integerExtentWithAccessor:(D2UIIntegerAccessor)accessor {
    struct D2UIIntegerExtent result;
    if(self.count >= 1) {
        NSInteger val = accessor(self[0]);
        result.min = result.max = val;
        
        for(id v in self) {
            val = accessor(v);
            if(val<result.min) result.min = val;
            if(val>result.max) result.max = val;
        }
    }
    return result;
}

- (struct D2UIDoubleExtent) doubleExtent {
    return [self doubleExtentWithAccessor:doubleIdentityAccessor];
}

- (struct D2UIDoubleExtent) doubleExtentWithAccessor:(D2UIDoubleAccessor)accessor {
    struct D2UIDoubleExtent result;
    if(self.count >= 1) {
        double val = accessor(self[0]);
        result.min = result.max = val;
        
        for(id v in self) {
            val = accessor(v);
            if(val<result.min) result.min = val;
            if(val>result.max) result.max = val;
        }
    }
    return result;
}

- (NSInteger) integerSum {
    return [self integerSumWithAccessor:intIdentityAccessor];
}

- (NSInteger) integerSumWithAccessor:(D2UIIntegerAccessor)accessor {
    NSInteger result = 0;
    for(id v in self) {
        result += accessor(v);
    }
    return result;
}

- (double) doubleSum {
    return [self doubleSumWithAccessor:doubleIdentityAccessor];
}

- (double) doubleSumWithAccessor:(D2UIDoubleAccessor)accessor {
    double result = 0.0;
    for(id v in self) {
        result += accessor(v);
    }
    return result;
}

@end
