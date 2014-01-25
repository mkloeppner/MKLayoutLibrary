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

/**
* @param view The root layouts view or the view that needs to be layouted
*/
- (instancetype)initWithView:(UIView *)view;

- (MKLayoutItem *)addSubview:(UIView *)subview;
- (MKLayoutItem *)addSublayout:(MKLayout *)sublayout;

- (void)addLayoutItem:(MKLayoutItem *)layoutItem;

- (void)layout;

- (void)layoutBounds:(CGRect)bounds;

/**
* Moves an rect within an other rect and uses the gravity to align it within.
*
* Note: If gravity is MKLayoutGravityNone the method exits immediately with return the rect param.
*/
- (CGRect)applyGravity:(MKLayoutGravity)gravity withRect:(CGRect)rect withinRect:(CGRect)outerRect;

@end
