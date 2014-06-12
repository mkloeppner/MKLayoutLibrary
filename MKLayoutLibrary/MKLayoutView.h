//
//  MKLayoutView.h
//  LayoutParser
//
//  Created by Martin Klöppner on 12/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKLayout.h"

@interface MKLayoutView : UIView

@property (strong, nonatomic) MKLayout *rootLayout;

- (instancetype)initWithLayoutNamed:(NSString *)layoutName;
- (instancetype)initWithFrame:(CGRect)frame layout:(MKLayout *)layout;

@end
