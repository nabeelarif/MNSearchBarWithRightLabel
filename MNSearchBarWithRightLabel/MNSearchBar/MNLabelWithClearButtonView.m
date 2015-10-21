//
//  MNLabelWithClearButtonView.m
//  MNSearchBarWithRightLabel
//
//  Created by Nabeel Arif on 10/18/15.
//  Copyright © 2015 Nabeel. All rights reserved.
//

#import "MNLabelWithClearButtonView.h"
@interface MNLabelWithClearButtonView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonWidth;
@end

@implementation MNLabelWithClearButtonView

+ (instancetype)instantiateFromNib
{
//    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
//    return [views firstObject];
    return [MNLabelWithClearButtonView new];
}

-(instancetype)init
{
    self =[super init];
    if (self) {
        [self setUp];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}
-(void)setUp{
    if (!_btnClear) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [btn setImage:[UIImage imageNamed:@"icn_clear_text.png"] forState:UIControlStateNormal];
        [self addSubview:btn];
        _btnClear = btn;
    }
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = nil;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14];
        [label sizeToFit];
        self.label = label;
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = _label.font.lineHeight;
    [_label sizeToFit];
    height = (_btnClear && height<_btnClear.frame.size.height)?_btnClear.frame.size.height:height;
    CGSize size = [_label sizeThatFits:CGSizeMake(CGFLOAT_MAX, _label.font.lineHeight)];
    CGRect frame = _label.frame;
    frame.origin.x = 0;
    frame.origin.y = (height-_label.frame.size.height)/2.0;
    _label.frame = frame;
    if(_btnClear.hidden==NO) {
        frame = _btnClear.frame;
        frame.origin.x = size.width+5;
        frame.origin.y = (height-_btnClear.frame.size.height)/2.0;
        _btnClear.frame = frame;
    }
    [self sizeToFit];
}
-(void)setLabel:(UILabel *)label
{
    _label = label;
    [self addSubview:label];
}
-(void)sizeToFit{
    [super sizeToFit];
    CGRect frame = self.frame;
    
    
    CGFloat height = _label.font.lineHeight;
    height = (_btnClear && height<_btnClear.frame.size.height)?_btnClear.frame.size.height:height;
    CGFloat width = 0;
    CGSize size = [_label sizeThatFits:CGSizeMake(CGFLOAT_MAX, _label.font.lineHeight)];
    width +=size.width;
    if(_btnClear.hidden==NO) {
        width +=_btnClear.frame.size.width+5;
    }
    frame.size.width = width;
    frame.size.height = height;
    
    self.frame = frame;
}
-(void)setShowClearTextButton:(BOOL)showClearTextButton
{
    _showClearTextButton =showClearTextButton;
    if (showClearTextButton) {
        _constraintButtonWidth.constant=25;
        _btnClear.hidden=NO;
    }else{
        _constraintButtonWidth.constant=0;
        _btnClear.hidden=YES;
    }
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
