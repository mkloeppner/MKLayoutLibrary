//
//  MKLinearLayoutItem.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayoutItem.h"

FOUNDATION_EXPORT const CGFloat kMKLinearLayoutSizeValueMatchParent;
FOUNDATION_EXPORT const CGFloat kMKLinearLayoutWeightInvalid;

@interface MKLinearLayoutItem : MKLayoutItem

/**
 * An absolute size within a layout
 */
@property (assign, nonatomic) CGSize size;

/**
 * An relative size within a layout
 *
 * @discussion
 * Weight will be used by layouts to determinate the overall weight.
 * The overall weight represents the while space in points minus all absolute sizes.
 *
 * The percentage of this item weight in relation to the overall weight is used to calculate
 * the items size within a layout.
 *
 * This prevents items to expand over the available layouts space.
 */
@property (assign, nonatomic) CGFloat weight;

/**
 * A spacing surrounding the layout items view.
 */
@property (assign, nonatomic) UIEdgeInsets margin;

@end
