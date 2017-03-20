//
//  CSTabBar.h
//  HYBK
//
//  Created by 钟亮 on 2017/1/15.
//  Copyright © 2017年 zhongliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSTabBarDelegate <NSObject>

- (void)ClickItemsWith:(NSInteger)index;

@end

@interface CSTabBar : UIVisualEffectView
@property (nonatomic ,weak)id<CSTabBarDelegate>delegate;
@end
