//
//  ViewController.m
//  GfanSDKDemo
//
//  Created by Emck on 2/1/13.
//  Copyright (c) 2013 mAPPn. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ViewController.h"

@interface ViewController ()

@end

// 说明
// 1. 请详细阅读本Demo，以及Demo中的说明部分
// 2. 代码注释中出现"GfanSDK for iOS"的部分，Add至End中间的代码必须复制如正式项目,否则会导致支付后无响应（无法回调）
// 3. 不要忘记了AppDelegate.m中的代码和GfanSDKDemo-Info.plist中的URL Types参数
// 4. 苹果的In-App支付在接入前有较多工作量是对苹果开发者账号的设置和发布应用In-App的设定，建议熟悉阅读该网站 http://www.cocoachina.com/special/iap.html
// 5. 苹果的In-App Project Build前,请仔细检查您的签名证书是否与发布的In-App应用开发者证书想匹配，否则无法进入沙箱测试
// 6. 当本Demo能正式跑起来，且可接受支付宝支付、In-App支付后，再移植代码到您的项目中，这样能有效降低接入复杂度


@implementation ViewController
{
    NSInteger Count;                // 用于本Demo的接口调用计数,正式接入可忽略
    
    
    GfanSDKResponse *SDKResponse;   // SDK的状态(用于各接口回调)
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //------------------------GfanSDK for iOS------------- Add -----
    // 此处2个通知必须监听,用于支付宝和苹果In-App支付后的处理
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(GfanSDKAliPayCallBack:) name: @"GfanSDKAliPayNotification" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(GfanSDKApplePayCallBack:) name: @"GfanSDKApplePayNotification" object: nil];
    //------------------------GfanSDK for iOS------------- End -----
    
    MessageView.text = @"说明: \n1.接口调用的返回,均为GfanSDKResponse对象\n2.由于SDK使用了交叉编译,所以请保证调用该SDK的类文件扩展名为.mm\n3.为确保支付宝快捷方式可回调该Demo,请检查GfanSDKDemo-Info.plist中,是否加入了URL Types参数(可参考本Demo,Item 0须与当前Demo的应用名称相符,否则会导致支付宝接口无法回调支付结果)\n4.AppDelegate.m中需插入Gfan iOS SDK相关代码\n5.本SDK需要用到QuartzCore.framework,libz.dylib,libcrypto.a,libssl.a";    
}

//------------------------GfanSDK for iOS------------- Add -----
// 支付宝支付成功回调，
- (void)GfanSDKAliPayCallBack:(NSNotification *)Notify
{
    [[[GfanSDK alloc] init:self Delegate:self CPID:@"iOSTest"] doAliPayChargeCallBack:[Notify object]];
}
// 苹果In-App支付成功回调
- (void)GfanSDKApplePayCallBack:(NSNotification *)Notify
{
    [[[GfanSDK alloc] init:self Delegate:self CPID:@"iOSTest"] doInAppChargeCallBack:[Notify object]];
}
//------------------------GfanSDK for iOS------------- End -----

// 登录接口（非快速注册登陆）调用演示
- (IBAction)onClickLoginButton:(id)sender
{
    [[[GfanSDK alloc] init:self Delegate:self CPID:@"iOSTest"] doLogin];
}

// 登录接口（支持快速注册登陆）调用演示
- (IBAction)onClickLoginQuickRegisterButton:(id)sender
{
    [[[GfanSDK alloc] init:self Delegate:self CPID:@"iOSTest"] doLoginWithQuickRegister];
}

// 完善账号接口调用演示
- (IBAction)onClickRenameButton:(id)sender
{
    [[[GfanSDK alloc] init:self Delegate:self CPID:@"iOSTest"] doRename];
}

// 退出登陆接口调用演示
- (IBAction)onClickLogoutButton:(id)sender
{
    [[[GfanSDK alloc] init:self Delegate:self CPID:@"iOSTest"] doLogout];
}

// 登录状态检查接口调用演示
- (IBAction)onClickStatusButton:(id)sender
{
    [[[GfanSDK alloc] init:self Delegate:self CPID:@"iOSTest"] doVerifyStatus];
}

// 支付接口调用演示
- (IBAction)onClickPayButton:(id)sender
{
    OrderInfoByGfan *Order = [[OrderInfoByGfan alloc]init];
    Order.PayAppKey = @"1043071178";        // 支付Key,请通过机锋开发者后台申请支付Appkey(http://dev.gfan.com/Aspx/DevApp/AskKeyStep1.aspx 须先注册为开发者)
    Order.PayName = @"待支付产品名称";
    Order.PayDesc = @"待支付产品描述";
    Order.PayCoupon = [MoneyField.text integerValue];
    
    [[[GfanSDK alloc] init:self Delegate:self CPID:@"iOSTest"] doPayOrder:Order];
}

// 苹果In-App支付接口调用演示
- (IBAction)onClickBuyInAppButton:(id)sender
{
    OrderInfoByGfan *Order = [[OrderInfoByGfan alloc]init];
    //Order.OrderID = @"1234567890";
    Order.PayAppKey = @"1043071178";        // 支付Key,请通过机锋开发者后台申请支付Appkey(http://dev.gfan.com/Aspx/DevApp/AskKeyStep1.aspx 须先注册为开发者)

    // "Payment12"是In-App支付产品的ID,必须对应为苹果开发者账号发布的In-App产品的ID
    [[[GfanSDK alloc] init:self Delegate:self CPID:@"iOSTest"] doInAppBuyProduct:@"Diamond1" OrderInfo:Order];
}

// 所有接口回调集中在此托管方法,相关文档请参考 GfanSDK.h文件
- (void)GfanSDKCallBack:(id)sender
{
    GfanSDKResponse *Response = (GfanSDKResponse *)sender;
    NSString *message = @"";
    if (Response.isSucceed == TRUE) {
        switch (Response.APIType) {
            case APIdoLogin:
                message = [NSString stringWithFormat:@"%3d 登录接口 成功,返回对象:%@\n",Count,Response.GfanInfo];
                break;
            case APIdoRename:
                message = [NSString stringWithFormat:@"%3d 完善账号接口 成功,返回对象:%@\n",Count,Response.GfanInfo];
                break;
            case APIdoVerifyStatus:
                message = [NSString stringWithFormat:@"%3d 登录状态校验接口 成功,返回对象:%@\n",Count,Response.GfanInfo];
                break;
            case APIdoLogout:
                message = [NSString stringWithFormat:@"%3d 退出登陆接口 成功\n",Count];
                break;
            case APIdoPayOrder:
                message = [NSString stringWithFormat:@"%3d 机锋支付接口 成功,返回对象:%@\n",Count,Response.GfanInfo];
                break;
            case APIdoInAppBuyProduct:
                message = [NSString stringWithFormat:@"%3d 苹果In-App支付接口 成功,返回对象:%@\n",Count,Response.GfanInfo];
                break;
            default:
                break;
        }
    }
    else {
        message = [NSString stringWithFormat:@"%3d !!失败,StatusCode=%d %@\n",Count,Response.StatusCode,Response.StatusMessage];
    }
    
    // 以下代码仅用于本Demo演示,正式接入可忽略
    MessageView.text = [message stringByAppendingString:MessageView.text];
    [MessageView setContentOffset:CGPointMake(0.0, 0.0)];
    Count ++;
}

//以下代码与接入无关
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)onClickCleanButton:(id)sender
{
    MessageView.text = @"";
    Count = 0;
}

// 当用户点击了键盘中的Down按钮时触发(输入完毕时)
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];                       // 隐藏键盘,释放屏幕响应
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end