//
//  MKLayout.h
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLayoutItem.h"
#import "MKLayoutDelegate.h"
#import "MKLayoutSeparatorDelegate.h"
#import "MKLayoutOrientation.h"

#define DECLARE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(classname) \
- (classname *)addSubview:(UIView *)subview; \
- (classname *)addSublayout:(MKLayout *)sublayout; \
- (classname *)insertSubview:(UIView *)subview atIndex:(NSInteger)index; \
- (classname *)insertSublayout:(MKLayout *)sublayout atIndex:(NSInteger)index; \

#define SYNTHESIZE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(classname) \
- (classname *)addSubview:(UIView *)subview \
{ \
    return [self insertSubview:subview atIndex:self.items.count]; \
} \
\
- (classname *)addSublayout:(MKLayout *)sublayout \
{ \
    return [self insertSublayout:sublayout atIndex:self.items.count]; \
} \
\
- (classname *)insertSubview:(UIView *)subview atIndex:(NSInteger)index \
{ \
    classname *layoutItem = [[classname alloc] initWithLayout:self subview:subview]; \
    [self insertLayoutItem:layoutItem atIndex:index]; \
    return layoutItem; \
} \
\
- (classname *)insertSublayout:(MKLayout *)sublayout atIndex:(NSInteger)index \
{ \
    classname *layoutItem = [[classname alloc] initWithLayout:self sublayout:sublayout]; \
    [self insertLayoutItem:layoutItem atIndex:index]; \
    return layoutItem; \
}

/**
 * MKLayout is the root class of MKLayoutLibrary
 *
 *
 * @discussion
 *
 * MKLayout maintains the view and layout tree and provides an easy interface for subclasses such as MKLinearLayout
 *
 * MKLayout subclasses can easy implement their layout behavior without the needs to maintain the view and layout hirarchy.
 *
 * Therefore the items array gives easy access to the layout children.
 *
 * Every layout needs to support all MKLayoutItem properties.
 *
 */
@interface MKLayout : NSObject

/**
 * Allows to store meta data for debugging, layout introspection ...
 */
@property (strong, nonatomic) NSDictionary *userInfo;

/**
 * The layouts content scale factor
 *
 * The views frames will be set in points. With specifying the contentScaleFactor this frames will be round to perfectly match the grid.
 *
 * Default value is 1.0f;
 */
@property (assign, nonatomic) CGFloat contentScaleFactor;

/**
 * The layout delegate notifies layout steps and delegate some layout calculations.
 */
@property (strong, nonatomic) id<MKLayoutDelegate> delegate;

/**
 * Moves the separator creation to another instance.
 *
 * Ask for numberOfSeparators before the layout executes to prepare for layout calls.
 */
@property (weak, nonatomic) id<MKLayoutSeparatorDelegate> separatorDelegate;

/**
 * The parent layout item if layout is a sublayout
 */
@property (strong, nonatomic, readonly) MKLayoutItem *item;

/**
 * Adds spacing all around the layout contents
 */
@property (assign, nonatomic) UIEdgeInsets margin;

/**
 * The layouts view.
 *
 * All layout items views and sublayout views will be added into the specified layout view.
 *
 * For sublayouts the view property will be set automatically to parent layouts view.
 */
@property (strong, nonatomic) UIView *view;

/**
 * The layout items representing the layouts structure
 *
 * Contains instances of MKLayoutItem or its subclasses. MKLayout subclasses ensure typesafety by overwriting - (MKLayoutItem *)addView:(UIView *)view and - (MKLayoutItem *)addSublayout:(MKLayout *)sublayout
 */
@property (strong, nonatomic, readonly) NSArray *items;

/**
 * @param view The root layouts view or the view that needs to be layouted
 */
- (instancetype)initWithView:(UIView *)view;

#pragma mark - UIView and Layout API
/**
 * Adds a subview to the layout.
 *
 * @param subview a view that will be position by the layout
 * @return the associated MKLayoutItem It allows layout behavior costumization with view layout properties
 */
- (MKLayoutItem *)addSubview:(UIView *)subview;

/**
 * Adds a sublayout to the layout.
 *
 * @param sublayout a sublayout that will be position by the layout
 * @return the associated MKLayoutItem It allows layout behavior costumization with view layout properties
 */
- (MKLayoutItem *)addSublayout:(MKLayout *)sublayout;

/**
 * Adds a subview to the layout with a specific index.
 *
 * @param subview a view that will be position by the layout
 * @param index the position in the layout at which the subview will be inserted
 * @return the associated MKLayoutItem It allows layout behavior costumization with view layout properties
 */
- (MKLayoutItem *)insertSubview:(UIView *)subview atIndex:(NSInteger)index;

/**
 * Adds a sublayout to the layout with a specific index.
 *
 * @param sublayout a sublayout that will be position by the layout
 * @param index the position in the layout at which the sublayout will be inserted
 * @return the associated MKLayoutItem It allows layout behavior costumization with view layout properties
 */
- (MKLayoutItem *)insertSublayout:(MKLayout *)sublayout atIndex:(NSInteger)index;

#pragma mark - MKLayoutItem API
/**
 * Removed all subviews and sublayouts
 *
 *      Hint: To remove single items, checkout MKLayoutItem:removeFromLayout;
 */
- (void)clear;

/**
 * Add a layout item to allow subclasses using their own item classes with custom properties
 */
- (void)insertLayoutItem:(MKLayoutItem *)layoutItem atIndex:(NSInteger)index;

/**
 * Removes a layout item with a specified index
 *
 * @param index the index of the item that will be removed
 */
- (void)removeLayoutItemAtIndex:(NSInteger)index;

/**
 *  Inserts a layout item at the end of the layout
 *
 *  @param layoutItem the item, that will be added at the end of the layout
 */
- (void)addLayoutItem:(MKLayoutItem *)layoutItem;

/**
 *  Removes a layout item from a layout.
 *
 * Additionally it removes its assoicated view, if its a view layout item or its associated sublayout views if its a sublayout item.
 *
 *  @param layoutItem The layout item to be removed from the layout
 */
- (void)removeLayoutItem:(MKLayoutItem *)layoutItem;

#pragma mark - Layouting API
/**
 * Calls layoutBounds with the associated view bounds
 */
- (void)layout;

/**
 * layoutBounds:(CGRect)bounds needs to be implemented by subclasses in order to achieve the layout behavior.
 *
 * It will automatically be called.
 *
 * @param bounds - The rect within the layout calculates the child position
 *
 */
- (void)layoutBounds:(CGRect)bounds;

/**
 * Moves an rect within an other rect and uses the gravity to align it within.
 *
 *      Note: If gravity is MKLayoutGravityNone the method exits immediately with return the rect param.
 *
 * @param gravity Specifies to which edge an inner rectangle is bound of an outer rectangle in horizontal and vertical manner
 * @param rect The inner rect that is beeing moved by a gravity
 *
 */
- (CGRect)applyGravity:(MKLayoutGravity)gravity withRect:(CGRect)rect withinRect:(CGRect)outerRect;

/**
 * Rounds the given rects values with the specified content scale factor in order to round to the pixel grid.
 */
- (CGRect)rectRoundedToGridWithRect:(CGRect)rect;

/**
 * Returns the amount of separators for a specific orientation
 */
- (NSInteger)numberOfSeparatorsForSeparatorOrientation:(MKLayoutOrientation)orientation;

/**
 * Flips the orientation to the opposit
 */
- (MKLayoutOrientation)flipOrientation:(MKLayoutOrientation)orientation;

@end
