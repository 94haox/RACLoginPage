//
//  LoginViewController.m
//  loginPage
//
//  Created by 吴涛 on 15/12/23.
//  Copyright © 2015年 吴涛. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveCocoa.h>
#import <Masonry.h>



@interface LoginViewController ()

@property (nonatomic, strong) UILabel *loginTipLabel;

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UILabel *userNameLB;

@property (nonatomic, strong) UITextField *userNameTF;

@property (nonatomic, strong) UILabel *passWordLB;

@property (nonatomic, strong) UITextField *passWordTF;

// 用于显示进度,用UIProgressView 也可以,主要看个人喜好;
@property (nonatomic, strong) UILabel *intactProgress;



@end

@implementation LoginViewController


#pragma mark - life

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
  [self.view addSubview:self.loginTipLabel];
  [self.view addSubview:self.intactProgress];
  [self.view addSubview:self.userNameLB];
  [self.view addSubview:self.userNameTF];
  [self.view addSubview:self.passWordLB];
  [self.view addSubview:self.passWordTF];
  [self.view addSubview:self.loginButton];
  
  [self addConstraints];
  [self addobservers];
    // Do any additional setup after loading the view.
}

#pragma mark - addObservers && addConstraints

static CGFloat buttonW = 150;

- (void)addobservers{
  
  // 假设账号是11位, 密码是6位, 账号密码位数不对时无法进行登陆操作
  

  @weakify(self);
  
  // 根据userName 是否是11位来改变 passTF的enable;
  [self.userNameTF.rac_textSignal subscribeNext:^(NSString *userName) {
    @strongify(self);
    self.passWordTF.enabled = userName.length == 11 ? YES : NO;
    
  }];
  
  // 根据pass enable 来改变背景颜色
  [RACObserve(self.passWordTF, enabled) subscribeNext:^(NSNumber *x) {
    @strongify(self);
    self.passWordTF.backgroundColor = [x boolValue] ? [UIColor whiteColor] : [UIColor yellowColor];
  }];
  
  // 根据 pass 是否是6位来 决定是否可以进行Login操作
  [[[self.passWordTF.rac_textSignal
       filter:^BOOL(NSString  *value) {
         if (value.length == 0) {
           @strongify(self);
           [self.intactProgress mas_updateConstraints:^(MASConstraintMaker *make) {
             make.width.mas_equalTo(0);
           }];
         }
      return value.length > 0 && value.length < 7;
    }]
      map:^id(NSString  *value) {
      return @(value.length);
    }]
     subscribeNext:^(NSNumber *x) {
      @strongify(self);
      [self.intactProgress mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonW*([x floatValue] / 6.f));
      }];
    }];
  
  
  
  
}

// 加约束
- (void)addConstraints{
  [self.loginTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(150);
    make.centerX.equalTo(self.view);
  }];
  
  
  [self.userNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view).offset(60);
    make.top.equalTo(self.loginTipLabel.mas_bottom).offset(80);
  }];
  
  [self.userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.userNameLB.mas_right).offset(10);
    make.centerY.equalTo(self.userNameLB);
  }];
  
  [self.passWordLB mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.userNameLB);
    make.top.equalTo(self.userNameLB.mas_bottom).offset(50);
  }];
  
  [self.passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.passWordLB.mas_right).offset(10);
    make.centerY.equalTo(self.passWordLB);
  }];
  
  [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(self.passWordTF.mas_bottom).offset(80);
    make.width.mas_equalTo(buttonW);
    make.height.mas_equalTo(30);
  }];
  
  
  [self.intactProgress mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.left.height.equalTo(self.loginButton);
    make.width.mas_equalTo(0);
  }];
  
  
  
  
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - setter && getter

// 进度条
- (UILabel *)intactProgress{
  if (_intactProgress == nil) {
    _intactProgress = [UILabel new];
    _intactProgress.backgroundColor = [UIColor yellowColor];
  }
  return _intactProgress;
}


// 密码填写
- (UITextField *)passWordTF{
  if (_passWordTF == nil) {
    _passWordTF = [UITextField new];
    _passWordTF.placeholder = @"请出入密码";
  }
  return _passWordTF;
}

// 用户名填写
- (UITextField *)userNameTF{
  if (_userNameTF == nil) {
    _userNameTF = [UITextField new];
    _userNameTF.placeholder = @"请输入账号";
  }
  return _userNameTF;
}


// 密码
- (UILabel *)passWordLB{
  if (_passWordLB == nil) {
    _passWordLB = [UILabel new];
    _passWordLB.text = @"密码";
  }
  return _passWordLB;
}


// 用户名
- (UILabel *)userNameLB{
  if (_userNameLB == nil) {
    _userNameLB = [UILabel new];
    _userNameLB.text = @"用户名";
  }
  return _userNameLB;
}


// 登陆
- (UILabel *)loginTipLabel{
  if (_loginTipLabel == nil) {
    _loginTipLabel = [UILabel new];
    _loginTipLabel.text = @"登陆界面";
  }
  return _loginTipLabel;
}

// 登陆按钮
- (UIButton *)loginButton{
  if (_loginButton == nil) {
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  }
  return _loginButton;
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
