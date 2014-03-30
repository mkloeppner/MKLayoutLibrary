//
//  MKLayoutLibraryLayoutIntegrationTests.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 3/30/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "MKLayoutLibrary.h"

#define EXP_SHORTHAND
#import "Expecta.h"


SpecBegin(MKLayoutLibraryIntegrationSpecification)

describe(@"MKLayoutLibraryIntegration", ^{
    
    __block MKLayout *layout;
    __block UIView *container;
    
    __block UIView *subview1;
    __block UIView *subview2;
    __block UIView *subview3;
    __block UIView *subview4;
    
    beforeEach(^{
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 100.0)];
        layout = [[MKLayout alloc] initWithView:container];
        
        subview1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview3 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview4 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    });
    
//    
//    it(@"should calculate the right amount of horizontal and vertical separators in a horizontal layout with a vertical sublayout which is a sublayout of stacklayout", ^{
//        layout = [[MKStackLayout alloc] initWithView:container];
//        layout.insertBorders = YES;
//        
//        MKLinearLayout *linearLayout = [[MKLinearLayout alloc] init];
//        linearLayout.orientation = MKLayoutOrientationVertical;
//        
//        [linearLayout addSubview:subview1];
//        
//        MKLinearLayout *sublayout1 = [[MKLinearLayout alloc] init];
//        sublayout1.orientation = MKLayoutOrientationHorizontal;
//        
//        [sublayout1 addSubview:subview2];
//        
//        [sublayout1 addSubview:subview3];
//        
//        [sublayout1 addSubview:subview4];
//        
//        [linearLayout addSublayout:sublayout1];
//        
//        [layout addSublayout:linearLayout];
//        
//        expect([layout numberOfSeparatorsForSeparatorOrientation:MKLayoutOrientationVertical]).to.equal(2);
//        expect([layout numberOfSeparatorsForSeparatorOrientation:MKLayoutOrientationHorizontal]).to.equal(1);
//        
//    });
//    
//    it(@"should calculate the right amount of horizontal and vertical separators in a vertical layout with a horizontal sublayout which is a sublayout of stacklayout", ^{
//        
//        layout = [[MKStackLayout alloc] initWithView:container];
//        layout.insertBorders = YES;
//        
//        MKLinearLayout *linearLayout = [[MKLinearLayout alloc] init];
//        linearLayout.orientation = MKLinearLayoutOrientationHorizontal;
//        
//        [linearLayout addSubview:subview1];
//        
//        MKLinearLayout *sublayout1 = [[MKLinearLayout alloc] init];
//        sublayout1.orientation = MKLinearLayoutOrientationVertical;
//        
//        [sublayout1 addSubview:subview2];
//        
//        [sublayout1 addSubview:subview3];
//        
//        [sublayout1 addSubview:subview4];
//        
//        [linearLayout addSublayout:sublayout1];
//        
//        [layout addSublayout:linearLayout];
//        
//        expect([layout amountOfSeparatorsWithOrientation:MKLinearLayoutOrientationVertical]).to.equal(1);
//        expect([layout amountOfSeparatorsWithOrientation:MKLinearLayoutOrientationHorizontal]).to.equal(2);
//        
//    });
    
});

SpecEnd
