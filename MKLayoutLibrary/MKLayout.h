//
//  MKLayout.h
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLayoutItem.h"

/**
 * MKLayout is the root class of MKLayoutLibrary
 *
 *
 * @discussion
 *
 * MKLayout maintains the view and layout tree and provides an easy interface for subclasses such as MKLinearLayout
 *
 * MKLayout subclasses can easy implement their layout behavior without to maintain view or layout classes.
 *
 * Therefore the items array gives easy access to the layout children.
 *
 */
@interface MKLayout : NSObject

/**
 * The parent layout item if layout is a sublayout
 */
@property (strong, nonatomic, readonly) MKLayoutItem *item;

/**
 * Adds spacing all around the layout contents
 */
@property (assign, nonatomic) UIEdgeInsets margin;

/**
 * The view that is layouted
 */
@property (strong, nonatomic) UIView *view;

/**
 * The layout items representing the layouts structure
 */
@property (strong, nonatomic, readonly) NSArray *items;

/**
 * @param view The root layouts view or the view that needs to be layouted
 */
- (instancetype)initWithView:(UIView *)view;

/**
 * Removed all subviews and sublayouts
 */
- (void)clear;

/**
 * Add a subview to the layout.
 *
 * @param subview a view that will be position by the layout
 * @return the associated MKLayoutItem to treat the layout behavior with margins, or gravity.
 */
- (MKLayoutItem *)addSubview:(UIView *)subview;

/**
 * Add a sublayout to the layout.
 *
 * @param subview a view that will be position by the layout
 * @return the associated MKLayoutItem to treat the layout behavior with margins, or gravity.
 */
- (MKLayoutItem *)addSublayout:(MKLayout *)sublayout;

/**
 * Add a layout item to allow subclasses using their own item classes with custom properties
 */
- (void)addLayoutItem:(MKLayoutItem *)layoutItem;

/**
 * Calls layoutBounds with the associated view bounds
 */
- (void)layout;

/**
 * layoutBounds:(CGRect)bounds needs to be implemented by subclasses in order to achieve the layout behavior.
 *
 * It will automatically be called.
 *
 * @param bounds - The rect within the layout calculates the child position
 *
 */
- (void)layoutBounds:(CGRect)bounds;

/**
 * Moves an rect within an other rect and uses the gravity to align it within.
 *
 * Note: If gravity is MKLayoutGravityNone the method exits immediately with return the rect param.
 */
- (CGRect)applyGravity:(MKLayoutGravity)gravity withRect:(CGRect)rect withinRect:(CGRect)outerRect;

@end
