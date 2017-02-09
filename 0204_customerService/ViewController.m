//
//  ViewController.m
//  0204_customerService
//
//  Created by YangJie on 2017/2/4.
//  Copyright © 2017年 YangJie. All rights reserved.
//

//CocoaAsyncSocket
#import "ViewController.h"
#import "ServiceViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *service = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    service.backgroundColor = [UIColor cyanColor];

    [service setTitle:@"点我进入客服界面" forState: UIControlStateNormal];
    
    [service addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:service];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)serviceBtnClick:(UIButton *)btn
{

    ServiceViewController *serviceVC = [[ServiceViewController alloc] init];
    [self presentViewController:serviceVC animated:YES completion:^{
        NSLog(@"进入客服view----");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
