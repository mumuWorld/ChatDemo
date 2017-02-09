//
//  ServiceViewController.m
//  0204_customerService
//
//  Created by YangJie on 2017/2/4.
//  Copyright © 2017年 YangJie. All rights reserved.
//

#import "ServiceViewController.h"
#import "Common.h"
#import "UIView+Common.h"
#import "BottomView.h"
#import "ChatTableViewCell.h"
#import "ChatInfo.h"
#import "AVAudioTools.h"
#import "RecordVoiceView.h"
#import "FMDBTools.h"
#import "AVAudioPlayerTools.h"
#import "TopView.h"

#import <AVFoundation/AVFoundation.h>

@interface ServiceViewController ()<BottomViewDelegate,UITableViewDelegate,UITableViewDataSource,ChataTableViewCellDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,AVAudioToolsDelegate,TopViewDelegate>
@property (nonatomic,strong) UILabel *changeTitle;
@property (nonatomic,strong) UIView *connectView;//联系方式view
@property (nonatomic,strong) Common *commonInstance;
@property (nonatomic,strong) UILabel *contactWay;//联系方式title
@property (nonatomic,strong) NSUserDefaults *userDefaults;//userDefaults
@property (nonatomic,assign) BOOL isGetContactWay;
@property (nonatomic,copy)   NSString *userContactWay;
@property (nonatomic,strong) UIButton *addConnectBtn;
@property (nonatomic,strong) TopView *topView;           //顶部view
@property (nonatomic,strong) BottomView *bottomView;     //底部输入栏

@property (nonatomic,strong) UITableView *chatContentView;//聊天内容
@property (nonatomic,strong) NSMutableArray *chatMessageArray;
@property (nonatomic,strong) UIAlertController *pickImageController;//图片选择器
@property (nonatomic,strong) UIImagePickerController *ipc;

@property (nonatomic,strong) AVAudioTools *avAudioTools;
@property (nonatomic,assign) CGPoint tempPoint;
@property (nonatomic,strong) RecordVoiceView *recordVoiceView;//录音动画view.

@property (nonatomic,strong) FMDBTools *fmdbTools;

/** 录音 */
@property (nonatomic, strong) AVAudioRecorder *recorder;

/** 播放 */
@property (nonatomic, strong) AVAudioPlayerTools *playerTools;

