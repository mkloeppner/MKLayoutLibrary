//
//  MKStackLayout.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayout.h"
#import "MKStackLayoutItem.h"

/**
 *  A stack layout creates for every single view its own layer which creates "overlays"
 */
@interface MKStackLayout : MKLayout

DECLARE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(MKStackLayoutItem)

@end
