//
//  PopView.m
//  voiceTest
//
//  Created by issuser on 16/4/29.
//  Copyright © 2016年 issuser. All rights reserved.
//

#import "PopView.h"
#import <POP.h>
#import "LVRecordTool.h"
#define SCREN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREN_HETGHT [UIScreen mainScreen].bounds.size.height

@interface PopView ()<LVRecordToolDelegate,UIAlertViewDelegate>
/**
 *  录音工具
 */
@property (nonatomic,strong)LVRecordTool * recodTool;
/**
 *  音频图片
 */
@property (nonatomic,strong)UIImageView * imageView;
/**
 *  录音按钮
 */
@property (nonatomic,strong)UIButton * recordBtn;
/**
 *  取消录音按钮
 */
@property (nonatomic,strong)UIButton * cancleBtn;
/**
 *  时间
 */
@property (nonatomic,strong)UILabel * timeLable;

@property (nonatomic,strong)NSTimer * timer;
/**
 *  是否录音
 */
@property BOOL isRec;

@end


@implementation PopView
{
    int recordTime;
    int second;
    int minute;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //蒙板
        UIView * bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(0, 0, SCREN_WIDTH, SCREN_HETGHT);
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.4;
        
        [self addSubview:bgView];
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(50, 200, SCREN_WIDTH-2*50, 150)];
        _contentView.layer.cornerRadius = 8;
        _contentView.center = self.center;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_contentView.frame.size.width/2 -20, _contentView.frame.size.height/2-50, 40, 40)];
        _imageView.image = [UIImage imageNamed:@"mic_0"];
        [_contentView addSubview:_imageView];
        
        _timeLable = [[UILabel alloc]init];
        _timeLable.frame = CGRectMake(_contentView.frame.size.width/2-50, CGRectGetMaxY(_imageView.frame)+5, 100, 30);
        _timeLable.text = @"00:00";
        _timeLable.textColor = [UIColor blackColor];
        _timeLable.textAlignment = NSTextAlignmentCenter;
        //_timeLable.backgroundColor = [UIColor blueColor];
        _timeLable.font = [UIFont systemFontOfSize:25];
        [_contentView addSubview:_timeLable];
        
        
        CGRect rect = CGRectMake(10, CGRectGetMaxY(_imageView.frame)+40, 90, 25);
        _recordBtn = [self createButton:rect title:@"开始录音"];
        [_recordBtn addTarget:self action:@selector(startRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_recordBtn];
        rect = CGRectMake(_contentView.frame.size.width - 90-10, _recordBtn.frame.origin.y, 90, 25);
        _cancleBtn = [self createButton:rect title:@"取消录音"];
        [_cancleBtn addTarget:self action:@selector(canceAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cancleBtn];
        self.recodTool = [LVRecordTool  sharedRecordTool];
        self.recodTool.delegate = self;
    
        _isRec = YES;
    }
    return self;
}


- (void)recordTimeStart {
     _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordTimeTick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


- (void)recordTimeTick {
    recordTime += 1;
    minute = recordTime/60.0;
    second = recordTime-minute*60;
    
    [_timeLable setText:[NSString stringWithFormat:@"%02d:%02d",minute,second]];
     
}

#pragma 开始录音
- (void)startRecordVoice:(UIButton *)button{
    if (_isRec) {
       [_recordBtn setTitle:@"完成录音" forState:UIControlStateNormal];
        //录音
        [self.recodTool startRecording];
        recordTime = 0;
        [self recordTimeStart];
    }else{
        //
        double currentTime = self.recodTool.recorder.currentTime;
        NSLog(@"currentTime::%lf", currentTime);
        if (currentTime < 2) {
            
            self.imageView.image = [UIImage imageNamed:@"mic_0"];
            [self alertWithMessage:@"说话时间太短"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [self.recodTool stopRecording];
                [self.recodTool destructionRecordingFile];
                
            });
            _timeLable.text = @"00:00";
            recordTime = 0;
        } else {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [self.recodTool stopRecording];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = [UIImage imageNamed:@"mic_0"];
                });
            });
            // 已成功录音
            NSLog(@"已成功录音");
            [self.delegate displayViewVoice:recordTime];
            _timeLable.text = @"00:00";
            recordTime = 0;
        }
        [_recordBtn setTitle:@"开始录音" forState:UIControlStateNormal];
        self.hidden = YES;
        [_timer invalidate];
    }
    _isRec = !_isRec;
}




#pragma 取消录音
- (void)canceAction:(UIButton *)button{
    self.imageView.image = [UIImage imageNamed:@"mic_0"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self.recodTool stopRecording];
        [self.recodTool destructionRecordingFile];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithMessage:@"已取消录音"];
        });
    });
    _timeLable.text = @"00:00";
    recordTime = 0;
    [_timer invalidate];
    self.hidden = YES;
    
}


- (void)show{
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.fromValue=[NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    anim.springBounciness=18;
    anim.springSpeed=15;
    [_contentView.layer pop_addAnimation:anim forKey:@"spring"];
    
    
}

#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


#pragma mark - LVRecordToolDelegate
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no {
    
    NSString *imageName = [NSString stringWithFormat:@"mic_%d", no];
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (UIButton *)createButton:(CGRect )frame title:(NSString *)title{
    
     UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.cornerRadius = 8;
    return btn;
}

@end
