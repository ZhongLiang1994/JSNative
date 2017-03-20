//
//  NJInteraction.m
//  HYBK
//
//  Created by 钟亮 on 2017/1/22.
//  Copyright © 2017年 zhongliang. All rights reserved.
//

#import "NJInteraction.h"

@implementation NJInteraction

//手动登录时
+ (void)loginWith:(JSContext *)jsContext{
  //  NSLog(@"执行了登录方法");
    jsContext[@"loginBack"] = ^() {
       // NSLog(@"接到登录成功回调");
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            
            NSString *userInformation = [NSString stringWithFormat:@"%@",obj];
            
            NSString *password = [[userInformation componentsSeparatedByString:@"&"][1] componentsSeparatedByString:@"="].lastObject;
            
            NSString *password64 = [password stringToBASE64:password];
            
            NSString *userInformation64 = [userInformation stringByReplacingOccurrencesOfString:password withString:password64];

            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%.0f", interval];
            NSDictionary *dic = @{@"date":timeString,@"accountpw":userInformation64};
             [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"loginData"];
    
          //  [Cookies saveCookies];
        }
    };

    
 //  NSString *cookiesJs =[Cookies creatCookies];
    //替换登录按钮的登录方法，当登录成功时向native传递登录表单，以保存账号密码一边下次登录使用，
    NSString *loginJs = @"var loginBtn=document.getElementsByClassName('hy_dl')[0].getElementsByClassName('dlxx')[0].getElementsByTagName('p')[2]; loginBtn.onclick = loginiOS;\
    function loginiOS(){\
    var url = 'customer!login.action';\
    var form=$('#loginFrom').serialize();\
    $.post(url,form,function(date){\
    if(date){\
    window.location=\"index.jsp\";\
    loginBack(form);\
    }else{\
    layer.open({\
    content : '登录失败,用户名或密码错误!!',\
    btn : '我知道了'\
    });\
    }\
    });\
    }";
    
    NSString *str = @"$(\":button\").prop(\"onclick\",null).off(\"click\");";
    //更改标识
    NSString *loginModel = @"document.getElementById(\"loginModel\").value = \"iOS\";";
    
    [jsContext evaluateScript:loginModel];
   // [jsContext evaluateScript:cookiesJs];
    [jsContext evaluateScript:str];
    [jsContext evaluateScript:loginJs];
}

//自动登录时
+ (void)autoLoginWithWebView:(UIWebView *)webView message:(NSString *)message Html:(NSString *)html{
    
    
    // NSLog(@"执行了自动登录方法：message：%@",message);
    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
  
    jsContext[@"autologin"] = ^() {
      //  NSLog(@"接到了自动登录成功回调");
    };
    NSString *loginJs =[NSString stringWithFormat:@"\
    function loginiOS(){\
    $.post('customer!login.action','%@',function(date){\
    if(date){\
    window.location=\"%@\";autologin('自动登录成功');\
    }\
    });\
    }\
    loginiOS();\
    ",message,html];
    
     [jsContext evaluateScript:loginJs];
}

//点击退出登录时
+ (void)loginOutWithWebView:(UIWebView *)webView{
   //  NSLog(@"执行了退出登录方法");
    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    jsContext[@"loginout"] = ^() {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginData"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cookies"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [Cookies removeCookies];
    };
    
    //替换退出登录按钮的登录方法
    NSString *loginJs = @"$(\":button\").attr('onclick','loginOutiOS()');\
    function loginOutiOS(){\
    var url = 'customer!loginOut.action';\
    var _postData={};\
    $.extend(_postData,{'userName':userName});\
    $.post(url,_postData,function(date){\
        if(date){\
            window.location=\"login.jsp\";loginout('退出登录');\
        }\
    });\
    }";
    
    NSString *str = @"$(\":button\").prop(\"onclick\",null).off(\"click\");";

    [jsContext evaluateScript:str];
    [jsContext evaluateScript:loginJs];
    
}

//获取放大图片
+ (void)zoomImageViewWith:(JSContext *)jsContext Title:(NSString *)title{
    
    if (![title isEqualToString:@"商品详情"]) {
        return;
    }
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '95%'";
    [jsContext evaluateScript:str];
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    [jsContext evaluateScript:jsGetImages];//注入js方法
    
    //注入自定义的js方法后别忘了调用 否则不会生效
    [jsContext evaluateScript:@"getImages()"];
    
}

//点击自定义标签栏加载不同页面的方法
+ (void)selectHtmlWithWebView:(UIWebView *)webView about:(NSInteger)index{
    
    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    NSArray *array = @[@"window.location='index.jsp';",
                       @"window.location='recover.jsp';",
                       @"window.location='spc!load.action';",
                       @"window.location='personal.jsp';"];
    NSString *jsStr = array[index];
    [jsContext evaluateScript:jsStr];
    
}

//移除默认的置顶按钮
+ (void)hideStickButtonWith:(JSContext *)jsContext{
    
    NSString *jsStr = @"$(\".fh_top\").remove();";
    [jsContext evaluateScript:jsStr];
    
}
//隐藏默认的footer
+ (void)hideDefaultFooterWith:(JSContext *)jsContext{
    NSString *jsStr =
    @"document.getElementsByClassName('db_lm')[0].style.display='none';";
    [jsContext evaluateScript:jsStr];
    
}
//影藏默认header
+ (void)hideDefaultHeaderWith:(JSContext *)jsContext{
     NSString *jsStr =@"$('.header').remove();";
    [jsContext evaluateScript:jsStr];
}
//显示默认footer
+ (void)blockDefaultFooterWith:(JSContext *)jsContext{
    NSString *jsStr = @"document.getElementsByClassName('db_lm')[0].style.display='block';";
    [jsContext evaluateScript:jsStr];
}

//更改页面默认footer的下边距
+ (void)changDefaultFooterMarginBottomWith:(JSContext *)jsContext{
    
    CGFloat h = 49*640/kScreenW;
    
    NSString *jssStr = [NSString stringWithFormat:@"document.getElementsByClassName('db_lm')[0].style.marginBottom=\"%0.0fpx\";",h];
    
    [jsContext evaluateScript:jssStr];
}
@end
