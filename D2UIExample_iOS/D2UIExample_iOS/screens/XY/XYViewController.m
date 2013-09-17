//
//  XYViewController.m
//  DynamicDataViewTest
//
//  Created by acb on 12/09/2013.
//  Copyright (c) 2013 Andrew C. Bulhak. All rights reserved.
//

#import "XYViewController.h"
#import "D2UIVisualisationContext.h"
#import <QuartzCore/QuartzCore.h>

@interface XYViewController ()<VisualisationDelegate> {
    IBOutlet D2UIVisualisationContext* _viz;
    NSInteger _counter;
    NSMutableArray* _items;
    NSTimer* _tickTimer;
}

@end

@implementation XYViewController

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
    _counter = 2;
    _items = [@[ 
               @{ @"x":@(0.4), @"y":@(0.7), @"id":@(0) },
               @{ @"x":@(0.1), @"y":@(0.1), @"id":@(1) },
               ] mutableCopy];
}

- (void)tick:(NSTimer*)t {
    unsigned int i, c;
    if(_items.count > 10) {
        c = random() % 7;
        for(i = 0; i < c; i++) {
            [_items removeObjectAtIndex:0];
        }
    }
    c = random() % 6;
    for(i = 0; i < c; i++) {
        [_items addObject:@{
                            @"x": @((float)((random()%1000)-500)/500.0),
                            @"y": @((float)((random()%1000)-500)/500.0),
                            @"id": @(_counter++),
                            // random variables for colour-coding
                            @"a" : @((random()&0xff)/255.0),
                            @"b" : @((random()&0xff)/255.0),
                            // 
                            @"size" : @((random()%20)+3),
                            }];
    }
    [_viz updateWithData:_items];
}

- (void)viewDidAppear:(BOOL)animated {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

#pragma mark -- VisualisationDelegate

- (id)identifierForDatum:(id)datum inContext:(D2UIVisualisationContext*)ctx {
    return [datum objectForKey:@"id"];
}

- (id)createElementForDatum:(id)datum inContext:(D2UIVisualisationContext*)ctx {
    CGFloat size = [datum[@"size"] floatValue];
    CALayer* l = [CALayer layer];
    l.anchorPoint = CGPointMake(0.5, 0.5);
    l.bounds = CGRectMake(0.0, 0.0, size*2, size*2);
    l.cornerRadius = size;
    l.backgroundColor = [UIColor colorWithHue:[datum[@"a"] floatValue] saturation:0.6 brightness:([datum[@"b"] floatValue]*0.5)+0.5 alpha:0.9].CGColor;
    [ctx addElement:l];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.fromValue = @(0.0);
    anim.toValue = @(1.0);
    anim.fillMode = kCAFillModeForwards;
    [l addAnimation:anim forKey:@"appear"];
    return l;    
}

- (void)updateElement:(id)view forDatum:(id)datum atIndex:(NSInteger)i inContext:(D2UIVisualisationContext*)ctx {
    CALayer* v = (CALayer*)view;
    CGSize vs = ctx.view.frame.size;
    CGFloat xval = ([[datum objectForKey:@"x"] doubleValue]+1.0)*vs.width/2.0;
    CGFloat yval = ([[datum objectForKey:@"y"] doubleValue]+1.0)*vs.height/2.0;
    v.position = CGPointMake(xval, yval);
}

- (void)removeElement:(id)elem inContext:(D2UIVisualisationContext *)ctx {
    [CATransaction begin];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.fromValue = @(1.0);
    anim.toValue = @(0.0);
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    [CATransaction setCompletionBlock:^{[elem removeFromSuperlayer];}];
    [elem addAnimation:anim forKey:@"disappear"];
    [CATransaction commit];
}

#pragma mark --

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
