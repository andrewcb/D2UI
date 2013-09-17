//
//  PieChartViewController.m
//  DynamicDataViewTest
//
//  Created by acb on 14/09/2013.
//  Copyright (c) 2013 Andrew C. Bulhak. All rights reserved.
//

#import "PieChartViewController.h"
#import "D2UIVisualisationContext.h"
#import "NSArray+D2UI.h"
#import "PieSegmentLayer.h"

static const int NUM_SLICES = 7;

@interface PieChartViewController ()<VisualisationDelegate> {
    IBOutlet D2UIVisualisationContext *_viz;
    NSUInteger _numColours;
    double _total;
    // we can use this to keep state, taking advantage of the fact that updateElement: is called in sequence
    double _totalSoFar;
}
@end

@implementation PieChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [self tick:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

- (void)tick:(NSTimer*)t {
    NSMutableArray* data = [NSMutableArray arrayWithCapacity:NUM_SLICES];
    for(NSUInteger i=0; i<NUM_SLICES; i++) {
        [data addObject:@(random()%16)];
    }
    [_viz updateWithData:data];
}

#pragma mark -- VisualisationDelegate

- (id)createElementForDatum:(id)datum inContext:(D2UIVisualisationContext*)ctx {
    PieSegmentLayer* l = [PieSegmentLayer layer];
    l.bounds = _viz.view.layer.bounds;
    l.position = CGPointZero;
    l.anchorPoint = CGPointZero;
    [_viz.view.layer addSublayer:l];
    return l;
}

- (void)updateElement:(id)elem forDatum:(id)datum atIndex:(NSInteger)i inContext:(D2UIVisualisationContext*)ctx {
    PieSegmentLayer* l = (PieSegmentLayer*)elem;
    l.fillColor = [UIColor colorWithHue:(float)i/(float)_numColours saturation:0.8 brightness:1.0 alpha:1.0].CGColor;
    l.startAngle = (_totalSoFar/_total)*M_PI*2;
    _totalSoFar += [datum doubleValue];
    l.endAngle = (_totalSoFar/_total)*M_PI*2;
}

- (void)prepareForNewData:(NSArray *)data inContext:(D2UIVisualisationContext *)ctx {
    _total = [data doubleSum];
    _totalSoFar = 0; 
    _numColours = [data count];
}


@end
