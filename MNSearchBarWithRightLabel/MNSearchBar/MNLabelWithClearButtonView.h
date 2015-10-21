//
//  MNLabelWithClearButtonView.h
//  MNSearchBarWithRightLabel
//
//  Created by Nabeel Arif on 10/18/15.
//  Copyright © 2015 Nabeel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNLabelWithClearButtonView : UIView

+ (instancetype)instantiateFromNib;
@property (nonatomic) BOOL showClearTextButton;
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIButton *btnClear;

@end
