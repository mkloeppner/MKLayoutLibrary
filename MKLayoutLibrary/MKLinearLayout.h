//
//  MKLinearLayout.h
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayout.h"
#import "MKLinearLayoutItem.h"

@protocol MKLinearLayoutSeparatorDelegate;

typedef enum {
    MKLinearLayoutOrientationHorizontal,
    MKLinearLayoutOrientationVertical
} MKLinearLayoutOrientation;

@interface MKLinearLayout : MKLayout

@property (assign, nonatomic) MKLinearLayoutOrientation orientation;
@property (assign, nonatomic) id<MKLinearLayoutSeparatorDelegate> separatorDelegate;

- (MKLinearLayoutItem *)addSublayout:(MKLayout *)sublayout;
- (MKLinearLayoutItem *)addSubview:(UIView *)subview;

@end
