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

- (instancetype)initWithLayout:(MKLayout *)layout subview:(UIView *)view;
- (instancetype)initWithLayout:(MKLayout *)layout sublayout:(MKLayout *)sublayout;

@property (weak, nonatomic, readonly) MKLayout *layout;

@property (strong, nonatomic, readonly) UIView *subview;

@property (strong, nonatomic, readonly) MKLayout *sublayout;

- (void)removeFromLayout;

@end
