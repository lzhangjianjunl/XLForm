//
//  PredicateFormViewController.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
// 
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

NSString *const kPred = @"pred";
NSString *const kPredDep = @"preddep";
NSString *const kPredDep2 = @"preddep2";

#import "PredicateFormViewController.h"


@implementation PredicateFormViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeForm];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}


- (void)initializeForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    XLFormRowDescriptor * pred, *pred2, *pred3;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Predicates"];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Independent rows"];
    [form addFormSection:section];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPredDep rowType:XLFormRowDescriptorTypeText title:@"Text"];
    [row.cellConfigAtConfigure setObject:@"Type disable" forKey:@"textField.placeholder"];
    pred = row;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPredDep2 rowType:XLFormRowDescriptorTypeInteger title:@"Integer"];
    pred2 = row;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"switch" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Boolean"];
    row.value = @1;
    pred3 = row;
    [section addFormRow:row];
    
    pred2.hiddenPredicate  = [NSString stringWithFormat:@"$%@  == 0", pred3];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Dependent rows"];
    section.footerTitle = @"PredicateFormViewController.h\nType disable in the textfield, a number between 18 and 60 in the integer field or use the switch to disable the last row. By doing all three the last section will hide.\nThe";
    [form addFormSection:section];
    
    // Predicate Disabling
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPred rowType:XLFormRowDescriptorTypeDateInline title:@"Disabled"];
    row.value = [NSDate new];
    [section addFormRow:row];
    
    [row setDisablingPredicate://[NSString stringWithFormat:@"$%@ contains[c] \"%@\" OR (($%@ > 18) AND ($%@ < 60)) OR ($%@.value == 0)", pred,  @"disable", pred2, pred2, pred3]];
    [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"($%@.value contains[c] %%@) OR (($%@.value > 18) AND ($%@.value < 60)) OR ($%@.value == 0)", pred, pred2, pred2, pred3],  @"disable"]];

    section.hiddenPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"($%@.value contains[c] %%@) AND (($%@.value > 18) AND ($%@.value < 60)) AND ($%@.value == 0)", pred, pred2, pred2, pred3],  @"disable"];
    self.form = form;
}


@end