/**
 用于显示放大后的图片
 */
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,assign) BOOL isNowPlaying;
@property (nonatomic,strong) UIImageView *animationVoiceView;
@property (nonatomic,copy ) NSString *nowPlayVoice;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation ServiceViewController

    static int flag = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    _isGetContactWay = false;
    _isNowPlaying = true;
    _commonInstance = [Common commonShareInstance];
    _fmdbTools = [FMDBTools FMDBToolsShareInstance];
    [self addNotification];
    
    //预留从本地读取用户联系方式
     _userDefaults = [NSUserDefaults standardUserDefaults];
    
    _userContactWay = [_userDefaults objectForKey:@"contactWay"];
    if (_userContactWay!=nil || _userContactWay != NULL) {
        NSLog(@"获取到string-----%@",_userContactWay);
        _isGetContactWay = true;
    }
    self.view.backgroundColor = ChatColor;

    
    
    [self.view addSubview:self.chatContentView];
    [self scrollToBottomAnimated:NO];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.connectView];
    [self.view addSubview:self.bottomView];
    // Do any additional setup after loading the view.
}
- (void)addnewConnectViewWithText:(NSString *)text
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 44)];
    [_connectView addSubview:title];
    title.text = @"联系方式:";
    title.textColor = [UIColor lightGrayColor];

    _contactWay = [[UILabel alloc] initWithFrame:CGRectMake(90, 0,200,44)];
    [_connectView addSubview:_contactWay];
    _contactWay.text = text;
}
- (void)connectBtnClick:(UIButton *)btn
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"联系方式" message:@"请留下您的联系方式方便我们与您联系" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"电话号码或者邮箱";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        UITextField *text = alert.textFields.firstObject;
        
        if (_changeTitle) {
            NSLog(@"确定---%@",_changeTitle);
            [_changeTitle removeFromSuperview];
            [self addnewConnectViewWithText:text.text];
            _changeTitle = nil;
        } else {
            _contactWay.text = text.text;
        }
        //预留 将用户联系方式  保存到本地
        [self saveUserContactWayWithWay:text.text];
    }];
    confirm.enabled = NO;
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}
// 保存用户偏好设置
- (void)saveUserContactWayWithWay:(NSString *)Way
{
    _userDefaults = [NSUserDefaults standardUserDefaults];
    [_userDefaults setObject:Way forKey:@"contactWay"];
    [_userDefaults synchronize];
}
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = login.text.length > 2;
    }
}
/**
 添加监听事件
 */
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:_bottomView.messageInputField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:_bottomView.messageInputField];
}
- (void)removeNotification
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"messageInputFieldDidEndEditingNotification" object:_bottomView.messageInputField];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:_bottomView.messageInputField];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:_bottomView.messageInputField];
}
#pragma mark -----------------------懒加载所用到的--------------------
- (UIAlertController *)pickImageController
{
    if (!_pickImageController) {
        _pickImageController = [UIAlertController alertControllerWithTitle:@"请选择一张图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *system = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getImageFromSystemWithStyle:ImageChooseFromSystem];
        }];
        UIAlertAction *shoot = [UIAlertAction actionWithTitle:@"拍摄一张" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getImageFromSystemWithStyle:ImageChooseFromShoot];
        }];
        [_pickImageController addAction:cancel];
        [_pickImageController addAction:system];
        [_pickImageController addAction:shoot];
    }
    return _pickImageController;
}
/**
 懒加载
 @return connectView
 */
