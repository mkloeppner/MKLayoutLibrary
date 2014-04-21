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

- (void)layoutItemWantsRemoval:(MKLayoutItem *)layoutItem;
- (void)runLayout:(CGRect)rect;
- (CGRect)moveRect:(CGRect)rect withinRect:(CGRect)outerRect gravity:(MKLayoutGravity)gravity;

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
        _padding = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        _offset = UIOffsetMake(0.0f, 0.0f);
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
    [self.layout layoutItemWantsRemoval:self];
}

- (void)removeAssociatedViews
{
    [self.subview removeFromSuperview];
    
    for (MKLayoutItem *item in self.sublayout.items) {
        [item removeAssociatedViews];
    }
}

- (void)applyPositionWithinLayoutFrame:(CGRect)itemOuterRect
{
    CGRect marginRect = UIEdgeInsetsInsetRect(itemOuterRect, self.padding);
    
    // Apply items size value if beeing set
    CGRect itemRect = itemOuterRect; // Take the outer rect without margin applied to prevent applying margin twice
    if (self.size.width != kMKLayoutItemSizeValueMatchParent) {
        itemRect.size.width = self.size.width;
    }
    if (self.size.height != kMKLayoutItemSizeValueMatchParent) {
        itemRect.size.height = self.size.height;
    }
    
    itemRect = UIEdgeInsetsInsetRect(itemRect, self.padding);
    
    // Move it within the margin bounds if there is a gravity
    CGRect rect = [self.layout moveRect:itemRect withinRect:marginRect gravity:self.gravity];
    
    rect.origin.x += self.offset.horizontal;
    rect.origin.y += self.offset.vertical;
    
    if (self.subview) {
        rect = [self.layout roundedRect:rect];
        self.subview.frame = rect;
    } else if (self.sublayout) {
        [self.sublayout runLayout:rect];
    }
}

@end