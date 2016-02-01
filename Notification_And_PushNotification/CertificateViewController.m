//
//  CertificateViewController.m
//  Notification_And_PushNotification
//
//  Created by 邱少依 on 16/2/1.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "CertificateViewController.h"

@interface CertificateViewController ()

@end

@implementation CertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addUI];
}

- (void)addUI{
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = self.view.bounds;
    textView.scrollEnabled = YES;
    textView.font = [UIFont systemFontOfSize:19];
    textView.textColor = [UIColor greenColor];
    [self.view addSubview:textView];

    NSString *labelStr = [NSString stringWithFormat:@"1.iOS常用的证书包括开发证书(普通开发证书和推送证书)和发布证书（普通发布证书、推送证书、Pass Type ID证书、站点发布证书、VoIP服务证书、苹果支付证书），根据需要来选择\n 2.iOS常用的标识包括 应用标识（iOS应用的Bundle Identifier）和设备标识（UDID,用于标识每一台硬件设备的标示）\n 3.配置文件（PP文件）包括开发和发布两类配置文件\n 4.秘钥：在申请开发证书时必须要首先提交一个秘钥请求文件，对于生成秘钥请求文件的mac，如果要做开发则只需要下载证书和配置简介即可开发。\n但是如果要想在其他机器上做开发则必须将证书中的秘钥导出（导出之后是一个.p12文件），然后导入其他机器。\n同时对于类似于推送服务器端应用如果要给APNs发送消息，同样需要使用.p12秘钥文件，并且这个秘钥文件需要是推送证书导出的对应秘钥。"];
    textView.text = labelStr;
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
