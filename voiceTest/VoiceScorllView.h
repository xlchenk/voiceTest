//
//  VoiceScorllView.h
//  voiceTest
//
//  Created by issuser on 16/5/3.
//  Copyright © 2016年 issuser. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClickVOCDelegate <NSObject>

-(void)didSelectVoice:(NSString *)sender;

@end
@interface VoiceScorllView : UIView<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,weak)id<ClickVOCDelegate>delegate;
-(void)initView;
@end
