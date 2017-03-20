


//
//  StickBtn.m
//  HYBK
//
//  Created by 钟亮 on 2017/1/21.
//  Copyright © 2017年 zhongliang. All rights reserved.
//

#import "StickBtn.h"

@implementation StickBtn



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sd_setBackgroundImageWithURL:[NSURL URLWithString:@"http://www.hengyinbaika.com/images/fh.png"] forState:UIControlStateNormal];
    }
    return self;
}
@end