- (UIView *)connectView
{
    if (!_connectView) {
        _connectView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        if (!_isGetContactWay) {
            _changeTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 44)];
            _changeTitle.text = @"请留下您的联系方式";
            [_connectView addSubview:_changeTitle];
            
        } else {
            [self addnewConnectViewWithText:_userContactWay];
        }
        _addConnectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 44, 44)];
        _addConnectBtn.backgroundColor = [UIColor greenColor];
        [_addConnectBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_addConnectBtn addTarget:self action:@selector(connectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_connectView addSubview:_addConnectBtn];
        _connectView.backgroundColor = WhiteColor;
    }
    return _connectView;
}
- (UITableView *)chatContentView
{
    if (!_chatContentView) {
        _chatContentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-44-64-44)];
        _chatContentView.delegate = self;
        _chatContentView.dataSource = self;
        _chatContentView.backgroundColor = [UIColor clearColor];
        _chatContentView.backgroundView.backgroundColor = ChatColor;
        _chatContentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _chatContentView;
}
- (TopView *)topView
{
    if (!_topView) {
        _topView = [[TopView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,64)];
        _topView.delegate = self;
    }
    return _topView;
}
- (BottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
        _bottomView.delegate = self;
        self.inputType = InputTypeText;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInputEnding:) name:@"messageInputFieldDidEndEditingNotification" object:_bottomView.messageInputField];
        
    }
    return _bottomView;
}
- (NSMutableArray *)chatMessageArray
{
    if (_chatMessageArray == nil) {
//        _chatMessageArray = [NSMutableArray new];
//        ChatInfo * chat1 = [[ChatInfo alloc] init];
//        chat1.messageSenderType = MessageSenderByUser;
//        chat1.messageType = MessageTypeText;
//        chat1.chatText = @"111111111111113333333333333333333333333333333333333333333";
////        chat1.imageSmall = [UIImage imageNamed:@"WechatIMG4e"];
////        ChatCellFrame  *f1 = [[ChatCellFrame alloc] init];
////        f1.chatInfo = chat1;
//        
//        [_chatMessageArray addObject:chat1];
//        ChatInfo * chat2 = [[ChatInfo alloc] init];
//        chat2.messageSenderType = MessageSenderByUser;
//        chat2.messageType = MessageTypeText;
//        chat2.chatText = @"1112222121111111111";
////        chat2.imageSmall = [UIImage imageNamed:@"WechatIMG4e"];
//        [_chatMessageArray addObject:chat2];
//        ChatInfo * chat3 = [[ChatInfo alloc] init];
//        chat3.messageSenderType = MessageSenderByUser;
//        chat3.messageType = MessageTypeText;
//        chat3.chatText = @"1111111113333333311111";
////        chat3.imageSmall = [UIImage imageNamed:@"WechatIMG4e"];
//        [_chatMessageArray addObject:chat3];
//        ChatInfo *chat4 =[[ChatInfo alloc] init];
//        chat4.messageSenderType = MessageSenderByUser;
//        chat4.messageType = MessageTypeImage;
//        chat4.chatText = @"1111111113333333311111";
//         UIImage *image = [UIImage imageNamed:@"i心上海.JPG"];
//        chat4.imageSmall = image;
//        [_chatMessageArray addObject:chat4];

       _chatMessageArray = [_fmdbTools recordList];
        
    }
    ChatInfo *chat5 =[[ChatInfo alloc] init];
    chat5.messageSenderType = MessageSenderByService;
    chat5.messageType = MessageTypeText;
    chat5.chatText = @"111111111111113333333333333333333333333333333333333333333";
    [_chatMessageArray addObject:chat5];
    return _chatMessageArray;
}
- (RecordVoiceView *)recordVoiceView
{
    if (!_recordVoiceView) {
        _recordVoiceView = [[RecordVoiceView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _recordVoiceView.center = CGPointMake(SCREEN_WIDTH *0.5, SCREEN_HEIGHT *0.5);
    }
    return _recordVoiceView;
}
- (void)setRecordViewType:(RecoredViewType)recordViewType
{
    self.recordVoiceView.cancelView.hidden = !recordViewType;
    self.recordVoiceView.warningLabel.hidden = !recordViewType;
    self.recordVoiceView.hintLabel.hidden = recordViewType;
    self.recordVoiceView.MICImageView.hidden = recordViewType;
    self.recordVoiceView.volumeView.hidden = recordViewType;
}
- (void)setInputType:(InputType)inputType
{
    BOOL type = flag;
    self.bottomView.keyboardInput.hidden = !type;
    self.bottomView.longPressVoice.hidden = !type;
    self.bottomView.VoiceInput.hidden = type;
    self.bottomView.messageInputField.hidden = type;
}
#pragma mark -----------------------delegate--------------------
#pragma mark ------------底部按钮tag-----
- (void)BottomViewDelegateWithButtonTag:(NSInteger)btnTag
{
    NSLog(@"进入bottom delegate tag=%li",btnTag);
    switch (btnTag) {
        case 1:
            NSLog(@"_keyboardInput click");
            flag = 0;
            self.inputType = flag;
            break;
        case 2:
            NSLog(@"_VoiceInput click");
            flag = 1;
            self.inputType = flag;
            break;
        case 3:
            NSLog(@"_chooseImage click");
            [self presentViewController:self.pickImageController animated:YES completion:nil];
            break;
        case 4:
            NSLog(@"_longPressVoice click");
            
            break;
            
        default:
            break;
    }
}
#pragma mark -------长按录音----------
- (void)LongPressVoiceBtnDelegateWithGesture:(UILongPressGestureRecognizer *)gesture
{
    _avAudioTools = [AVAudioTools AVAudioToolsShareInstance];
    _avAudioTools.delegate = self;
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        NSLog(@"识别长按手势");
        self.recordViewType = RecoredViewRecording;
        [self.view addSubview:self.recordVoiceView];
        [_avAudioTools startRecordWithNumber:[self getMessageArrayCountID]];
        
    } else if ([gesture state] == UIGestureRecognizerStateEnded){
        [self.recordVoiceView removeFromSuperview];
        [_avAudioTools stopRecord];
        NSLog(@"Ended");
    } else if ([gesture state] == UIGestureRecognizerStateChanged){
        NSLog(@"Changed");
        CGPoint point = [gesture locationInView:self.view];
        if (point.y < _tempPoint.y - 10) {
             NSLog(@"松开手指，取消发送");
            _avAudioTools.isCancelSend = true;
            self.recordViewType = RecoredViewCancel;
            if (!CGPointEqualToPoint(point, _tempPoint) && point.y < _tempPoint.y - 8) {
                _tempPoint = point;
            }
        } else if (point.y > _tempPoint.y + 10) {
            NSLog(@"手指上滑，取消发送");
            _avAudioTools.isCancelSend = false;
            self.recordViewType = RecoredViewRecording;
            if (!CGPointEqualToPoint(point, _tempPoint) && point.y > _tempPoint.y + 8) {
                _tempPoint = point;
            }
        }
        
        NSLog(@"%@      %@", NSStringFromCGPoint(point), NSStringFromCGPoint(_tempPoint));
    } else if ([gesture state] == UIGestureRecognizerStateCancelled){
        NSLog(@"Cancelled");
    }
}
#pragma mark -------选取照片完成
/**
 从相册取完照片

 @param picker 选择
 @param info 信息
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    ChatInfo *c1 = [[ChatInfo alloc] initWithImage:info[UIImagePickerControllerOriginalImage] WithNumber:[self getMessageArrayCountID]];
    [self chatMessageArrayAddChatInfo:c1];
    
    // 设置图片
//    self.imageView.image = info[UIImagePickerControllerOriginalImage];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 使contentTextField聚焦变成第一响应者
    [self.bottomView.messageInputField resignFirstResponder];
    
}
#pragma mark -------cell高度---
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatInfo * chatInfo= self.chatMessageArray[indexPath.row];
//        NSLog(@"height = %f",[ChatTableViewCell tableHeightWithModel:chatInfo]);

    return [ChatTableViewCell tableHeightWithModel:chatInfo];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
    [self.bottomView.messageInputField resignFirstResponder];
    
}
- (void)pictureViewBtnClickDelegateWithBtn:(UIButton *)btn
{
    [self.bottomView.messageInputField resignFirstResponder];
     _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backgroundView.backgroundColor = BlackColor;
    [self.view addSubview:_backgroundView];
    UIImage *image = btn.currentImage;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    
//    imageView.clipsToBounds = YES;
    [_backgroundView addSubview:imageView];
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickImage:)];
    [_backgroundView addGestureRecognizer:singleTap];
    [self shakeToShow:_backgroundView];
}
- (void)chatTableViewDelegateWithGestureRecognizer:(UITapGestureRecognizer *)gesture
{
    UILabel *label = [gesture.view.subviews objectAtIndex:1];
    if (![_nowPlayVoice isEqualToString:label.text]) {
        _nowPlayVoice = label.text;
        if ([_animationVoiceView isAnimating]) {
            [_timer invalidate];
            [_animationVoiceView stopAnimating];
        }
        _isNowPlaying = true;
    }
    _timer = nil;
    _animationVoiceView = [gesture.view.subviews lastObject];
    
    _playerTools = [[AVAudioPlayerTools alloc] initWithUrl:label.text];
    if (_isNowPlaying) {
        
        [_animationVoiceView startAnimating];
        _timer = [NSTimer scheduledTimerWithTimeInterval:[_playerTools startPlayAudio] repeats:NO block:^(NSTimer * _Nonnull timer) {
            [_animationVoiceView stopAnimating];
        }];

        _isNowPlaying = false;
    } else {
        [_playerTools stopPlayAudio];
        [_animationVoiceView stopAnimating];
        _isNowPlaying = true;
    }
   
}
- (void)topViewDelegateBackBtnClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"返回view");
        [self removeNotification];
    }];
}
- (void)avAudioToolsDelegateWith:(ChatInfo *)chatInfo
{
    [self chatMessageArrayAddChatInfo:chatInfo];
}
- (void)avAudioChangeVolumeImageWith:(int)volume
{
    self.recordVoiceView.volumeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"volume%i",volume]];
}
#pragma mark -----------------------TableViewDatasource--------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatMessageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *cell = [ChatTableViewCell cellWithTableView:tableView WithIndex:indexPath];
    cell.delegate = self;
    cell.chatInfo = self.chatMessageArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = ChatColor;
    return cell;
}
#pragma mark -----------------------noticfication--------------------
- (void)userInputEnding:(NSNotification *)noticfication
{
    NSString *userInput = [noticfication.userInfo objectForKey:@"messageInputField"];
    NSLog(@"user编辑完成=%@",userInput);
     [self.bottomView.messageInputField resignFirstResponder];
    ChatInfo *chatinfo = [[ChatInfo alloc] initWithMessage:userInput];
    self.bottomView.messageInputField.text = @"";
    [self chatMessageArrayAddChatInfo:chatinfo];

}

#pragma mark ---- 根据键盘高度将当前视图向上滚动同样高度
///键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    [self scrollToBottomAnimated:NO];
    _addConnectBtn.enabled = NO;
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = kbHeight;
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.bottomView.frame = CGRectMake(0.0f, SCREEN_HEIGHT-44-offset, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
            self.chatContentView.frame = CGRectMake(0.0f, 64+44-offset, self.chatContentView.frame.size.width, self.chatContentView.frame.size.height);
        }];
    }
}
#pragma mark ---- 当键盘消失后，视图需要恢复原状
///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    _addConnectBtn.enabled = YES;
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-44, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
        self.chatContentView.frame = CGRectMake(0.0f, 64+44, self.chatContentView.frame.size.width, self.chatContentView.frame.size.height);
    }];
}
#pragma mark ------------------------工具方法------------------
- (void)chatMessageArrayAddChatInfo:(ChatInfo *)chatInfo
{
    [_fmdbTools addRecordWithChatInfo:chatInfo];
    _chatMessageArray = [_fmdbTools recordList];
    [self.chatContentView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_chatMessageArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    [self scrollToBottomAnimated:NO];
}
- (void)getImageFromSystemWithStyle:(ImageChoooseType)type
{
  
    if (type== ImageChooseFromSystem) {
        // 1.判断相册是否可以打开
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
        // 2. 创建图片选择控制器
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
      
    } else if(type == ImageChooseFromShoot) {
         if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
        // 2. 创建图片选择控制器
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    _ipc.allowsEditing = YES;
    // 4.设置代理
    _ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:_ipc animated:YES completion:nil];
}

/**
 tableview滚动到最后

 @param animated 动画
 */
- (void)scrollToBottomAnimated:(BOOL)animated
{//这里一定要设置为NO，动画可能会影响到scrollerView，导致增加数据源之后，tableView到处乱跳
    if (self.chatMessageArray.count == 0) {
        return;
    }
     [self.chatContentView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatMessageArray.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    //    [self.chatContentView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_chatMessageArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
}
- (void)whenClickImage:(UITapGestureRecognizer *)guesture
{
    NSLog(@"%s",__func__);
    [_backgroundView removeFromSuperview];
}
//放大过程中出现的缓慢动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
- (NSUInteger)getMessageArrayCountID
{
    if (self.chatMessageArray.count == 0) {
        return 1;
    }
    ChatInfo *c1 = [self.chatMessageArray lastObject];
    return c1.ID +1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
