//
//  CXLViewController.m
//  voiceTest
//
//  Created by issuser on 16/4/29.
//  Copyright © 2016年 issuser. All rights reserved.
//

#import "CXLViewController.h"
#import "PopView.h"
#import "LVRecordTool.h"
//#import "VoiceScorllView.h"
#define SCREN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREN_HETGHT [UIScreen mainScreen].bounds.size.height
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface CXLViewController ()<
UITextViewDelegate,
LVRecordToolDelegate,
VOCLDelegate,
UIAlertViewDelegate>
//@property (nonatomic,strong)VoiceScorllView * voiceScorllView;
@property (nonatomic,strong)UIView * voiceView;
@property (nonatomic,strong)UIImageView * imv;
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)PopView * bgPopView;
@property (nonatomic,strong)UIImageView * imageV1;
@property (nonatomic,strong)LVRecordTool * recordTool;
@property (nonatomic,strong)UILabel * timelb;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,strong)UIAlertView * alert;
@property (nonatomic,strong) UIButton * VOCBtn;
@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,strong)UIView * line;
@end

@implementation CXLViewController
{
    int second;
    int timeSecond;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the vie
    self.view.backgroundColor = RGBACOLOR(243,242,242,1);
    
    [self createUI];
    [self initModelView];
    
    
}
- (void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView * backView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREN_WIDTH, 300)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    CGRect rect = CGRectMake(0, 80, self.view.frame.size.width, 100);
    _textView = [self createTextView:rect content:nil];
    [backView addSubview:_textView];
    
    CGRect voiceRect = CGRectMake(_textView.frame.origin.x, CGRectGetMaxY(_textView.frame)+5, _textView.frame.size.width, 40);
    _voiceView = [[UIView  alloc]initWithFrame:voiceRect];
    //_voiceScorllView.delegate = self;
    //_voiceView.backgroundColor = [UIColor orangeColor];
    NSLog(@"%@", NSStringFromCGRect(_voiceView.frame));
   
   _imageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(15,0, 40, 40)];
     NSLog(@"%@", NSStringFromCGRect(_imageV1.frame));
    [_voiceView addSubview:_imageV1];
    [backView addSubview:_voiceView];
    _timelb = [[UILabel alloc]initWithFrame:_imageV1.frame];
    [_imageV1 addSubview:_timelb];
    //创建点击事件
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    _imageV1.userInteractionEnabled = YES;
    [_imageV1 addGestureRecognizer:tapGesture];
    UILongPressGestureRecognizer * pressTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestures:)];
    
    pressTap.minimumPressDuration = 1.;
    [_imageV1 addGestureRecognizer:pressTap];
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), SCREN_WIDTH, 1)];
    _line.backgroundColor = RGBACOLOR(243,242,242,1);
    [backView addSubview:_line];
    _VOCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _VOCBtn.frame = CGRectMake(10, CGRectGetMaxY(_textView.frame)+5, 30, 30);
    [_VOCBtn setBackgroundImage:[UIImage imageNamed:@"voc"] forState:UIControlStateNormal];
    [_VOCBtn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    _voiceView.hidden = YES;
    
    [backView addSubview:_VOCBtn];
    
    self.recordTool = [LVRecordTool sharedRecordTool];
    self.recordTool.delegate = self;

}
/**@param sender */
- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)longPress{
    if ([longPress state] == UIGestureRecognizerStateBegan) {
        _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您是否要删除此附件？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        
        [_alert show];
    }
}
#pragma 删除文件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.recordTool stopPlaying];
        [self.recordTool destructionRecordingFile];
        _imageV1.hidden = YES;
        second = 0;
        _voiceView.hidden = YES;
        CGRect frame = CGRectMake(10, CGRectGetMaxY(_textView.frame)+5, 30, 30);
        _VOCBtn.frame = frame;
        frame = CGRectMake(0, CGRectGetMaxY(_textView.frame), SCREN_WIDTH, 0.5);
        _line.frame = frame;
    }
  
}
- (void)imageViewTap:(UIGestureRecognizer *)tap{
    [self.recordTool playRecordingFile];
    [self initTimer];
}

-(void)initTimer{
    _timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFlow:) userInfo:nil repeats:YES];
    //启动
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)timeFlow:(NSTimer *)timer{
   // timeSecond = second;
    
    timeSecond--;
    NSString *count=[NSString stringWithFormat:@"%d''",timeSecond];
    _timelb.text = count;
    if(timeSecond<0){
        timeSecond=second;
        if(_timer.isValid){
          //  NSLog(@"d舒服舒服服");
            NSString *count=[NSString stringWithFormat:@"%d''",second];
            _timelb.text = count;
            [_timer invalidate];
            _timer=nil;
        }
    }
}

#pragma  弹出按钮
- (void)popAction:(UIButton *)btn{
    _bgPopView.hidden = NO;
    [_bgPopView show];
    
}
#pragma 初始化popview
- (void)initModelView{
    _bgPopView = [[PopView alloc]initWithFrame:CGRectMake(0, 0, SCREN_WIDTH, SCREN_HETGHT)];
    [self.view addSubview:_bgPopView];
    _bgPopView.delegate = self;
    _bgPopView.hidden = YES;
    
}
#pragma popViewdelegate
/**
 *  完成录音后
 *
 *  @param sender 录音时间
 */
- (void)displayViewVoice:(int)sender{
    if (sender>=2) {
        second = sender;
        timeSecond = sender;
        UIImage * image = [UIImage imageNamed:@"voice"];
        _imageV1.image = image;
        _timelb.text = [NSString stringWithFormat:@"%d''",sender];
        _imageV1.hidden = NO;
        _voiceView.hidden = NO;
      CGRect frame = CGRectMake(0, CGRectGetMaxY(_voiceView.frame)+5, SCREN_WIDTH, 0.5);
        _line.frame = frame;
        frame = CGRectMake(10, CGRectGetMaxY(_line.frame)+5, 30, 30);
        _VOCBtn.frame = frame;
    }
    
}

- (UITextView *)createTextView:(CGRect )frame content:(NSString *)content{
    UITextView * textView = [[UITextView alloc]init];
    textView.frame = frame;
    textView.scrollEnabled = YES;
    textView.editable = YES;
    textView.delegate = self;
    textView.contentMode = UIViewContentModeTop;
    textView.font=[UIFont fontWithName:@"Heiti SC" size:16];
    textView.returnKeyType = UIReturnKeyDefault;
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    textView.textAlignment = NSTextAlignmentLeft;
    textView.dataDetectorTypes = UIDataDetectorTypeAll; //
    textView.layer.borderColor = UIColor.grayColor.CGColor;
    textView.layer.borderWidth = 0.5;
    textView.textColor = RGBACOLOR(243,242,242,1);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:@"输入你的内容" attributes:attributes];
    return textView;
}
@end
