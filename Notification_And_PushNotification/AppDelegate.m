//
//  AppDelegate.m
//  Notification_And_PushNotification
//
//  Created by 邱少依 on 16/1/29.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:23/255.0 green:180/255.0 blue:237/255.0 alpha:1]];
    [[UINavigationBar appearance]setBarStyle:UIBarStyleBlack];
    ViewController *mainVC = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
//    本地推送:已经获得发送通知的授权则创建本地通知，否则请求授权

    [self setUpLocalNotification];
//    远程推送
    [self setUpRemoteNotification:application];
    return YES;
}

- (void)setUpLocalNotification {
//  注册用户通知设置后，添加本地通知。
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        [self addLocalNotification];
    } else {// 首次注册用户通知的设置的内容：Alert，Badge，Sound
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
    }
}

// 用户注册通知方法之后执行（也就是调用完registerUserNotificationSettings:方法之后执行）
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [self addLocalNotification];
    }
}

//接收本地通知时触发
- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    NSDictionary *userDic = notification.userInfo;
    NSLog(@"%@",userDic);
}

#pragma mark 添加本地通知
- (void)addLocalNotification {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.repeatInterval = 2.0f;
     localNotification.repeatCalendar=[NSCalendar currentCalendar];//获取当前日历，使用前最好设置时区等信息以便能够自动同步时间
//    通知属性设置
    localNotification.alertTitle = @"夕阳西下，断肠人在天涯";
    localNotification.alertBody = @"当前有更新，去查看更新吗？";
    localNotification.alertAction = @"打开应用";
    localNotification.alertLaunchImage = @"123";//点击通知打开应用时的启动图片
    localNotification.applicationIconBadgeNumber = 3;
    localNotification.soundName =@"msgTritone.caf";//通知声音
     //设置用户信息
    localNotification.userInfo = @{@"id":@12,@"name":@"qiushaoyi"};
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

////移除通知
//- (void)removNotification {
//    [[UIApplication sharedApplication]cancelAllLocalNotifications];
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
#pragma mark 进入前台后设置消息信息:取消应用消息图标
- (void)applicationWillEnterForeground:(UIApplication *)application {
      [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



/*
 * 远程通知
 */

- (void)setUpRemoteNotification:(UIApplication *)application {
    //    注册用户通知的设置的内容：Alert，Badge，Sound
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    //   注册远程通知
    [application registerForRemoteNotifications];
}
//注册推送通知之后,在此接收设备令牌
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self addDeviceToken:deviceToken];
    NSLog(@"device token:%@",deviceToken);
}
// 注册推送通知之后,添加DeviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error.localizedDescription);
    [self addDeviceToken:nil];
}
// 接收到推送通知之后
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSDictionary *userDic = userInfo;
    NSLog( @"%@",userDic);
    
}

// 添加设备令牌到服务器端
- (void)addDeviceToken:(NSData *)deviceToken {
    NSString *key = @"QiuDeviceToken";
//    取出旧的Token
    NSData *oldToken = [[NSUserDefaults standardUserDefaults]objectForKey:key];
     //如果偏好设置中的已存储设备令牌和新获取的令牌不同则存储新令牌并且发送给服务器端
    if (![oldToken isEqualToData:deviceToken]) {
        [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:key];
        [self sendDeviceTokenWidthOldDeviceToken:oldToken newDeviceToken:deviceToken];
    }
}

-(void)sendDeviceTokenWidthOldDeviceToken:(NSData *)oldToken newDeviceToken:(NSData *)newToken {
    NSString *str1 = @"http://192.168.1.101/RegisterDeviceToken.aspx";
    str1 = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str1];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    request.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"oldToken=%@&newToken=%@",oldToken,newToken];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = body;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
             NSLog(@"Send failure,error is :%@",error.localizedDescription);
        } else {
            NSLog(@"Send Success!");
        }
    }];
    [dataTask resume];
}
@end
