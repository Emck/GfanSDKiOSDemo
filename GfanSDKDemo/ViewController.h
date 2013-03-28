//
//  ViewController.h
//  GfanSDKDemo
//
//  Created by Emck on 2/1/13.
//  Copyright (c) 2013 mAPPn. All rights reserved.
//

#import <UIKit/UIKit.h>

//------------------------GfanSDK for iOS------------- Add -----
#import "GfanSDK.h"
// 主窗口需增加GfanSDKDelegate协议
// 而UITextFieldDelegate仅为本Demo演示使用,正式接入可忽略
//------------------------GfanSDK for iOS------------- End -----

@interface ViewController : UIViewController <UITextFieldDelegate,GfanSDKDelegate>
{
    IBOutlet UITextView *MessageView;
    IBOutlet UITextField *MoneyField;    
}

- (IBAction)onClickLoginButton:(id)sender;                  // 登录接口（非快速注册登陆）调用演示
- (IBAction)onClickLoginQuickRegisterButton:(id)sender;     // 登录接口（支持快速注册登陆）调用演示
- (IBAction)onClickRenameButton:(id)sender;                 // 完善账号接口调用演示
- (IBAction)onClickLogoutButton:(id)sender;                 // 退出登陆接口调用演示
- (IBAction)onClickStatusButton:(id)sender;                 // 登录状态检查接口调用演示
- (IBAction)onClickPayButton:(id)sender;                    // 支付接口调用演示
- (IBAction)onClickBuyInAppButton:(id)sender;               // 苹果In-App支付接口调用演示

- (IBAction)onClickCleanButton:(id)sender;                  // 清除本Demo演示中的Log信息

@end