//
//  MKLayoutItem.h
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKLayout;

@interface MKLayoutItem : NSObject

- (instancetype)initWithLayout:(MKLayout *)layout;

@property (weak, nonatomic, readonly) MKLayout *layout;

/**
 * An absolute size within a layout
 */
@property (assign, nonatomic) CGFloat points;

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
 * The offset between the border and the surrounding elements
 */
@property (assign, nonatomic) UIEdgeInsets margin;

/**
 * Specifies whenever points or weight has been set the last time.
 * to determinate if layoutItems associated views size should be calculate 
 * absolute or relative.
 */
@property (assign, nonatomic, readonly) BOOL usesRelativeSize;

- (void)removeFromLayout;

@end


@interface MKViewLayoutItem : MKLayoutItem

- (instancetype)initWithLayout:(MKLayout *)layout view:(UIView *)view;

@property (strong, nonatomic, readonly) UIView *view;

@end


@interface MKSublayoutLayoutItem : MKLayoutItem

- (instancetype)initWithLayout:(MKLayout *)layout sublayout:(MKLayout *)sublayout;

@property (strong, nonatomic, readonly) MKLayout *sublayout;

@end