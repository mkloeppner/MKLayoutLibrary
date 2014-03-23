//
//  MKLinearLayout.h
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayout.h"
#import "MKLinearLayoutItem.h"
#import "MKLinearLayoutSeparatorDelegate.h"

@interface MKLinearLayout : MKLayout

/**
 * Inserts spacing between the outer border and the different layout items.
 *
 * Reduces the total available space which affects the calculation of relative sizes calculated by weight.
 */
@property (assign, nonatomic) CGFloat spacing;

/**
 * Specifies in which direction the linear layout should place its childs.
 */
@property (assign, nonatomic) MKLayoutOrientation orientation;

/**
 * Separator delegate allows delegate to insert separator images.
 */
@property (assign, nonatomic) id<MKLinearLayoutSeparatorDelegate> separatorDelegate;

/**
 * Overwritten to publish MKLinearLayoutItem instead of MKLayoutItem
 */
- (MKLinearLayoutItem *)addSublayout:(MKLayout *)sublayout;
- (MKLinearLayoutItem *)addSubview:(UIView *)subview;

@property (strong, nonatomic) NSDictionary *userInfo;

@end
