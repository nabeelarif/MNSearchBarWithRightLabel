//
//  UISearchBar+RightLabel.m
//  MNSearchBarWithRightLabel
//
//  Created by Nabeel Arif on 10/18/15.
//  Copyright © 2015 Nabeel. All rights reserved.
//

#import "UISearchBar+RightLabel.h"
#import "MNLabelWithClearButtonView.h"
#import <objc/runtime.h>

@interface UISearchBar (RightLabelInternal)
@property (nonatomic, strong) MNLabelWithClearButtonView *viewAccessory;
@property (nonatomic, strong) UITextField *tfSearch;
@end

NSString const *kViewAccessory = @"kViewAccessory";
NSString const *kTfSearch = @"kTfSearch";
NSString const *kRightText = @"kRightText";
NSString const *kRightViewMode = @"kRightViewMode";

@implementation UISearchBar (RightLabel)

-(void)configureRightLabel
{
    for (UIView *subView in self.subviews){
        if ([subView isKindOfClass:[UITextField class]])
        {
            self.tfSearch = (UITextField *)subView;
            break;
        }
        for (UIView *ndLeveSubView in subView.subviews){
            
            if ([ndLeveSubView isKindOfClass:[UITextField class]])
            {
                self.tfSearch = (UITextField *)ndLeveSubView;
                break;
            }
            
        }
    }
    UITextField *textField = self.tfSearch;
    if (textField) {
        MNLabelWithClearButtonView *view = [MNLabelWithClearButtonView instantiateFromNib];
        view.label.text = @"Results";
        self.viewAccessory = view;
        [view.btnClear addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
        [view sizeToFit];
        textField.rightView = view;
        self.rightViewMode = UITextFieldViewModeAlways;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:textField];
        [self manageClearTextButton];
    }
}

-(void)clearText{
    UITextField *textField = self.tfSearch;
    if (textField) {
        [textField becomeFirstResponder];
        textField.text = @"";
        [self manageClearTextButton];
    }
}

#pragma mark - Text Field text Change
-(void)textFieldChanged:(NSNotification*)sender{
    if (sender.object==self.tfSearch) {
        [self manageClearTextButton];
    }
}
-(void)manageClearTextButton{
    MNLabelWithClearButtonView *view = self.viewAccessory;
    if (view) {
        
        UITextField *textField = self.tfSearch;
        textField.rightViewMode = self.rightViewMode;
        if (textField.text!=nil && textField.text.length>0) {
            view.showClearTextButton = YES;
        }else{
            view.showClearTextButton = NO;
        }
        [view sizeToFit];
        [self setNeedsLayout];
        [view setNeedsLayout];
    }
}
#pragma mark - Setter & Getter
-(MNLabelWithClearButtonView *)viewAccessory{
    MNLabelWithClearButtonView *view =  (MNLabelWithClearButtonView*)objc_getAssociatedObject(self, &kViewAccessory);
    if (!view) {
        [self configureRightLabel];
        view =  (MNLabelWithClearButtonView*)objc_getAssociatedObject(self, &kViewAccessory);
    }
    return view;
}
-(void)setViewAccessory:(MNLabelWithClearButtonView *)viewAccessory{
    objc_setAssociatedObject(self, &kViewAccessory, viewAccessory, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UITextField *)tfSearch{
    return objc_getAssociatedObject(self, &kTfSearch);
}
-(void)setTfSearch:(UITextField *)tfSearch{
    objc_setAssociatedObject(self, &kTfSearch, tfSearch, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)setRightText:(NSString *)rightText{
    MNLabelWithClearButtonView *view = self.viewAccessory;
    if (view) {
        view.label.text = rightText;
        [self manageClearTextButton];
        objc_setAssociatedObject(self, &kRightText, rightText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
-(NSString *)rightText{
    return objc_getAssociatedObject(self, &kRightText);
}
-(void)setRightViewMode:(UITextFieldViewMode)rightViewMode{
    UITextField *textField = self.tfSearch;
    if (textField) {
        textField.rightViewMode = rightViewMode;
    }
    NSNumber *number = [NSNumber numberWithInt:rightViewMode];
    objc_setAssociatedObject(self, &kRightViewMode, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UITextFieldViewMode)rightViewMode{
    NSNumber *number = objc_getAssociatedObject(self, &kRightViewMode);
    return number.integerValue;
}
@end
