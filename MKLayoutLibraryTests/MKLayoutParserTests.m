//
//  MKLayoutParserSpec.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 6/13/14.
//  Copyright 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "MKLayout.h"

#define EXP_SHORTHAND
#import "Expecta.h"

#define MOCKITO_SHORTHAND
#import "OCMockito.h"

#import "MKLayoutParser.h"

SpecBegin(MKLayoutParser)

describe(@"MKLayoutParser", ^{
    
    __block MKLayoutParser *_parser;
    
    beforeEach(^{
        _parser = [[MKLayoutParser alloc] init];
    });
    
    it(@"should parse a linear layout", ^{
        __autoreleasing NSError *error;
        MKLayout *layout = [_parser parseLayoutFromString:@"<LinearLayout/>" error:&error];
        expect(layout.class).to.equal([MKLinearLayout class]);
    });
    
});

SpecEnd
