//
//  SHLUILabel.m
//  MyLabel
//
//  Created by showhillLee on 14-3-16.
//  Copyright (c) 2014年 showhilllee. All rights reserved.
//

#import "SHLUILabel.h"
#import <CoreText/CoreText.h>

@interface SHLUILabel ()
{
@private
    NSMutableAttributedString *attributedString;
//    CGFloat characterSpacing
}
- (BOOL) initAttributedString;
@end

@implementation SHLUILabel

@synthesize characterSpacing = characterSpacing_;

@synthesize linesSpacing = linesSpacing_;

@synthesize paragraphSpacing = _paragraphSpacing;


- (id)initWithFrame:(CGRect)frame
{
    //初始化字间距、行间距
    if(self =[super initWithFrame:frame])
        
    {
        self.characterSpacing = 1.5f;
        self.linesSpacing = 4.0f;
        self.paragraphSpacing = 10.0f;
        [self attachTapHandler];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//外部调用设置字间距
-(void)setCharacterSpacing:(CGFloat)characterSpacing
{
    characterSpacing_ = characterSpacing;
    [self setNeedsDisplay];
}

//外部调用设置行间距
-(void)setLinesSpacing:(long)linesSpacing
{
    linesSpacing_ = linesSpacing;
    [self setNeedsDisplay];
}

/*
 *初始化AttributedString并进行相应设置
 */
- (BOOL) initAttributedString
{
    if(attributedString==nil){
        
        if (self.text == nil) {
            return NO;
        }
        NSString *labelString = self.text;
        
        //创建AttributeString
        attributedString =[[NSMutableAttributedString alloc]initWithString:labelString];
        
        //设置字体及大小
        CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)self.font.fontName,self.font.pointSize,NULL);
        [attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(0,[attributedString length])];
        
        //设置字间距
        long number = self.characterSpacing;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
        CFRelease(num);
        /*
         if(self.characterSpacing)
         {
         long number = self.characterSpacing;
         CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
         [attributedString addAttribute:(id)kCTKernAttributeName value:(id)num range:NSMakeRange(0,[attributedString length])];
         CFRelease(num);
         }
         */
        
        //设置字体颜色
        [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(self.textColor.CGColor) range:NSMakeRange(0,[attributedString length])];
        
        //创建文本对齐方式
        CTTextAlignment alignment = kCTLeftTextAlignment;
        if(self.textAlignment == NSTextAlignmentCenter)
        {
            alignment = kCTCenterTextAlignment;
        }
        if(self.textAlignment == NSTextAlignmentRight)
        {
            alignment = kCTRightTextAlignment;
        }
        
        CTParagraphStyleSetting alignmentStyle;
        
        alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
        
        alignmentStyle.valueSize = sizeof(alignment);
        
        alignmentStyle.value = &alignment;
        
        //设置文本行间距
        /*
         CGFloat lineSpace = self.linesSpacing;
         */
        CGFloat lineSpace = self.linesSpacing;
        CTParagraphStyleSetting lineSpaceStyle;
        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
        lineSpaceStyle.valueSize = sizeof(lineSpace);
        lineSpaceStyle.value =&lineSpace;
        
        //设置文本段间距
        CGFloat paragraphSpacings = self.paragraphSpacing;
        CTParagraphStyleSetting paragraphSpaceStyle;
        paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
        paragraphSpaceStyle.valueSize = sizeof(CGFloat);
        paragraphSpaceStyle.value = &paragraphSpacings;
        
        //创建设置数组
        CTParagraphStyleSetting settings[ ] ={alignmentStyle,lineSpaceStyle,paragraphSpaceStyle};
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings ,3);
        
        //给文本添加设置
        [attributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0 , [attributedString length])];
        CFRelease(helveticaBold);
        return YES;
    } else {
        return YES;
    }
}

/*
 *覆写setText方法
 */
- (void) setText:(NSString *)text
{
    [super setText:text];
}

/*
 *开始绘制
 */
-(void) drawTextInRect:(CGRect)requestedRect
{
    
    if (![self initAttributedString]) {
        return;
    }
    
    //排版
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    
    CGPathAddRect(leftColumnPath, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), leftColumnPath , NULL);
    
    //翻转坐标系统（文本原来是倒的要翻转下）
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    //画出文本
    
    CTFrameDraw(leftFrame,context);
    
    //释放
    
    CGPathRelease(leftColumnPath);
    
    CFRelease(framesetter);
    
    UIGraphicsPushContext(context);
}

/*
 *绘制前获取label高度
 */
- (int)getAttributedStringHeightWidthValue:(int)width
{
    if (![self initAttributedString]) {
        return 0;
    }
    
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 100000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 100000 - line_y + (int) descent +1;//+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
}


#pragma mark - copy
//为了能接收到copy事件（能成为第一响应者），我们需要覆盖一个方法：
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

//还需要针对复制的操作覆盖两个方法：
// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

//针对于响应方法的实现
-(void)copy:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
    NSLog(@"%@", pboard.string);
}

//UILabel默认是不接收事件的，我们需要自己添加touch事件
-(void)attachTapHandler
{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    //双击
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    touch.numberOfTapsRequired = 2;
    [self addGestureRecognizer:touch];
    //长按
    UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
}

-(void)handleTap:(UIGestureRecognizer*) recognizer
{
    [self becomeFirstResponder];
    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:)];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:@[copyLink]];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - end
- (void)dealloc
{
    attributedString = nil;
}

@end
