//
//  MKLayout.m
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayout.h"

@interface MKLayout ()

@property (strong, nonatomic) NSMutableArray *mutableItems;

@end

@implementation MKLayout

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.view = view;
        
        self.mutableItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (MKViewLayoutItem *)addSubview:(UIView *)subview
{
    MKViewLayoutItem *layoutItem = [[MKViewLayoutItem alloc] initWithLayout:self view:subview];
    [self addLayoutItem:layoutItem];
    return layoutItem;
}

- (MKSublayoutLayoutItem *)addSublayout:(MKLayout *)sublayout
{
    MKSublayoutLayoutItem *layoutItem = [[MKSublayoutLayoutItem alloc] initWithLayout:self sublayout:sublayout];
    [self addLayoutItem:layoutItem];
    return layoutItem;
}

- (void)addLayoutItem:(MKLayoutItem *)layoutItem
{
    if ([layoutItem isKindOfClass:[MKViewLayoutItem class]]) {
        MKViewLayoutItem * layoutItemView = (MKViewLayoutItem *)layoutItem;
        [self.view addSubview:layoutItemView.view];
    }
    [self.mutableItems addObject:layoutItem];
}

- (void)removeLayoutItem:(MKLayoutItem *)layoutItem
{
    [self.mutableItems removeObject:layoutItem];
}

- (NSArray *)items
{
    return [NSArray arrayWithArray:self.mutableItems];
}

- (void)layout
{
    [self layoutBounds:self.view.bounds];
}

- (void)layoutBounds:(CGRect)bounds
{
    
}

@end
