//
//  NSString+encryption.m
//  HYBK
//
//  Created by 钟亮 on 2017/2/3.
//  Copyright © 2017年 zhongliang. All rights reserved.
//

#import "NSString+encryption.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSString (encryption)
- (NSString *)stringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02X", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}

- (NSString *)stringToBASE64:(NSString *)str
    {
        
        //1.先把字符串转换为二进制数据
        
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        //2.对二进制数据进行base64编码，返回编码后的字符串
        
        return [data base64EncodedStringWithOptions:0];
}
-(NSString *)base64DecodeString:(NSString *)str{
    //1.将base64编码后的字符串『解码』为二进制数据
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:0];
    
    //2.把二进制数据转换为字符串返回
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
@end
