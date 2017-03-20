//
//  Cookies.m
//  HYBK
//
//  Created by 钟亮 on 2017/1/22.
//  Copyright © 2017年 zhongliang. All rights reserved.
//

#import "Cookies.h"

@implementation Cookies
+ (void)saveCookies{
    NSArray *cookiesArr = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self removeCookies];
    
    for (NSHTTPCookie *cookie in cookiesArr) {
        
        NSMutableDictionary *cookiesDic = [[NSMutableDictionary alloc]init];
    
        [cookiesDic setValue:cookie.properties forKey:@"cookiesDict"];
        
        [defaults setObject: cookiesDic forKey: @"cookies"];
        [defaults synchronize];
    }
}


#pragma mark 再取出保存的cookie重新设置cookie
+ (void)setCoookie
{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cookiesDic = [defaults dictionaryForKey:@"cookies"];
   // NSLog(@"--------上次保存的cookies%@",cookiesDic);
    NSDictionary *cookiesProperties = [cookiesDic valueForKey:@"cookiesDict"];
    if (cookiesProperties) {
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookiesProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];}
//    }else{
//        NSArray *cookiesArr = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    
//        for (NSHTTPCookie *cookie in cookiesArr) {
//            
//            
//            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//            [cookieProperties setObject:cookie.properties[NSHTTPCookieName] forKey:NSHTTPCookieName];
//            [cookieProperties setObject:cookie.properties[NSHTTPCookieValue] forKey:NSHTTPCookieValue];
//            [cookieProperties setObject:cookie.properties[NSHTTPCookieDomain] forKey:NSHTTPCookieDomain];
//            [cookieProperties setObject:cookie.properties[NSHTTPCookiePath] forKey:NSHTTPCookiePath];
//            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
//            [cookieProperties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24*15] forKey:NSHTTPCookieExpires];
//            NSHTTPCookie *scookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:scookie];
//        }
//
    //}
    
}
+ (void)removeCookies{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (int i = 0; i < [cookies count]; i++) {
        NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

@end
