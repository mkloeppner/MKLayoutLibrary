//
//  MKLayout.h
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLayoutItem.h"
#import "MKLayoutDelegate.h"

/**
 * MKLayout is the root class of MKLayoutLibrary
 *
 *
 * @discussion
 *
 * MKLayout maintains the view and layout tree and provides an easy interface for subclasses such as MKLinearLayout
 *
 * MKLayout subclasses can easy implement their layout behavior without the needs to maintain the view and layout hirarchy.
 *
 * Therefore the items array gives easy access to the layout children.
 *
 * Every layout needs to support all MKLayoutItem properties.
 *
 */
@interface MKLayout : NSObject

/**
 * The layout delegate notifies layout steps and delegate some layout calculations.
 */
@property (strong, nonatomic) id<MKLayoutDelegate> delegate;

/**
 * The parent layout item if layout is a sublayout
 */
@property (strong, nonatomic, readonly) MKLayoutItem *item;

/**
 * Adds spacing all around the layout contents
 */
@property (assign, nonatomic) UIEdgeInsets margin;

/**
 * The layouts view.
 *
 * All layout items views and sublayout views will be added into the specified layout view.
 *
 * For sublayouts the view property will be set automatically to parent layouts view.
 */
@property (strong, nonatomic) UIView *view;

/**
 * The layout items representing the layouts structure
 *
 * Contains instances of MKLayoutItem or its subclasses. MKLayout subclasses ensure typesafety by overwriting - (MKLayoutItem *)addView:(UIView *)view and - (MKLayoutItem *)addSublayout:(MKLayout *)sublayout
 */
@property (strong, nonatomic, readonly) NSArray *items;

/**
 * @param view The root layouts view or the view that needs to be layouted
 */
- (instancetype)initWithView:(UIView *)view;

/**
 * Removed all subviews and sublayouts
 *
 *      Hint: To remove single items, checkout MKLayoutItem:removeFromLayout;
 */
- (void)clear;

/**
 * Adds a subview to the layout.
 *
 * @param subview a view that will be position by the layout
 * @return the associated MKLayoutItem It allows layout behavior costumization with view layout properties
 */
- (MKLayoutItem *)addSubview:(UIView *)subview;

/**
 * Adds a sublayout to the layout.
 *
 * @param sublayout a sublayout that will be position by the layout
 * @return the associated MKLayoutItem It allows layout behavior costumization with view layout properties
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
 *      Note: If gravity is MKLayoutGravityNone the method exits immediately with return the rect param.
 *
 * @param gravity Specifies to which edge an inner rectangle is bound of an outer rectangle in horizontal and vertical manner
 * @param rect The inner rect that is beeing moved by a gravity
 *
 */
- (CGRect)applyGravity:(MKLayoutGravity)gravity withRect:(CGRect)rect withinRect:(CGRect)outerRect;

@end
