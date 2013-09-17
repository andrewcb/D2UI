//
//  DynamicBarsViewController.m
//  DynamicDataViewTest
//
//  Created by acb on 13/09/2013.
//  Copyright (c) 2013 Andrew C. Bulhak. All rights reserved.
//

#import "DynamicBarsViewController.h"
#import "D2UIVisualisationContext.h"

static const CGFloat barWidth = 32.0;
static const NSTimeInterval tickTime = 0.5;
// what percentage of the tick time is spent animating
static const float animDutyCycle = 0.6;

@interface DynamicBarsViewController ()<VisualisationDelegate> {
    IBOutlet D2UIVisualisationContext *_viz1, *_viz2, *_viz3;
    NSInteger _counter;
    NSMutableArray* _items1, *_items2, *_items3;
    CGFloat _leftmost;
}

@end

@implementation DynamicBarsViewController

/* This method is called once per timer tick; it causes more data to come into being */
- (void)tick:(NSTimer*)t {
    [_items1 addObject:@{@"id":@(_counter), @"value":@(random()%100)}];
    [_items2 addObject:@{@"id":@(_counter), @"value":@((sinf(_counter*0.4)+1.0)*50)}];
    [_items3 addObject:@{@"id":@(_counter), @"value":@((random()%100)/(_counter%10+1.0))}];
    if(_items1.count > ceilf(_viz1.view.frame.size.width/barWidth)) [_items1 removeObjectAtIndex:0];
    if(_items2.count > ceilf(_viz2.view.frame.size.width/barWidth)) [_items2 removeObjectAtIndex:0];
    if(_items3.count > ceilf(_viz3.view.frame.size.width/barWidth)) [_items3 removeObjectAtIndex:0];
    [_viz1 updateWithData:_items1];
    [_viz2 updateWithData:_items2];
    [_viz3 updateWithData:_items3];
    _counter++;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _items1 = [@[] mutableCopy];
    _items2 = [@[] mutableCopy];
    _items3 = [@[] mutableCopy];
}

- (void)viewDidAppear:(BOOL)animated {
    [NSTimer scheduledTimerWithTimeInterval:tickTime target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

#pragma mark -- VisualisationDelegate

/* maintain continuity; if commented out, the bars stay immobile but move only up and down */
- (id)identifierForDatum:(id)datum inContext:(D2UIVisualisationContext*)ctx {
    return datum[@"id"];
}

/* create a bar at its initial position. This is done outside the update loop, and happens instantaneously. */
- (id)createElementForDatum:(id)datum inContext:(D2UIVisualisationContext*)ctx {
    float val = [datum[@"value"] floatValue];
    CGFloat h = ctx.view.frame.size.height*val/100.0;
    UIView* elem = [[UIView alloc] init];
    elem.backgroundColor = [UIColor colorWithHue:0.6 saturation:0.4 brightness:0.6 alpha:1.0];
    elem.frame = CGRectMake(ctx.view.frame.size.width, ctx.view.frame.size.height-h, barWidth-2.0, h);

    [ctx addElement:elem];
    return elem;
}

/* Move a bar to the position its index and value say it should be at. This happens inside the  update loop, and is animated. */
- (void)updateElement:(id)elem forDatum:(id)datum atIndex:(NSInteger)i inContext:(D2UIVisualisationContext*)ctx {
    
    NSInteger val = [datum[@"value"] integerValue];
    UIView *view = ctx.view;
    CGFloat h  = view.frame.size.height*val/100.0;
    CGRect frame = CGRectMake(_leftmost+i*barWidth, view.frame.size.height-h, barWidth-2.0, h);
    ((UIView*)elem).frame = frame;
}

/* Remove a bar, by sliding it off the left edge. */
- (void)removeElement:(id)elem inContext:(D2UIVisualisationContext *)ctx {
    [UIView animateWithDuration:(tickTime*animDutyCycle) animations:^{
        CGRect frame = [elem frame];
        frame.origin.x = _leftmost-barWidth;
        [elem setFrame:frame];
    } completion:^(BOOL finished) {
        [elem removeFromSuperview];
    }];
}

- (void)prepareForNewData:(NSArray *)data inContext:(D2UIVisualisationContext *)ctx {
    _leftmost = ctx.view.frame.size.width - (barWidth * data.count);
}
- (void)willBeginDataUpdateInContext:(D2UIVisualisationContext*)ctx {
    [UIView beginAnimations:@"data" context:nil];
    [UIView setAnimationDuration:tickTime*animDutyCycle];
}

- (void)dataUpdateEndedInContext:(D2UIVisualisationContext *)ctx {
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

@end
