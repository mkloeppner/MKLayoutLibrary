//
//  MKLinearLayoutItem.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayoutItem.h"

FOUNDATION_EXPORT const CGFloat kMKLinearLayoutWeightInvalid;

@interface MKLinearLayoutItem : MKLayoutItem

/**
 * An relative size within a layout
 *
 * @discussion
 * Weight will be used by layouts to determinate the overall weight.
 * The overall weight represents the whole available space in points minus all absolute sizes.
 *
 * The percentage of this item weight in relation to the overall weight is used to calculate
 * the items size within a layout.
 *
 * This prevents items to expand over the available layouts space and allows specifing sizes in relations such as having an item as twice as big as another one.
 */
@property (assign, nonatomic) CGFloat weight;

@end
