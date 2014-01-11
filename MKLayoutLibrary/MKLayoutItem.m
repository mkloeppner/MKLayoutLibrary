//
//  MKLayoutItem.m
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayoutItem.h"
#import "MKLayout.h"

@interface MKLayout (APIAccessor)

- (void)removeLayoutItem:(MKLayoutItem *)layoutItem;

@end

@interface MKLayoutItem ()

@property (weak, nonatomic) MKLayout *layout;
@property (assign, nonatomic) BOOL usesRelativeSize;
@property (strong, nonatomic, readwrite) UIView *view;
@property (strong, nonatomic, readwrite) MKLayout *sublayout;


@end

@implementation MKLayoutItem

- (instancetype)initWithLayout:(MKLayout *)layout
{
    self = [super init];
    if (self) {
        self.layout = layout;
        self.usesRelativeSize = NO;
    }
    return self;
}

- (instancetype)initWithLayout:(MKLayout *)layout sublayout:(MKLayout *)sublayout
{
    MKLayoutItem *item = [self initWithLayout:layout];
    item.sublayout = sublayout;
    return item;
}

- (instancetype)initWithLayout:(MKLayout *)layout view:(UIView *)view
{
    MKLayoutItem *item = [self initWithLayout:layout];
    item.view = view;
    return item;
}

- (void)removeFromLayout
{
    [self removeAssociatedViews];
    [self.layout removeLayoutItem:self];
}

- (void)removeAssociatedViews
{
    [self.view removeFromSuperview];
    
    for (MKLayoutItem *item in self.sublayout.items) {
        [item removeFromLayout];
    }
}

- (void)setPoints:(CGFloat)points
{
    _points = points;
    self.usesRelativeSize = NO;
}

- (void)setWeight:(CGFloat)weight
{
    _weight = weight;
    self.usesRelativeSize = YES;
}

@end