//
//  ViewController.m
//  SHLLabelDemo
//
//  Created by 开发机 on 14-7-3.
//  Copyright (c) 2014年 showhilllee. All rights reserved.
//

#import "ViewController.h"

#import "SHLUILabel.h"

@interface ViewController () {
    SHLUILabel* contentLab;
    UILabel* customLab;
    int labelHeight;
}

@end

@implementation ViewController

#define FRONTWITHSIZE(frontSize) [UIFont fontWithName:@"MicrosoftYaHei" size:frontSize]

#define RGB(__r, __g, __b)  [UIColor colorWithRed:(1.0*(__r)/255)\
                                            green:(1.0*(__g)/255)\
                                             blue:(1.0*(__b)/255)\
                                            alpha:1.0]

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self loadSHLLabel];
    [self loadCustomLabel];
}

//自定义Label
- (void) loadSHLLabel {
    
    NSString * content = [NSString stringWithFormat:@"%@", @"这是一个自定义间距的Label，这是一个自定义间距的Label，这是一个自定义间距的Label。"];
    content = [NSString stringWithFormat:@"%@\n%@", content, content];
    
    contentLab = [[SHLUILabel alloc] init];
    contentLab.text = content;
    //使用自定义字体
    contentLab.font = FRONTWITHSIZE(16.f);
    //设置字体颜色
    contentLab.textColor = RGB(77, 44, 122);
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    contentLab.numberOfLines = 0;
    //根据字符串长度和Label显示的宽度计算出contentLab的高
    labelHeight = [contentLab getAttributedStringHeightWidthValue:290];
    NSLog(@"SHLLabel height:%d", labelHeight);
    contentLab.frame = CGRectMake(15.f, 50.f, 290.f, labelHeight);
    [self.view addSubview:contentLab];
}

//系统原生Label
- (void) loadCustomLabel {
    
    NSString * content = [NSString stringWithFormat:@"%@", @"这是一个普通的Label，这是一个普通的Label，这是一个普通的Label。"];
    content = [NSString stringWithFormat:@"%@\n%@", content, content];
    
    customLab = [[UILabel alloc] init];
    customLab.text = content;
    //使用自定义字体
    customLab.font = FRONTWITHSIZE(16.f);
    //设置字体颜色
    customLab.textColor = RGB(44, 93, 205);
    customLab.lineBreakMode = NSLineBreakByWordWrapping;
    customLab.numberOfLines = 0;
    //根据字符串长度和Label显示的宽度计算出customLab的高
    CGSize customLabSize = [content sizeWithFont:customLab.font constrainedToSize:CGSizeMake(290.f, MAXFLOAT)  lineBreakMode:customLab.lineBreakMode];
    float customLabHeight = customLabSize.height;
    NSLog(@"customLab height:%f", customLabHeight);
    customLab.frame = CGRectMake(15.f, 100.f + labelHeight, 290.f, customLabHeight);
    [self.view addSubview:customLab];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
