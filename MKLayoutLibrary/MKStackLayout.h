//
//  MKStackLayout.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayout.h"
#import "MKStackLayoutItem.h"

@interface MKStackLayout : MKLayout

- (MKStackLayoutItem *)addSublayout:(MKLayout *)sublayout;
- (MKStackLayoutItem *)addSubview:(UIView *)subview;

@end
