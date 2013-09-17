//
//  NSArrayDataUtilityTests.m
//  DynamicDataViewTest
//
//  Created by acb on 15/09/2013.
//  Copyright (c) 2013 Andrew C. Bulhak. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSArray+D2UI.h"

@interface NSArrayDataUtilityTests : XCTestCase

@end

@implementation NSArrayDataUtilityTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testIntegerExtent
{
    NSArray* input = @[ @2, @-1, @65, @9, @0, @-99, @43 ];
    struct D2UIIntegerExtent r = [input integerExtent];
    XCTAssertEqual(r.min, -99, @"Extent minimum is %d, not -99", r.min);
    XCTAssertEqual(r.max, 65, @"Extent minimum is %d, not 65", r.max);
}


- (void)testDoubleExtent
{
    NSArray* input = @[ @-0.99, @-1.1, @2.1, @0.01, @234.56 ];
    struct D2UIDoubleExtent r = [input doubleExtent];
    XCTAssertEqualWithAccuracy(r.min, -1.1,  0.001, @"Extent minimum is %f, not -1.1", r.min);
    XCTAssertEqualWithAccuracy(r.max, 234.56, 0.001, @"Extent minimum is %f, not 234.56", r.max);
}

- (void)testIntegerSum
{
    NSArray* input = @[ @44, @-3, @65, @9, @0, @-99, @43 ];
    NSInteger sum = [input integerSum];
    XCTAssertEqual(sum, 59, @"Sum is %d, not 59", sum);
}

- (void)testDoubleSum
{
    NSArray *input = @[ @1.23, @-0.5, @20.21, @0.004, @6.708];
    double sum = [input doubleSum];
    XCTAssertEqualWithAccuracy(sum, 27.652, 0.0001, @"Sum is %f, not 27.652", sum);
}

- (void) testIntegerSumWithAccessor
{
    NSArray *input = @[
                       @{@"name":@"Alice", @"score":@23},
                       @{@"name":@"Bob", @"score":@12},
                       @{@"name":@"Clive", @"score":@43},
                       @{@"name":@"Doireann", @"score":@58},
                       @{@"name":@"Ernest", @"score":@32}
                       ];
    NSInteger sum = [input integerSumWithAccessor:^NSInteger(id item) {
        return [item[@"score"] integerValue];
    }];
    XCTAssertEqual(sum, 168, @"Sum is %d, not 168", sum);
}

- (void) testDoubleSumWithAccessor 
{
    NSArray *input = @[
                       @{@"id":@1, @"value":@2.37},
                       @{@"id":@2, @"value":@3.21},
                       @{@"id":@3, @"value":@-1.02},
                       @{@"id":@4, @"value":@4.25},
                       ];
    double sum = [input doubleSumWithAccessor:^double(id item) {
        return [item[@"value"] doubleValue];
    }];
    XCTAssertEqualWithAccuracy(sum, 8.81, 0.001, @"Sum is %f, not 8.81", sum);
}

- (void)testIntegerMean
{
    NSArray* input = @[ @44, @-6, @65, @9, @0, @-99, @43 ];
    NSInteger mean = [input integerMean];
    XCTAssertEqual(mean, 8, @"Mean is %d, not 8", mean);
}

- (void)testDoubleMean
{
    NSArray *input = @[ @1.23, @-0.5, @20.21, @0.004, @6.708];
    double mean = [input doubleMean];
    XCTAssertEqualWithAccuracy(mean, 5.5304, 0.0001, @"Mean is %f, not 5.5304", mean);
}



@end
