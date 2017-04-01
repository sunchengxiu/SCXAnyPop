//
//  SCXPopView.h
//  自定义弹出按钮和方向
//
//  Created by 孙承秀 on 2017/3/30.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCX_SelfPoint SCXPopView * (^) ()

#define SCX_Self self._selfPoint()

#define SCX_animationDuration 0.3

#define SCX_ButtonSpace 15

/**
 按钮pop的方向

 - SCX_ButtonPopDirectionUp: 向上
 - SCX_ButtonPopDirectionLeft: 向左
 - SCX_ButtonPopDirectionDown: 向下
 - SCX_ButtonPopDirectionRight: 向右
 */
typedef NS_ENUM(NSInteger , SCX_ButtonPopDirection) {

    SCX_ButtonPopDirectionUp ,
    SCX_ButtonPopDirectionLeft ,
    SCX_ButtonPopDirectionDown ,
    SCX_ButtonPopDirectionRight

};
@interface SCXPopView : UIView<UIGestureRecognizerDelegate>

/*************  按钮数组 ***************/
@property ( nonatomic , strong )NSMutableArray *buttonsArr;

/*************  pop方向 ***************/
@property ( nonatomic , assign )SCX_ButtonPopDirection direction;

/*************  原始frame ***************/
@property ( nonatomic , assign )CGRect originFrame;

/*************  单击手势 ***************/
@property ( nonatomic , strong )UITapGestureRecognizer *tap;

/*************  动画时间 ***************/
@property ( nonatomic , assign )NSTimeInterval animationDuration;

/*************  设置按钮之间的间隙 ***************/
@property ( nonatomic , assign )CGFloat buttonSpace;

/*************  主视图 ***************/
@property ( nonatomic , strong )UIView *mainView;

/*************  是否选中展示了 ***************/
@property ( nonatomic , assign )BOOL selected;



/**
 初始化设置
 */
-(SCXPopView * (^) (CGRect frame , SCX_ButtonPopDirection direction))initWithFrameAndDirection;
/**
 指针
 
 @return 指针
 */
- (SCX_SelfPoint)SCX;

- (void)SCX_MakeConfig:(void (^) (SCXPopView *make))block;

/**
 添加弹出的按钮数组
 */
- (SCXPopView * (^) (NSArray *arr))SCX_AddButtons;

/**
 设置主视图
 
 */
- (SCXPopView *(^) (UIView *mainView))SCX_MainView;

/**
 展示按钮
 */
- (void)SCX_ShowButtons;
/**
 消失按钮
 */
- (void)SCX_DismissButtons;
@end
