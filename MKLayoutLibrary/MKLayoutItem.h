//
//  MKLayoutItem.h
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKLayout;

FOUNDATION_EXPORT const CGFloat kMKLayoutItemSizeValueMatchParent;

typedef NS_OPTIONS(NSInteger, MKLayoutGravity) {
    MKLayoutGravityTop = 1 << 0,
    MKLayoutGravityBottom = 1 << 1,
    MKLayoutGravityLeft = 1 << 2,
    MKLayoutGravityRight = 1 << 3,
    MKLayoutGravityCenterVertical = 1 << 4,
    MKLayoutGravityCenterHorizontal = 1 << 5,
    MKLayoutGravityNone = 1 << 6
};

@interface MKLayoutItem : NSObject

- (instancetype)initWithLayout:(MKLayout *)layout subview:(UIView *)view;
- (instancetype)initWithLayout:(MKLayout *)layout sublayout:(MKLayout *)sublayout;

/**
* The parent layout of the current layout item
*/
@property (weak, nonatomic, readonly) MKLayout *layout;

/**
 * An absolute size within a layout
 */
@property (assign, nonatomic) CGSize size;

/**
 * A spacing surrounding the layout items view.
 */
@property (assign, nonatomic) UIEdgeInsets margin;

@property (strong, nonatomic, readonly) UIView *subview;
@property (strong, nonatomic, readonly) MKLayout *sublayout;

@property (assign, nonatomic) MKLayoutGravity gravity;

@property (strong, nonatomic) NSDictionary *userInfo;

- (void)removeFromLayout;

@end
