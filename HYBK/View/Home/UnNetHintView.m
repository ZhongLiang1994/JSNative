//
//  UnNetHintView.m
//  HYBK
//
//  Created by 钟亮 on 2017/2/4.
//  Copyright © 2017年 zhongliang. All rights reserved.
//

#import "UnNetHintView.h"

@implementation UnNetHintView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.6];
        self.text = @"网络请求失败，请检查网络设置";
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
