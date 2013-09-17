//
//  BarsViewController.m
//  DynamicDataViewTest
//
//  Created by acb on 11/09/2013.
//  Copyright (c) 2013 Andrew C. Bulhak. All rights reserved.
//

#import "BarsViewController.h"
#import "D2UIVisualisationContext.h"
#import "NSArray+D2UI.h"

@interface BarsViewController () <VisualisationDelegate> {
    IBOutlet D2UIVisualisationContext* _viz;
    IBOutlet UIView* _vizView;
    
    NSInteger _maximum;
    CGFloat _barHeight;
}

@end

@implementation BarsViewController

- (void)viewDidAppear:(BOOL)animated {
    [_viz updateWithData:@[@2, @3, @5, @1, @4]];
}

#pragma mark -- VisualisationDelegate

- (id)createElementForDatum:(id)datum inContext:(D2UIVisualisationContext*)ctx {
    UIView* v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithHue:0.6 saturation:0.4 brightness:0.6 alpha:1.0];
    [ctx addElement:v];
    return v;
}

- (void)prepareForNewData:(NSArray*)data inContext:(D2UIVisualisationContext*)ctx {
    struct D2UIIntegerExtent ext = [data integerExtent];
    _maximum = ext.max;
    _barHeight = floorf(_vizView.frame.size.height / data.count);
}

- (void)updateElement:(id)view forDatum:(id)datum atIndex:(NSInteger)i inContext:(D2UIVisualisationContext*)ctx {
    NSInteger val = [datum integerValue];
    ((UIView*)view).frame = CGRectMake(0.0, i*_barHeight, _vizView.frame.size.width*val/_maximum, _barHeight-1.0);
}

@end
