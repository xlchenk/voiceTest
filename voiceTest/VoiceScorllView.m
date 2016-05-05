//
//  VoiceScorllView.m
//  voiceTest
//
//  Created by issuser on 16/5/3.
//  Copyright © 2016年 issuser. All rights reserved.
//

#import "VoiceScorllView.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGH ([UIScreen mainScreen].bounds.size.height)
@implementation VoiceScorllView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView=[[UIScrollView alloc]init];
        _scrollView.pagingEnabled=YES;
        _scrollView.delegate=self;
        _scrollView.frame=CGRectMake(0, 0,SCREEN_WIDTH, self.frame.size.height);
        _scrollView.showsHorizontalScrollIndicator=NO;
        [self addSubview:_scrollView];
    }
    return  self;
}


- (void)initView{
    CGFloat width=(SCREEN_WIDTH-15*2-10*5)/6;
    CGFloat height=width;
    CGFloat originX=15;
    CGFloat originY=0;
    NSInteger pages=0;
    _scrollView.contentSize=CGSizeMake(pages*SCREEN_WIDTH, self.frame.size.height);
    
    
    CGRect rect=CGRectMake(originX, originY, width, height);
    
    
    UIImage * img = [UIImage imageNamed:@"head_def"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:rect];
    if(YES){
        [imageView setImage:img];
    }
    //创建点击事件
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tapGesture];
    [_scrollView addSubview:imageView];
    
}

- (void)imageViewTap:(UIGestureRecognizer *)tap{
    UIImageView *customIv=(UIImageView*)tap.view;
    [self.delegate didSelectVoice:@""];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger offsetX=scrollView.contentOffset.x;
    NSInteger page=0;
    NSInteger width=SCREEN_WIDTH;
    if(offsetX%width==0){
        page=offsetX/SCREEN_WIDTH;
    }else{
        page=offsetX/SCREEN_WIDTH+1;
        
    }
}
@end
