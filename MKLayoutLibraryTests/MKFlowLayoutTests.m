//
//  MKFlowLayoutTestsSpec.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 20/04/14.
//  Copyright 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "MKFlowLayout.h"

#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(MKFlowLayoutTests)

describe(@"MKFlowLayoutTests", ^{
    
    __block UIView *container;
    
    __block MKFlowLayout *layout;
    
    __block UIView *view1;
    __block UIView *view2;
    __block UIView *view3;
    __block UIView *view4;
    
    beforeEach(^{
        
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 190.0f)];
        
        layout = [[MKFlowLayout alloc] initWithView:container];
        
        view1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        view2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        view3 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        view4 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        
    });
    
    it(@"should layout a single view with match parent in width and height", ^{
        
        [layout addSubview:view1];
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(0);
        expect(view1.frame.origin.y).to.equal(0);
        expect(view1.frame.size.width).to.equal(container.frame.size.width);
        expect(view1.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should layout a single sublayout with match parent in width and height", ^{
        
        MKFlowLayout *flowLayout = [[MKFlowLayout alloc] init];
        [flowLayout addSubview:view1];
        
        [layout addSublayout:flowLayout];
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(0);
        expect(view1.frame.origin.y).to.equal(0);
        expect(view1.frame.size.width).to.equal(container.frame.size.width);
        expect(view1.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should have horizontal orientation by default", ^{
        
        expect(layout.orientation).to.equal(MKLayoutOrientationHorizontal);
        
    });
    
    it(@"should layout two single items and start a new line if the second item exceeds the available width when using orientation horizontal", ^{
        
        layout.orientation = MKLayoutOrientationHorizontal;
        
        
        [layout addSubview:view1];
        [layout addSubview:view2];
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(0);
        expect(view1.frame.origin.y).to.equal(0);
        expect(view1.frame.size.width).to.equal(container.frame.size.width);
        expect(view1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(view2.frame.origin.x).to.equal(0);
        expect(view2.frame.origin.y).to.equal(container.frame.size.height);
        expect(view2.frame.size.width).to.equal(container.frame.size.width);
        expect(view2.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should layout two single items and start a new column if the second item exceeds the available height when using orientation vertical", ^{
        
        layout.orientation = MKLayoutOrientationVertical;
        
        [layout addSubview:view1];
        [layout addSubview:view2];
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(0);
        expect(view1.frame.origin.y).to.equal(0);
        expect(view1.frame.size.width).to.equal(container.frame.size.width);
        expect(view1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(view2.frame.origin.x).to.equal(container.frame.size.width);
        expect(view2.frame.origin.y).to.equal(0);
        expect(view2.frame.size.width).to.equal(container.frame.size.width);
        expect(view2.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should layout two single items and keep the line if the second item matches the remaining space perfectly", ^{
        
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
        layout = [[MKFlowLayout alloc] initWithView:container];
        
        layout.orientation = MKLayoutOrientationHorizontal;
        
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(99.0f, 10.0f);
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(1.0f, 10.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(0);
        expect(view1.frame.origin.y).to.equal(0);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
        expect(view2.frame.origin.x).to.equal(item.size.width);
        expect(view2.frame.origin.y).to.equal(0);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);
        
    });
    
    it(@"should layout two single items and start a new line if the second item is one pixel over the available space", ^{
        
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
        layout = [[MKFlowLayout alloc] initWithView:container];
        
        layout.orientation = MKLayoutOrientationHorizontal;
        
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(99.0f, 10.0f);
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(2.0f, 10.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(0);
        expect(view1.frame.origin.y).to.equal(0);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
        expect(view2.frame.origin.x).to.equal(0.0f);
        expect(view2.frame.origin.y).to.equal(10.0f);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);

        
    });
    
    it(@"should apply fixed size for a single item", ^{
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(30.0f, 30.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(0);
        expect(view1.frame.origin.y).to.equal(0);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
    });
    
    it(@"should layout two single items with fixed sizes and start a new line break if the size exceeds the container space", ^{
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(30.0f, 30.0f);
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(110.0f, 30.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(0);
        expect(view1.frame.origin.y).to.equal(0);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
        expect(view2.frame.origin.x).to.equal(0);
        expect(view2.frame.origin.y).to.equal(item.size.height);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);
        
    });
    
    it(@"should apply padding on an item with match parent", ^{
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(kMKLayoutItemSizeValueMatchParent, kMKLayoutItemSizeValueMatchParent);
        item.padding = UIEdgeInsetsMake(3.0f, 5.0f, 1.0f, 2.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(item.padding.left);
        expect(view1.frame.origin.y).to.equal(item.padding.top);
        expect(view1.frame.size.width).to.equal(container.frame.size.width - item.padding.left - item.padding.right);
        expect(view1.frame.size.height).to.equal(container.frame.size.height - item.padding.top - item.padding.bottom);
        
    });
    
    it(@"should apply padding on an item with fixed size", ^{
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(30.0f, 30.0f);
        item.padding = UIEdgeInsetsMake(3.0f, 5.0f, 1.0f, 2.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(item.padding.left);
        expect(view1.frame.origin.y).to.equal(item.padding.top);
        expect(view1.frame.size.width).to.equal(item.size.width - item.padding.left - item.padding.right);
        expect(view1.frame.size.height).to.equal(item.size.height - item.padding.top - item.padding.bottom);
        
    });
    
    it(@"should layout a smaller item with gravity bottom next to a bigger item which causes a bigger row height with gravity bottom", ^{
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(30.0f, 30.0f);
        item.gravity = MKLayoutGravityBottom;
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(20.0f, 50.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(0);
        expect(view1.frame.origin.y).to.equal(item2.size.height - item.size.height);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
        expect(view2.frame.origin.x).to.equal(item.size.width);
        expect(view2.frame.origin.y).to.equal(0);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);
        
    });
    
    it(@"should layout a smaller item with gravity bottom next to a bigger item which causes a bigger row height with gravity bottom", ^{
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(30.0f, 30.0f);
        item.gravity = MKLayoutGravityBottom;
        item.padding = UIEdgeInsetsMake(1.0f, 2.0f, 3.0f, 4.0f);
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(20.0f, 50.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(0 + item.padding.left);
        expect(view1.frame.origin.y).to.equal(item2.size.height - item.size.height + item.padding.top);
        expect(view1.frame.size.width).to.equal(item.size.width - item.padding.left - item.padding.right);
        expect(view1.frame.size.height).to.equal(item.size.height - item.padding.top - item.padding.bottom);
        
        expect(view2.frame.origin.x).to.equal(item.size.width);
        expect(view2.frame.origin.y).to.equal(0);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);
        
    });
    
    
    it(@"should layout a smaller item with gravity bottom next to a bigger item which causes a bigger row height with gravity right in a vertical layout", ^{
        
        layout.orientation = MKLayoutOrientationVertical;
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(30.0f, 100.0f);
        item.gravity = MKLayoutGravityRight;
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(50.0f, 50.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(item2.size.width - item.size.width);
        expect(view1.frame.origin.y).to.equal(0);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
        expect(view2.frame.origin.x).to.equal(0);
        expect(view2.frame.origin.y).to.equal(item.size.height);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);
        
    });
    
    it(@"should apply a padding when it layout a smaller item with gravity bottom next to a bigger item which causes a bigger row height with gravity right in a vertical layout", ^{
        
        layout.orientation = MKLayoutOrientationVertical;
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(30.0f, 100.0f);
        item.gravity = MKLayoutGravityRight;
        item.padding = UIEdgeInsetsMake(1.0f, 2.0f, 3.0f, 4.0f);
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(50.0f, 50.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(item2.size.width - item.size.width + item.padding.left);
        expect(view1.frame.origin.y).to.equal(0 + item.padding.top);
        expect(view1.frame.size.width).to.equal(item.size.width - item.padding.left - item.padding.right);
        expect(view1.frame.size.height).to.equal(item.size.height - item.padding.top - item.padding.bottom);
        
        expect(view2.frame.origin.x).to.equal(0);
        expect(view2.frame.origin.y).to.equal(item.size.height);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);
        
    });
    
    it(@"should apply layout margin", ^{
        
        [layout addSubview:view1];
        layout.margin = UIEdgeInsetsMake(1.0f, 2.0f, 3.0f, 5.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(layout.margin.left);
        expect(view1.frame.origin.y).to.equal(layout.margin.top);
        expect(view1.frame.size.width).to.equal(container.frame.size.width - layout.margin.left - layout.margin.right);
        expect(view1.frame.size.height).to.equal(container.frame.size.height - layout.margin.top - layout.margin.bottom);
        
    });
    
    it(@"should apply layout margin for item with size", ^{
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(30.0f, 30.0f);
        layout.margin = UIEdgeInsetsMake(1.0f, 2.0f, 3.0f, 5.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(layout.margin.left);
        expect(view1.frame.origin.y).to.equal(layout.margin.top);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
    });
    
    it(@"should apply layout margin for item with size and padding", ^{
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(30.0f, 30.0f);
        item.padding = UIEdgeInsetsMake(3.0f, 5.0f, 1.0f, 2.0f);
        layout.margin = UIEdgeInsetsMake(1.0f, 2.0f, 3.0f, 5.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(layout.margin.left + item.padding.left);
        expect(view1.frame.origin.y).to.equal(layout.margin.top + item.padding.top);
        expect(view1.frame.size.width).to.equal(item.size.width - item.padding.left - item.padding.right);
        expect(view1.frame.size.height).to.equal(item.size.height - item.padding.top - item.padding.bottom);
        
    });
    
    it(@"should apply layout margin for two items and consider the layout margin for line breaks for a horizontal layout and keep row if the space perfectly fits", ^{
        
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 170.0f) ];
        
        layout = [[MKFlowLayout alloc] initWithView:container];
        
        layout.margin = UIEdgeInsetsMake(1.0f, 2.0f, 3.0f, 5.0f);
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(100.0f, 30.0f);
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(13.0f, 30.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(layout.margin.left);
        expect(view1.frame.origin.y).to.equal(layout.margin.top);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
        expect(view2.frame.origin.x).to.equal(layout.margin.left + item.size.width);
        expect(view2.frame.origin.y).to.equal(layout.margin.top);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);
        
    });
    
    it(@"should apply layout margin for two items and consider the layout margin for line breaks for a horizontal layout and break the line if the space is exceeded", ^{
        
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 170.0f) ];
        
        layout = [[MKFlowLayout alloc] initWithView:container];
        
        layout.margin = UIEdgeInsetsMake(1.0f, 2.0f, 3.0f, 5.0f);
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(100.0f, 30.0f);
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(14.0f, 30.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(layout.margin.left);
        expect(view1.frame.origin.y).to.equal(layout.margin.top);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
        expect(view2.frame.origin.x).to.equal(layout.margin.left);
        expect(view2.frame.origin.y).to.equal(layout.margin.top + item.size.height);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);
        
    });
    
    it(@"should apply layout margin for two items and consider the layout margin for line breaks for a horizontal layout and keep row if the space perfectly fits", ^{
        
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 170.0f) ];
        
        layout = [[MKFlowLayout alloc] initWithView:container];
        layout.orientation = MKLayoutOrientationVertical;
        
        layout.margin = UIEdgeInsetsMake(1.0f, 2.0f, 3.0f, 5.0f);
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(100.0f, 130.0f);
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(13.0f, 36.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(layout.margin.left);
        expect(view1.frame.origin.y).to.equal(layout.margin.top);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
        expect(view2.frame.origin.x).to.equal(layout.margin.left);
        expect(view2.frame.origin.y).to.equal(layout.margin.top + item.size.height);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);
        
    });
    
    it(@"should apply layout margin for two items and consider the layout margin for line breaks for a horizontal layout and break the line if the space is exceeded", ^{
        
        
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 170.0f) ];
        
        layout = [[MKFlowLayout alloc] initWithView:container];
        layout.orientation = MKLayoutOrientationVertical;
        
        layout.margin = UIEdgeInsetsMake(1.0f, 2.0f, 3.0f, 5.0f);
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(100.0f, 130.0f);
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(13.0f, 37.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(layout.margin.left);
        expect(view1.frame.origin.y).to.equal(layout.margin.top);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
        expect(view2.frame.origin.x).to.equal(layout.margin.left + item.size.width);
        expect(view2.frame.origin.y).to.equal(layout.margin.top);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);

        
    });
    
    it(@"should create 3 rows with items matching the width perfecly for a horizontal layout", ^{
        
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f) ];
        
        layout = [[MKFlowLayout alloc] initWithView:container];
        layout.orientation = MKLayoutOrientationHorizontal;
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(100.0f, 200.0f);
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(100.0f, 200.0f);

        MKFlowLayoutItem *item3 = [layout addSubview:view3];
        item3.size = CGSizeMake(100.0f, 200.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(0.0f);
        expect(view1.frame.origin.y).to.equal(0.0f);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
        expect(view2.frame.origin.x).to.equal(0.0f);
        expect(view2.frame.origin.y).to.equal(item.size.height);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);
        
        expect(view3.frame.origin.x).to.equal(0.0f);
        expect(view3.frame.origin.y).to.equal(item.size.height + item2.size.height);
        expect(view3.frame.size.width).to.equal(item3.size.width);
        expect(view3.frame.size.height).to.equal(item3.size.height);
        
    });

    it(@"should create 3 columns with items matching the height perfecly for a vertical layout", ^{
        
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f) ];
        
        layout = [[MKFlowLayout alloc] initWithView:container];
        layout.orientation = MKLayoutOrientationVertical;
        
        MKFlowLayoutItem *item = [layout addSubview:view1];
        item.size = CGSizeMake(200.0f, 100.0f);
        
        MKFlowLayoutItem *item2 = [layout addSubview:view2];
        item2.size = CGSizeMake(200.0f, 100.0f);
        
        MKFlowLayoutItem *item3 = [layout addSubview:view3];
        item3.size = CGSizeMake(200.0f, 100.0f);
        
        [layout layout];
        
        expect(view1.frame.origin.x).to.equal(0.0f);
        expect(view1.frame.origin.y).to.equal(0.0f);
        expect(view1.frame.size.width).to.equal(item.size.width);
        expect(view1.frame.size.height).to.equal(item.size.height);
        
        expect(view2.frame.origin.x).to.equal(item.size.width);
        expect(view2.frame.origin.y).to.equal(0.0f);
        expect(view2.frame.size.width).to.equal(item2.size.width);
        expect(view2.frame.size.height).to.equal(item2.size.height);
        
        expect(view3.frame.origin.x).to.equal(item.size.width + item2.size.width);
        expect(view3.frame.origin.y).to.equal(0.0f);
        expect(view3.frame.size.width).to.equal(item3.size.width);
        expect(view3.frame.size.height).to.equal(item3.size.height);
        
    });
    
});

SpecEnd
