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
        
        container = [[UIView alloc] initWithFrame:(CGRect){100.0f}];
        
        layout = [[MKFlowLayout alloc] initWithView:container];
        
        view1 = [[UIView alloc] initWithFrame:(CGRect){1.0f}];
        view2 = [[UIView alloc] initWithFrame:(CGRect){1.0f}];
        view3 = [[UIView alloc] initWithFrame:(CGRect){1.0f}];
        view4 = [[UIView alloc] initWithFrame:(CGRect){1.0f}];
        
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
    
});

SpecEnd
