//
//  VisualisationController.m
//  DynamicDataViewTest
//
//  Created by acb on 11/09/2013.
//  Copyright (c) 2013 Andrew C. Bulhak. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "D2UIVisualisationContext.h"

@interface D2UIVisualisationContext () {    
    NSMutableDictionary *_dataSubviews; // datum ID -> subview
}

@end

@implementation D2UIVisualisationContext

- (id)init
{
    self = [super init];
    if (self) {
        _dataSubviews = [NSMutableDictionary dictionaryWithCapacity:8];
    }
    return self;
}

- (void) updateWithData:(NSArray*)data {
    _data = data;
    NSUInteger i = 0;
    
    if(_delegate &&[_delegate respondsToSelector:@selector(prepareForNewData:inContext:)]) {
        [_delegate prepareForNewData:data inContext:self];
    }
    // First add any new subviews
    NSMutableDictionary* unprocessed = [_dataSubviews mutableCopy];
    for(id d in data) {
        id ident = [self identifierForDatum:d atIndex:i];
        UIView* v = [_dataSubviews objectForKey:ident];
        if(!v) {
            v = [self createViewForDatum:d];
            [_dataSubviews setObject:v forKey:ident];
        } else {
            [unprocessed removeObjectForKey:ident];
        }
        i++;
    }
    [unprocessed enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [_dataSubviews removeObjectForKey:key];
        // TODO: perhaps add obj to a set of recyclable elements?
        [self removeElement:obj];
    }];
    if(_delegate && [_delegate respondsToSelector:@selector(willBeginDataUpdateInContext:)]) {
        [_delegate willBeginDataUpdateInContext:self];
    }
    // now update the existing views
    i = 0;
    for(id d in data) {
        id ident = [self identifierForDatum:d atIndex:i];
        UIView* v = [_dataSubviews objectForKey:ident];
        [self updateView:v forDatum:d atIndex:i];
        i++;
    }
    
    if(_delegate &&[_delegate respondsToSelector:@selector(dataUpdateEndedInContext:)]) {
        [_delegate dataUpdateEndedInContext:self];
    }

    
}

#pragma mark -- Utility methods used by the delegate

- (void)addElement:(id)elem {
    if([elem isKindOfClass:UIView.class]) {
        [_view addSubview:elem];
    } else {
        NSAssert([elem isKindOfClass:CALayer.class], @"Elements must be derived from UIView or CALayer");
        [_view.layer addSublayer:elem];
    }
}

#pragma mark -- Delegate/callback calls and defaults

- (id) identifierForDatum:(id)d atIndex:(NSUInteger)i {
    if(_delegate && [_delegate respondsToSelector:@selector(identifierForDatum:inContext:)]) {
        return [_delegate identifierForDatum:d inContext:self];
    }
    return [NSNumber numberWithInteger:i];
}
                                       
- (id)createViewForDatum:(id)datum {
    if(_delegate && [_delegate respondsToSelector:@selector(createElementForDatum:inContext:)]) {
        return [_delegate createElementForDatum:datum inContext:self];
    }
    return nil;
}

- (void) removeElement:(id)elem {
    if(_delegate && [_delegate respondsToSelector:@selector(removeElement:inContext:)]) {
        [_delegate removeElement:elem inContext:self];
    } else {
        if([elem isKindOfClass:UIView.class]) {
            [elem removeFromSuperview];
        } else {
            NSAssert([elem isKindOfClass:CALayer.class], @"Elements must be derived from UIView or CALayer");
            [elem removeFromSuperlayer];
        }
    }
}

- (void)updateView:(id)view forDatum:(id)datum atIndex:(NSUInteger)i {
    if(_delegate && [_delegate respondsToSelector:@selector(updateElement:forDatum:atIndex:inContext:)]) {
        [_delegate updateElement:view forDatum:datum atIndex:i inContext:self];
    }
}

- (void) removeView:(id)view {
    
    // TODO: add delegate support
    if([_view isKindOfClass:UIView.class]) {
        [_view removeFromSuperview];
    } else {
        NSAssert([_view isKindOfClass:CALayer.class], @"Elements must be derived from UIView or CALayer");
        [(CALayer*)_view removeFromSuperlayer];
    }
}


@end
