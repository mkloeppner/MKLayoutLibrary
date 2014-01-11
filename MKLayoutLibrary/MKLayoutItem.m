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

- (void)removeFromLayout
{
    [self.layout removeLayoutItem:self];
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



@interface MKViewLayoutItem ()

@property (strong, nonatomic) UIView *view;

@end

@implementation MKViewLayoutItem

- (instancetype)initWithLayout:(MKLayout *)layout view:(UIView *)view
{
    self = [super initWithLayout:layout];
    if (self) {
        self.view = view;
    }
    return self;
}

- (void)removeFromLayout
{
    [self.view removeFromSuperview];
    [super removeFromLayout];
}

@end


@interface MKSublayoutLayoutItem ()

@property (strong, nonatomic) MKLayout *sublayout;

@end

@implementation MKSublayoutLayoutItem

- (instancetype)initWithLayout:(MKLayout *)layout sublayout:(MKLayout *)sublayout
{
    self = [super initWithLayout:layout];
    if (self) {
        self.sublayout = sublayout;
    }
    return self;
}

- (void)removeFromLayout
{
    for (MKLayoutItem *item in self.sublayout.items) {
        [item removeFromLayout];
    }
    [super removeFromLayout];
}

@end