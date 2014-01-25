//
//  MKStackLayoutItem.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayoutItem.h"

FOUNDATION_EXPORT const CGFloat kMKStackLayoutSizeValueMatchParent;

@interface MKStackLayoutItem : MKLayoutItem

/**
 * An absolute size within a layout
 */
@property (assign, nonatomic) CGSize size;

/**
 * The offset between the parent and the layout items view
 */
@property (assign, nonatomic) UIEdgeInsets margin;

@end
