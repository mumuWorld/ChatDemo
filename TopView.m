//
//  TopView.m
//  0204_customerService
//
//  Created by YangJie on 2017/2/4.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import "TopView.h"
#import "Common.h"

@interface TopView ()
@property (nonatomic,strong) UIView *stateView;
@property (nonatomic,strong) UIView *lableView;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIButton *backBtn;

@end
@implementation TopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.stateView = [[UIView alloc] init];
        [self addSubview:_stateView];
        
        self.lableView = [[UIView alloc] init];
        [self addSubview:_lableView];
        
        self.title = [[UILabel alloc] init];
        [_lableView addSubview:_title];
        
        self.backBtn = [[UIButton alloc] init];
        [_lableView addSubview:_backBtn];
    }
    return self;
}
- (void)layoutSubviews
{
    _stateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    _stateView.backgroundColor = CommonColor;
    
    _lableView.frame = CGRectMake(0, 20, SCREEN_WIDTH, NAV_ITEM_HEIGHT);
    _lableView.backgroundColor = CommonColor;
    
    _title.frame = CGRectMake(0,0,50,NAV_ITEM_HEIGHT);
    _title.textAlignment = NSTextAlignmentCenter;
    _title.center = CGPointMake(SCREEN_WIDTH *0.5, NAV_ITEM_HEIGHT*0.5);
    _title.text = @"反馈";
    _title.textColor = WhiteColor;
    
    _backBtn.frame = CGRectMake(10, 0, 40, 44);
    _backBtn.backgroundColor = CommonColor;
    [_backBtn setTitle:@"返回" forState: UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(topViewDelegateBackBtnClick:)]) {
        [self.delegate topViewDelegateBackBtnClick:btn];
    }
}
/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/

@end
