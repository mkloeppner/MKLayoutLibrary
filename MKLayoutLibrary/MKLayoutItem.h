//
//  MKLayoutItem.h
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKGravity.h"

@class MKLayout;

/**
 * Specifies that the layout item view should match the parent views or parent layouts size.
 */
FOUNDATION_EXPORT const CGFloat kMKLayoutItemSizeValueMatchParent;

/**
 * MKLayoutItem contains all the necessary information for layouts in order to perform its layout implementation.
 *
 * @discussion
 *
 * MKLayoutItem extends UIView via composition. It is the base class for all kind of layouts.
 *
 * Every layout has to support size, margin, gravity, subviews and sublayouts.
 *
 * In addition, layouts can have its own properties. Therefore MKLayoutItem can be sublassed with extending MKLayoutItem and importing MKLayoutItem_SubclassAccessors.h
 */
@interface MKLayoutItem : NSObject

- (instancetype)initWithLayout:(MKLayout *)layout subview:(UIView *)view;
- (instancetype)initWithLayout:(MKLayout *)layout sublayout:(MKLayout *)sublayout;

/**
 * The parent layout of the current layout item
 */
@property (weak, nonatomic, readonly) MKLayout *layout;

/**
 * An absolute size within a layout
 *
 * kMKLayoutItemSizeValueMatchParent can be used to set either
 *
 * - the width
 * - the height
 * - or both to parents size to perfectly fit the space
 */
@property (assign, nonatomic) CGSize size;

/**
 * Ensures a margin around the layout items view. 
 */
@property (assign, nonatomic) UIEdgeInsets padding;

/**
 * Moves the items view or sublayout by the specified offset.
 *
 * Positive values increases the offset from the top left while negatives do the opposite
 */
@property (assign, nonatomic) UIOffset offset;

/**
 * Inserts a border 
 *
 * Default: NO
 */
@property (assign, nonatomic) BOOL insertBorder;

/**
 * Can store a subview or a sublayout.
 *
 * Use the property which instance is not nil
 */
@property (strong, nonatomic, readonly) UIView *subview;
@property (strong, nonatomic, readonly) MKLayout *sublayout;

/**
 * Gravity aligns the layout items view to the following options:
 *
 * gravity = MKLayoutGravityTop | MKLayoutGravityLeft = The view is on the upper left corner
 * gravity = MKLayoutGravityBottom | MKLayoutGravityCenterHorizontal = The view is on the horizontal center of the bottom view
 * gravity = MKLayoutGravityCenterVertical | MKLayoutGravityCenterHorizontal = The view is on the center of the cell
 *
 * @see MKLayoutGravity
 */
@property (assign, nonatomic) MKLayoutGravity gravity;

/**
 * Allows to store meta data for debugging, layout introspection ...
 */
@property (strong, nonatomic) NSDictionary *userInfo;

/**
 * Removes the whole layout contents and cleans them up
 */
- (void)removeFromLayout;

@end
