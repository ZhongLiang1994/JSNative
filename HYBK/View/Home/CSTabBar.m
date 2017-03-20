//
//  CSTabBar.m
//  HYBK
//
//  Created by 钟亮 on 2017/1/15.
//  Copyright © 2017年 zhongliang. All rights reserved.
//

#import "CSTabBar.h"

@implementation CSTabBar

{
    NSArray *_itemsImage;
    NSArray *_itemsSelectImage;
    UIButton *_selectBtn;
    NSMutableArray *_itemsArr;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
      //  self.backgroundColor = [UIColor whiteColor];

        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];

        NSArray *titleArr = @[@"商城",@"回收",@"购物车",@"我的百卡"];
        _itemsImage = @[@"home",@"recycle",@"shopcart",@"person"];
        _itemsSelectImage = @[@"home_select",@"recycle_select",@"shopcart_select",@"person_select"];

        kWeakSelf;
        
        UIButton * tempBtn = [[UIButton alloc]init];
        
        NSInteger count = 4;//设置一排view的个数
        NSInteger margin = 0;//设置相隔距离
        NSInteger height = 49;//设置view的高度
        
        for (int i = 0; i<4; i++) {
            UIButton *items = [[UIButton alloc]initWithFrame:CGRectMake(i*kScreenW/4,0, kScreenW/4, 49)];
            items.tag = i;
           
    
            [items addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *itmeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
            itmeImageView.image = [UIImage imageNamed:_itemsImage[i]];
            
            [items addSubview:itmeImageView];
          
            [itmeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(items.mas_centerY).offset(10);
                make.centerX.equalTo(items.mas_centerX);
                make.height.with.offset(30);
            }];
            
            
            UILabel *titleLB = [[UILabel alloc]init];
            titleLB.text = titleArr[i];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:12];
            titleLB.textAlignment = NSTextAlignmentCenter;
            [items addSubview:titleLB];
            
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(itmeImageView.mas_bottom);
                make.bottom.equalTo(items.mas_bottom).offset(-1);
                make.width.equalTo(items.mas_width);
                make.left.equalTo(items.mas_left);
            }];
            
            if (i==0) {
                items.selected = YES;
                titleLB.textColor = [UIColor colorWithRed:29/255.0 green:114/255.0 blue:252/255.0 alpha:1];
                itmeImageView.image = [UIImage imageNamed:_itemsSelectImage[0]];
                _selectBtn = items;
            }
            
            [self addSubview:items];
            
          
            if (i == 0) {
                [items mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf).offset(margin);
                    make.centerY.equalTo(weakSelf);
                    make.height.mas_equalTo(height);
                }];
            }else if (i == count-1){
                [items mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(weakSelf).offset(-margin);
                    make.left.equalTo(tempBtn.mas_right).offset(margin);
                    make.centerY.equalTo(tempBtn);
                    make.height.equalTo(tempBtn);
                    make.width.equalTo(tempBtn);
                }];
            }
            else{
                [items mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(tempBtn.mas_right).offset(margin);
                    make.centerY.equalTo(tempBtn);
                    make.height.equalTo(tempBtn);
                    make.width.equalTo(tempBtn);
                }];
            }
            tempBtn = items;
            [items layoutIfNeeded];
        }
    
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
      
        [center addObserver:self selector:@selector(notice:) name:@"changeTabBarItems" object:nil];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor lightGrayColor];
        line.frame = CGRectMake(0, 0, kScreenW, 0.3);
        
        [self addSubview:line];
        
        
    }
    return self;
}

- (void)Click:(UIButton *)item{
    
    if (_selectBtn.tag == item.tag) {
        return;
    }
    [self changImageAndTitleColorWith:item];
    
    [self.delegate ClickItemsWith:item.tag];
   
}

- (void)notice:(NSNotification *)noti{
    
   
    NSInteger index = [noti.userInfo[@"index"] integerValue];
    
    NSArray *array = self.subviews;
    
    for (UIView *view in array) {
        if (view.tag == index) {
            
            UIButton *item = (UIButton *)view;
            
            if (_selectBtn.tag == item.tag) {
                return;
            }
//
            [self changImageAndTitleColorWith:item];
            
        }
    }
}

- (void)changImageAndTitleColorWith:(UIButton *)item{
  //  NSLog(@"执行了 _selectBtntag %ld  index%ld",_selectBtn.tag,item.tag);
    UIImageView *imageView = item.subviews.firstObject;
    imageView.image = [UIImage imageNamed:_itemsSelectImage[item.tag]];
    
    UILabel *titleLB = item.subviews.lastObject;
    titleLB.textColor = [UIColor colorWithRed:29/255.0 green:114/255.0 blue:252/255.0 alpha:1];
    
    UIImageView *selectImageView = _selectBtn.subviews.firstObject;
    selectImageView.image = [UIImage imageNamed:_itemsImage[_selectBtn.tag]];
    
    UILabel *selectTitleLB = _selectBtn.subviews.lastObject;
    selectTitleLB.textColor = [UIColor blackColor];

    _selectBtn = item;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"changeTabBarItems"];
}
@end
