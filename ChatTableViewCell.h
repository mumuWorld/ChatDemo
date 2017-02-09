//
//  ChatTableViewCell.h
//  0204_customerService
//
//  Created by YangJie on 2017/2/4.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatInfo;
@class Common;
@protocol ChataTableViewCellDelegate <NSObject>
@required
- (void)chatTableViewDelegateWithGestureRecognizer:(UITapGestureRecognizer *)gesture;
- (void)pictureViewBtnClickDelegateWithBtn:(UIButton *)btn;
@end

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic,strong) ChatInfo *chatInfo;
@property (nonatomic,strong) Common *common;

@property (nonatomic,strong) UIImageView* voiceAnimationImageView;

@property (nonatomic,weak) id<ChataTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)tableHeightWithModel:(ChatInfo *)chatInfo;

@end
