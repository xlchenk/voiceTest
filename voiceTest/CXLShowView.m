//
//  CXLShowView.m
//  voiceTest
//
//  Created by issuser on 16/5/6.
//  Copyright © 2016年 issuser. All rights reserved.
//

#import "CXLShowView.h"
#import "CXLCustomCell.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface CXLShowView()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate,
UIAlertViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;

@property NSInteger section;
@property NSInteger row;


@end


@implementation CXLShowView

- (id)initWithFrame:(CGRect)frame{
   self =  [super initWithFrame:frame];
    if (self) {

        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置滚动的方向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:[[UIScreen mainScreen]bounds] collectionViewLayout:layout];
        //_collectionView.backgroundColor = [UIColor orangeColor ];
        [self addSubview:_collectionView];
        
        //注册单元格
        [_collectionView registerClass:NSClassFromString(@"CXLCustomCell") forCellWithReuseIdentifier:@"cell"];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        //创建长按手势监听
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(myHandleTableviewCellLongPressed:)];
        longPress.minimumPressDuration = 1.0;
        //将长按手势添加到需要实现长按操作的视图里
        [self.collectionView addGestureRecognizer:longPress];
        
    }
    return self;
}

//长按事件的手势监听实现方法
- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
    self.section = indexPath.section;
    self.row = indexPath.row;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要删除？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        
    }
    
}


#pragma UIAlertView 代理方法

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString * item = self.dataArray[self.section][self.row];
        [_dataArray[self.section] removeObject:item];
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource
//分组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每组中的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(40, 40);
}

//设置当前项与四周的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//最小的列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   CXLCustomCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    //  cell.imageView.image = [UIImage imageNamed:[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    //找到cell中的button；
//    UIButton *deviceImageButton = cell.imageButton;
//    [deviceImageButton addTarget:self action:@selector(deviceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //给每一个cell加边框；
//    cell.layer.borderColor = [UIColor grayColor].CGColor;
//    cell.layer.borderWidth = 0.3;
//    
//    [cell.imageButton setBackgroundImage:[UIImage imageNamed:@"0"] forState:UIControlStateNormal];
//    cell.descLabel.text = @"文本";
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
//选中当前项
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
}

@end
