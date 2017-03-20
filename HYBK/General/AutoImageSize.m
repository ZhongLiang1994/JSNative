//
//  AutoImageSize.m
//  HYBK
//
//  Created by 钟亮 on 2017/1/16.
//  Copyright © 2017年 zhongliang. All rights reserved.
//

#import "AutoImageSize.h"

@implementation AutoImageSize


// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL
{
    return [UIImage imageWithData:[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:imageURL] returningResponse:nil error:nil]].size;
    
}
@end
