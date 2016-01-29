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
    [self setUpNotification];//如果已经获得发送通知的授权则创建本地通知，否则请求授权
    return YES;
}

- (void)setUpNotification {
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        [self addLocalNotification];
    } else {//注册通知
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
    }
}
#pragma mark 调用过用户注册通知方法之后执行
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [self addLocalNotification];
    }
}
#pragma mark 添加本地通知
- (void)addLocalNotification {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    localNotification.repeatInterval = 2.0f;
     localNotification.repeatCalendar=[NSCalendar currentCalendar];//获取当前日历，使用前最好设置时区等信息以便能够自动同步时间
//    通知属性设置
    localNotification.alertTitle = @"夕阳西下，断肠人在天涯";
    localNotification.alertBody = @"当前有更新，去查看更新吗？";
    localNotification.alertAction = @"打开应用";
    localNotification.alertLaunchImage = @"";//点击通知打开应用时的启动图片
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.soundName =@"msgTritone.caf";//通知声音
     //设置用户信息
    localNotification.userInfo = @{@"id":@12,@"name":@"qiushaoyi"};
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
    
}
- (void)removNotification {
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
#pragma mark 进入前台后设置消息信息:取消应用消息图标
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
