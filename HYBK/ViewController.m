//
//  ViewController.m
//  HYBK
//
//  Created by 钟亮 on 2016/12/20.
//  Copyright © 2016年 zhongliang. All rights reserved.
//

#import "ViewController.h"
#import "CSTabBar.h"
#import "StickBtn.h"
#import "UnNetHintView.h"
@interface ViewController ()<UIWebViewDelegate,CSTabBarDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    //图片放大的背景
    UIScrollView *_bgView;
    //放大的图片
    UIImageView *_imgView;
    //记录界面的位置
    NSInteger _itensIndex;
    //记录页面标题
    NSString *_title;
    
    //抉择是否允许自动登录
    BOOL _isAutoLogin;
    //抉择是否允许出现加载动画
    BOOL _isAllowShowHub;
    //网络状态
    BOOL _isInterNet;
}
@property (nonatomic ,strong)UIWebView *webView;
@property (nonatomic, strong)JSContext *jsContext;
@property (nonatomic ,strong)CSTabBar *tabBar;
//侧滑返回手势
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

//加载动画
@property (nonatomic,strong) MBProgressHUD *hub;

//置顶按钮
@property (nonatomic,strong) StickBtn *stickBtn;

@property (nonatomic,strong)  NSURLRequest *request;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itensIndex = 4;
    _isAutoLogin = YES;
    _isAllowShowHub = YES;
    
    [self addIntnetWorkMonitoring];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.tabBar];
    self.stickBtn.backgroundColor = [UIColor clearColor];
    [self addSwipeGestureRecognizer];
    
    [self setNavigationItem:NO];
    [self changLongPressGestureRecognizer];
    
    kWeakSelf;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.left.right.bottom.top.equalTo(weakSelf.view);
    }];
    
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(weakSelf.view);
        make.height.offset(49);
    }];
}


//设置导航栏的leftbtn
- (void)setNavigationItem:(BOOL )isAllowBack{
    
    UIImageView *navigationImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigationImage.png"]];
    
    navigationImage.bounds = CGRectMake(0, 0, 120, 32);
    
    UIButton *leftBarBtn = [[UIButton alloc]init];
    
    leftBarBtn.bounds = CGRectMake(0, 0, 15, 25);
    
    [leftBarBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [leftBarBtn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //把自定义的button作为初始化的样式
   
    if (isAllowBack == NO) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navigationImage];
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarBtn];
    }
}


- (void)leftBarButtonClick{
    
    if ([self.title isEqualToString:@"图片详情"]) {
        _bgView.hidden = YES;
        self.title = _title;
    }else
    [self.webView goBack];
}



- (void)autoLogin:(NSString *)html{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginData"];
    if (dic) {
        NSString *timeString = dic[@"date"];
        
        float interval = [[NSDate date] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]]];
        
        if (interval < 60*60*24*12) {
            
            NSString *userInformation64 = dic[@"accountpw"];
            NSString *password64 = [[userInformation64 componentsSeparatedByString:@"&"][1] componentsSeparatedByString:@"="][1];
            
            password64 = [password64 stringByAppendingFormat:@"="];
            
            NSString *password = [password64 base64DecodeString:password64];
    
            NSString *userInformation = [userInformation64 stringByReplacingOccurrencesOfString:password64 withString:password];
            [NJInteraction autoLoginWithWebView:self.webView message:userInformation Html:html];
        }else{
            NSLog(@"登录有效期已过，请重新登录");
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }

}
//替换长按手势，使复制弹窗失效
- (void)changLongPressGestureRecognizer{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
    
    longPress.delegate = self;
    
    longPress.minimumPressDuration = 0.4;

    [self.webView addGestureRecognizer:longPress];
}

#pragma mark --GestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}
#pragma mark -- WebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSString *requestString = [[[request URL] absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    // 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        
        self.title = @"图片详情";
        [self showBigImage:imageUrl];//创建视图并显示图片
        
        return NO;
    }
    
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//        NSLog(@"cookie信息-----------%@", cookie);
//    }
//    NSLog(@"请求头信息-----%@",request.allHTTPHeaderFields);
//    
    return YES;

}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
  

    if (_isAllowShowHub) {
        
        [self.view addSubview:self.hub];
        
        [_hub showAnimated:YES];
        
        [_hub hideAnimated:YES afterDelay:1];
        
    }

}



