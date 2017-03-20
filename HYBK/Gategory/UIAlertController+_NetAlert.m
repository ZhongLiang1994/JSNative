//
//  UIAlertController+_NetAlert.m
//  HYBK
//
//  Created by 钟亮 on 2017/2/4.
//  Copyright © 2017年 zhongliang. All rights reserved.
//

#import "UIAlertController+_NetAlert.h"

@implementation UIAlertController (_NetAlert)
+ (UIAlertController *)showUnNetAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"连接失败，请检查网络设置" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){10,0,0}]) {
           // NSLog(@"Hello from > iOS 10.0");
        }else{
          //  NSLog(@"Hello from < iOS 10.0");
            
            NSURL *url = [NSURL URLWithString:@"prefs:root=Settings"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    return alert;
}
@end
