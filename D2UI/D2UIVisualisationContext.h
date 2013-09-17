//
//  VisualisationController.h
//  DynamicDataViewTest
//
//  Created by acb on 11/09/2013.
//  Copyright (c) 2013 Andrew C. Bulhak. All rights reserved.
//

#import <Foundation/Foundation.h>

@class D2UIVisualisationContext;

/** The delegate protocol which is implemented by users of VisualisationContext. All users will have to implement at least some of these methods in order to produce useful results. */
@protocol VisualisationDelegate <NSObject>

/** Return an identifier (typically either a NSString or NSNumber) for a data record; this allows continuity, with records sharing the same identity being animated when values change. If not specified, the index of the value in the data list is used. */
- (id)identifierForDatum:(id)datum inContext:(D2UIVisualisationContext*)ctx;

/** Create an element representing a piece of data and add it to the view (typically by calling the context's addElement: method); returns the element created.  */
- (id)createElementForDatum:(id)datum inContext:(D2UIVisualisationContext*)ctx;

/** Optional; called when the context has received new data. May be used to perform any calculations depending on the entire data that need to be done before individual elements are processed (i.e., anything depending on the length or extents of the data). */
- (void)prepareForNewData:(NSArray*)data inContext:(D2UIVisualisationContext*)ctx;

/** Optional; called when the data-update phase will begin.  */
- (void)willBeginDataUpdateInContext:(D2UIVisualisationContext*)ctx;

/** Optional; called at the end of a data update */
- (void)dataUpdateEndedInContext:(D2UIVisualisationContext*)ctx;

/** Called once for each (existing) element to  */
- (void)updateElement:(id)view forDatum:(id)datum atIndex:(NSInteger)i inContext:(D2UIVisualisationContext*)ctx;

/** If defined, removes an element whose data record no longer exists.  */
- (void) removeElement:(id)elem inContext:(D2UIVisualisationContext*)ctx;

@end


@interface D2UIVisualisationContext : NSObject

@property (nonatomic, weak) IBOutlet UIView* view;
@property (nonatomic, weak) IBOutlet id<VisualisationDelegate> delegate;
@property (readonly) NSArray* data;

/** Update the visualisation with new data  */
- (void) updateWithData:(NSArray*)data;

// Methods used by the delegate
/** Intelligently add an element to the view managed by the context. This can handle either UIView or CALayer-derived elements.  */
- (void)addElement:(id)elem;
/** Intelligently remove an element from the view managed by the context. This can handle either UIView- or CALayer-derived elements. */
- (void)removeElement:(id)elem;

@end