- (void)webViewDidFinishLoad:(UIWebView *)webView{

    _jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    _title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    self.title = _title;
    
    //控制导航栏显示
    if ([_title isEqualToString:@"我的百卡"]) {
        
        //重新定义退出登录方法
        [NJInteraction loginOutWithWebView:self.webView];
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];

         self.automaticallyAdjustsScrollViewInsets = NO;
        
    }else{
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
          self.automaticallyAdjustsScrollViewInsets = YES;

    }
    
   
    /********************自动登录***********************/
    
    if (_isAutoLogin == YES) {
        
        [self autoLogin:@"index.jsp"];
        
    }
    //关闭自动关闭
    _isAutoLogin = NO;
    
    /*********************样式处理***************************/
    

        
        //影藏默认的header
        [NJInteraction hideDefaultHeaderWith:_jsContext];
        
        //注入放大图片的
        [NJInteraction zoomImageViewWith:self.jsContext Title:_title];
        
        //隐藏页面自带的置顶按钮
        [NJInteraction hideStickButtonWith:self.jsContext];
  
    
    
    /*********************native控件处理********************/
    
   

    NSArray *footerArr = @[@"商品详情",
                           @"购物车",
                           @"我的银行卡",
                           @"收货地址",
                           @"确认支付方式",
                           @"支付订单",
                           @"提交订单"];
    
    BOOL isContansFooter = [footerArr containsObject:_title];
    if (isContansFooter == YES) {
        
        [NJInteraction blockDefaultFooterWith:self.jsContext];
    }else{
        // 影藏页面自带的标签栏，使用native的
        [NJInteraction hideDefaultFooterWith:self.jsContext];
    
    }
   
/********************登录界面*******************************/
    
  
    
/***********************一级界面处理**************************/
    
    //检测界面位置。tabbar做出相应的变化
    NSArray *titleArr = @[@"百卡服务",
                          @"礼卡回收",
                          @"购物车",
                          @"我的百卡"];
    
    BOOL isContans = [titleArr containsObject:_title];
    if (isContans == YES) {
        
        if ([_title isEqualToString:@"百卡服务"]) {
        
          
            self.title = nil;
            
            [self setNavigationItem:NO];
            
        }else{
            self.navigationItem.leftBarButtonItem = nil;
        }
        
         self.tabBar.alpha = 1;
        
        NSInteger item = [titleArr indexOfObject:_title];
        
        if (_itensIndex != item) {
            
            [self changeTabBarItemsSelectWith:item];
            
            _itensIndex = item;
        }
        
        if ([_title isEqualToString:@"购物车"]) {
            
            [NJInteraction changDefaultFooterMarginBottomWith:self.jsContext];
        }
        
    }else{
        [self setNavigationItem:YES];
        self.tabBar.alpha = 0;
    }
    
    
    if ([_title isEqualToString:@"会员登录"]) {
        
        //登录操作
        [NJInteraction loginWith:self.jsContext];
        
    }


    //检测异常
    self.jsContext.exceptionHandler = ^(JSContext *context1, JSValue *exceptionValue) {
        
        context1.exception = exceptionValue;
      //  NSLog(@"异常异常异常：%@", exceptionValue);
    };
    
    //停止刷新
    [self endRefresh];
    
    //移除加载动画
    [_hub hideAnimated:YES];
    
    //再次允许出现加载动画
    _isAllowShowHub = YES;


}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    // NSLog(@"加载失败：%@",error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    [self endRefresh];
    if (_isInterNet == NO) {
        //当无网络加载失败时弹出提示弹框
        [self showNetAlert];
    }
   
}


- (void)changeTabBarItemsSelectWith:(NSInteger)index{
    
    NSNotification * notice = [NSNotification notificationWithName:@"changeTabBarItems" object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%ld",(long)index]}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

//点击tabbar触发的代理
- (void)ClickItemsWith:(NSInteger)index{
    //首页禁止加载动画
    _isAllowShowHub = NO;
    
    _itensIndex = index;
    
    [NJInteraction selectHtmlWithWebView:self.webView about:index];
    
    _jsContext = nil;
}


#pragma mark 显示大图片+++++++++++++++++++++++++++++++++++++++++++

-(void)showBigImage:(NSString *)imageUrl{
    //创建灰色透明背景，使其背后内容不可操作
    _bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [_bgView setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
    _bgView.delegate = self;
    _bgView.maximumZoomScale=2.0;//图片的放大倍数
    _bgView.minimumZoomScale=1.0;//图片的最小倍率
    [self.view addSubview:_bgView];
    
    
    //创建显示图像视图
    _imgView = [[UIImageView alloc]init];
    
    CGSize imgSize = [AutoImageSize getImageSizeWithURL:[NSURL URLWithString:imageUrl]];
    
    _imgView.bounds = CGRectMake(0, 0, kScreenW,kScreenW*imgSize.height/imgSize.width);
    
    _imgView.center = _bgView.center;
    
    _imgView.userInteractionEnabled = YES;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    [_bgView addSubview:_imgView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    tap.numberOfTapsRequired=1;//单击
    tap.numberOfTouchesRequired=1;//单点触碰
    [_bgView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired=2;//避免单击与双击冲突
    [tap requireGestureRecognizerToFail:doubleTap];
    [_imgView addGestureRecognizer:doubleTap];
    _imgView.contentMode=UIViewContentModeScaleAspectFit;
    

    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView  //委托方法,必须设置  delegate
{
    
    return _imgView;//要放大的视图
}

-(void)doubleTap:(id)sender
{
    _bgView.zoomScale=2.0;//双击放大到两倍
}
- (void)tapImage:(id)sender
{
    _bgView.hidden = YES;//单击图像,关闭图片详情(当前图片页面)
    self.title = _title;
}

//处理图片放大时的偏移问题
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
    
}


//监听webview的滚动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 300) {
        if (self.stickBtn.alpha == 1) {
            [UIView animateWithDuration:0.2 animations:^{
                self.stickBtn.alpha = 0;
            }];
        }
     
    }else{
        if (self.stickBtn.alpha == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.stickBtn.alpha = 1;
            }];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 300) {
        if (self.stickBtn.alpha == 1) {
            [UIView animateWithDuration:0.2 animations:^{
                self.stickBtn.alpha = 0;
            }];
        }
        
    }else{
        if (self.stickBtn.alpha == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.stickBtn.alpha = 1;
            }];
        }
    }
   
}

