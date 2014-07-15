//
//  SHLUILabel.h
//  MyLabel
//
//  Created by showhillLee on 14-3-16.
//  Copyright (c) 2014年 showhilllee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SHLUILabel : UILabel{
@private
    CGFloat characterSpacing_;       //字间距
    long    linesSpacing_;           //行间距
    CGFloat paragraphSpacing;        //段间距
}

@property(nonatomic,assign) CGFloat characterSpacing;
@property(nonatomic,assign) CGFloat paragraphSpacing;
@property(nonatomic,assign) long    linesSpacing;
//@property(nonatomic,strong) UIColor* backgroundColors;

/*
 *绘制前获取label高度
 */
- (int)getAttributedStringHeightWidthValue:(int)width;

@end
