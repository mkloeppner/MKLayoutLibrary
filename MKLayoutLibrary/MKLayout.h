//
//  MKLayout.h
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLayoutItem.h"

@interface MKLayout : NSObject

/**
 * The view that is layouted.
 */
@property (strong, nonatomic) UIView *view;

/**
 * The layout items representating the layouts structure
 */
@property (strong, nonatomic, readonly) NSArray *items;

- (instancetype)initWithView:(UIView *)view;

- (MKViewLayoutItem *)addSubview:(UIView *)subview;
- (MKSublayoutLayoutItem *)addSublayout:(MKLayout *)sublayout;

- (void)addLayoutItem:(MKLayoutItem *)layoutItem;

- (void)layout;

- (void)layoutBounds:(CGRect)bounds;

@end