//侧滑返回手势
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    NSArray *titleArr = @[@"百卡服务",
                          @"礼卡回收",
                          @"购物车",
                          @"我的百卡"];
    
    BOOL isContans = [titleArr containsObject:_title];
    if (isContans == NO) {
        
        if ([_title isEqualToString:@"支付宝快捷收银台"]) {
            
            [self.webView goBack];
            
            return;
        }
        
        NSString *jsstr = @"history.go(-1);";
        
        [self.jsContext evaluateScript:jsstr];
        
    }
}

//点击置顶按钮的动画
- (void)stickClick{
    [UIView animateWithDuration:0.2 animations:^{
         self.webView.scrollView.contentOffset = CGPointMake(0, -64);
    }];
}


#pragma mark - 下拉刷新

- (void)headerRefresh{
    
    _isAllowShowHub = NO;
    
   [self.webView reload];
   
}

#pragma mark - 结束下拉刷新和上拉加载

- (void)endRefresh{
    
    [self.webView.scrollView.mj_header endRefreshing];
}


#pragma mark - 懒加载

//webview
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
       
        
        //关闭_webview的号码邮箱识别
        _webView.dataDetectorTypes = 0;
        
     
        // UIWebView 滚动的比较慢，这里设置为正常速度
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        //异步加载网页，减少加载时间
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
          //  [Cookies setCoookie];
            [_webView loadRequest:self.request];
         
        });
       
        [_webView setScalesPageToFit:YES];
       
    }
    return _webView;
}

//自定义标签栏
- (CSTabBar *)tabBar{
    
    if (!_tabBar) {
        
        _tabBar = [[CSTabBar alloc]initWithFrame:CGRectMake(0, kScreenH-49, kScreenW, 49)];
        _tabBar.delegate = self;
    }
    return _tabBar;
    
}

//为webview添加侧滑手势
- (void)addSwipeGestureRecognizer{

    _rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    _rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.webView addGestureRecognizer:self.rightSwipeGestureRecognizer];
}
//加载动画
- (MBProgressHUD *)hub{
    
    if (!_hub) {
        
        _hub = [[MBProgressHUD alloc]init];
        _hub.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _hub.bezelView.backgroundColor = [UIColor clearColor];
        _hub.center = self.view.center;
        _hub.mode = MBProgressHUDModeIndeterminate;
 
    }
    return _hub;
}

//置顶安钮
- (StickBtn *)stickBtn{
    
    if (!_stickBtn) {
        
        _stickBtn = [[StickBtn alloc]init];
        _stickBtn.alpha = 0;
        [_stickBtn addTarget:self action:@selector(stickClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_stickBtn];
        
        kWeakSelf;
        
        [_stickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.tabBar.mas_top).offset(-50);
            make.right.equalTo(weakSelf.view.mas_right).offset(-10);
            make.width.height.offset(35);
        }];
        
    }
    return _stickBtn;
}

- (NSURLRequest *)request{
    if (!_request) {
        
        NSURL *htmlURL = [NSURL URLWithString:HOMEURL];
        _request = [NSURLRequest requestWithURL:htmlURL];
    }
    return _request;
}
#pragma mark -- 添加网络监控

- (void)addIntnetWorkMonitoring{
    
    UnNetHintView *unNetHintView = [[UnNetHintView alloc]init];
    unNetHintView.frame = CGRectMake(0, -104, kScreenW, 40);
    [self.webView addSubview:unNetHintView];
    
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            _isInterNet = NO;
            
            self.tabBar.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.3 animations:^{
                unNetHintView.frame = CGRectMake(0, 64, kScreenW, 40);
            }];
            
            [self showNetAlert];
          
        }
        else{
            
            [self disMissAlert];
            
            _isInterNet = YES;
            
            [UIView animateWithDuration:0.3 animations:^{
                unNetHintView.frame = CGRectMake(0, -104, kScreenW, 40);
            }];
            
              self.tabBar.userInteractionEnabled = YES;
            
            if (_title == nil) {
                
                //异步加载网页，减少加载时间
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    [self.webView loadRequest:self.request];
    
                });
            }
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
}


- (void)showNetAlert{
    [self presentViewController:[UIAlertController showUnNetAlert] animated:YES completion:nil];
    
}

- (void)disMissAlert{
    if (_isInterNet == NO) {
       [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
- (void)dealloc{
    NSLog(@"控制器释放了");
}
@end
