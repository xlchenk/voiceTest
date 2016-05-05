//
//  PopView.h
//  voiceTest
//
//  Created by issuser on 16/4/29.
//  Copyright © 2016年 issuser. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VOCLDelegate <NSObject>
@optional
- (void)displayViewVoice:(int)sender;

@end
@interface PopView : UIView
@property(nonatomic,strong)UIView * contentView;
@property(nonatomic,weak)id<VOCLDelegate>delegate;
- (void)show;
@end
