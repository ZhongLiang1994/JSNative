//
//  NJInteraction.h
//  HYBK
//
//  Created by 钟亮 on 2017/1/22.
//  Copyright © 2017年 zhongliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJInteraction : NSObject

//登录
+ (void)loginWith:(JSContext *)jsContext;
//自动登录
+ (void)autoLoginWithWebView:(UIWebView *)webView message:(NSString *)message Html:(NSString *)html;
//获取放大的图片
+ (void)zoomImageViewWith:(JSContext *)jsContext Title:(NSString *)title;
//退出登录
+ (void)loginOutWithWebView:(UIWebView *)webView;

//tababr事件
+ (void)selectHtmlWithWebView:(UIWebView *)webView about:(NSInteger)index;


//影藏置顶按钮
+ (void)hideStickButtonWith:(JSContext *)jsContext;
//隐藏默认Footer
+ (void)hideDefaultFooterWith:(JSContext *)jsContext;
//显示默认Footer
+ (void)blockDefaultFooterWith:(JSContext *)jsContext;
//影藏默认的header
+ (void)hideDefaultHeaderWith:(JSContext *)jsContext;

+ (void)changDefaultFooterMarginBottomWith:(JSContext *)jsContext;
@end
