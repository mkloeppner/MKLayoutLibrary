//
//  MKLayoutItem.m
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayoutItem.h"
#import "MKLayout.h"

const CGFloat kMKLayoutItemSizeValueMatchParent = -1.0f;

@interface MKLayout (APIAccessor)

- (void)removeLayoutItem:(MKLayoutItem *)layoutItem;

@end

@interface MKLayoutItem ()

@property (weak, nonatomic) MKLayout *layout;
@property (strong, nonatomic, readwrite) UIView *subview;
@property (strong, nonatomic, readwrite) MKLayout *sublayout;


@end

@implementation MKLayoutItem

- (instancetype)initWithLayout:(MKLayout *)layout
{
    self = [super init];
    if (self) {
        self.layout = layout;
        _gravity = MKLayoutGravityNone;
        _size = CGSizeMake(kMKLayoutItemSizeValueMatchParent, kMKLayoutItemSizeValueMatchParent);
        _margin = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        _insertBorder = NO;
    }
    return self;
}

- (instancetype)initWithLayout:(MKLayout *)layout sublayout:(MKLayout *)sublayout
{
    MKLayoutItem *item = [self initWithLayout:layout];
    item.sublayout = sublayout;
    return item;
}

- (instancetype)initWithLayout:(MKLayout *)layout subview:(UIView *)view
{
    MKLayoutItem *item = [self initWithLayout:layout];
    item.subview = view;
    return item;
}

- (void)removeFromLayout
{
    [self removeAssociatedViews];
    [self.layout removeLayoutItem:self];
}

- (void)removeAssociatedViews
{
    [self.subview removeFromSuperview];
    
    for (MKLayoutItem *item in self.sublayout.items) {
        [item removeFromLayout];
    }
}

@end