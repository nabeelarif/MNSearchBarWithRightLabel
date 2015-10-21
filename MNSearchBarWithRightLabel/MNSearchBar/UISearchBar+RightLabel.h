//
//  UISearchBar+RightLabel.h
//  MNSearchBarWithRightLabel
//
//  Created by Nabeel Arif on 10/18/15.
//  Copyright © 2015 Nabeel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (RightLabel)
@property (nonatomic, strong) NSString *rightText;
@property (nonatomic) UITextFieldViewMode rightViewMode;
-(void)configureRightLabel;
@end
