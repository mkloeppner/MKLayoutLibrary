//
//  MKFlowLayout.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 20/04/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayout.h"
#import "MKFlowLayoutItem.h"

/**
 *  A flow layout tries fill either the width or the height with subviews. 
 * If the space of a row or column is full the flow layout continues in another row or column.
 *
 * The distinction if the layout tries to fill either rows or column is made by orientation.
 *
 */
@interface MKFlowLayout : MKLayout

DECLARE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(MKFlowLayoutItem);

/**
 * Specifies in which direction the layout should place its childs.
 *
 * MKFlowLayout dynamically creates new rows or columns depending on orientations.
 *
 * MKLayoutOrientationHorizontal insert new line breaks if the space is exceeded
 * MKLayoutOrientationVertical insert new columns if the space is exceeded
 */
@property (assign, nonatomic) MKLayoutOrientation orientation;

@end
