//
//  SCXPopView.m
//  自定义弹出按钮和方向
//
//  Created by 孙承秀 on 2017/3/30.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import "SCXPopView.h"

@interface SCXPopView()

@end
@implementation SCXPopView

#pragma mark -------------- 私有方法 -----------------

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
         SCX_Self._DefaultConfig;
    }
    return self;
}


/**
 初始化设置
 */
-(SCXPopView * (^) (CGRect frame , SCX_ButtonPopDirection direction))initWithFrameAndDirection{
    return  ^SCXPopView * (CGRect frame , SCX_ButtonPopDirection direction){
        if ([self initWithFrame:frame]) {
            self.direction = direction;
        }

        return self;
    };
    
}

/**
 获取自己的指针

 @return self
 */
- (SCX_SelfPoint)_selfPoint{
    return ^ SCXPopView* {
        return self;
    };
}
/**
 默认设置
 */
- (void)_DefaultConfig{
    // 设置动画时间
    self.animationDuration = SCX_animationDuration;
    // 设置默认动画方向
    self.direction = SCX_ButtonPopDirectionUp;
    // 设置按钮之间的间隙
    self.buttonSpace = SCX_ButtonSpace;
    // 设置原始frame
    self.originFrame = self.frame;
    // 添加手势
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SCX_TapHandle:)];
    // 设置事件都响应
    self.tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:self.tap];
    self.tap.delegate = self;
}

/**
 添加单个按钮
 */
- (SCXPopView * (^) (UIButton *))_AddButton{
    return ^ SCXPopView * (UIButton *btn){
        
        if (![self.buttonsArr containsObject:btn]) {
            [self.buttonsArr addObject:btn];
            [self addSubview:btn];
            btn.hidden = YES;
        }
        if (self.mainView != nil) {
            [self bringSubviewToFront:self.mainView];
        }
        return self;
    };
}

/**
 配置mainViewframe
 */
- (void)_ConfigMainViewFrame{

    switch (self.direction) {
        case SCX_ButtonPopDirectionUp:
        {
            [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.mas_bottom);
                make.centerX.mas_equalTo(self.mas_centerX);
            }];
        }
            break;
            case SCX_ButtonPopDirectionDown:
        {
            [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.centerX.mas_equalTo(self.mas_centerX);
            }];
        }
            break;
            case SCX_ButtonPopDirectionLeft:
        {
            [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right);
                make.centerY.mas_equalTo(self.mas_centerY);
            }];
        }
            break;
        case SCX_ButtonPopDirectionRight:
        {
            [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left);
                make.centerY.mas_equalTo(self.mas_centerY);
            }];
        }
            break;
        default:
            break;
    }

}
#pragma mark -------------- 按钮整体大小配置 -----------------

/**
 获取按钮整体的高度,如果是竖着展示的话，是每个按钮的高度加上每个按钮之间的缝隙
 */
- (CGFloat)_ConfigButtonsHeight{
    CGFloat height = 0.0;
    for (UIButton *btn in self.buttonsArr) {
        height += btn.frame.size.height + self.buttonSpace;
    }
    return height;
}
- (CGFloat)_ConfigButtonsWidth{
    CGFloat width = 0;
    for (UIButton *btn in self.buttonsArr) {
        width += btn.frame.size.width + self.buttonSpace;
    }
    return width;
}

/**
 根据不同的方向配置不同的frame
 */
- (void)_configButtonsFrameFromDirection{

    CGFloat width = SCX_Self._ConfigButtonsWidth;
    CGFloat height = SCX_Self._ConfigButtonsHeight;
    CGRect frame = self.frame;
    switch (self.direction) {
            // 上
        case SCX_ButtonPopDirectionUp:
        {
            // 因为向上pop，所以其实整个view的Y是在当前位置向上height个高度，下面同理
            frame.origin.y -= height;
            frame.size.height += height;
            self.frame = frame;
            
        }
            break;
            // 下
        case SCX_ButtonPopDirectionDown:{
            //frame.origin.y += height;
            frame.size.height += height;
            self.frame = frame;
        }
            break;
            // 左
        case SCX_ButtonPopDirectionLeft:{
        
            frame.origin.x -= width;
            frame.size.width += width;
            self.frame = frame;
        }
            break;
            // 右
        case SCX_ButtonPopDirectionRight:{
           // frame.origin.x += width;
            frame.size.width += width;
            self.frame= frame;
        }
            break;
        default:
            break;
    }
    

}

/**
 开始布局每个按钮的frame
 */
- (SCXPopView * (^) (void (^) (CGPoint , CGPoint) , UIButton *))_configEveryButtonAnimationFrame{
    return ^ SCXPopView * (void (^block) (CGPoint , CGPoint) , UIButton *btn){
        // 设置起始位置
        CGPoint originPoint = CGPointZero;
        CGPoint endPoint = CGPointZero;
        
        // 开始布局位置 ， 从后往前排 , 第一个控件放在最后一个位置
        switch (self.direction) {
            case SCX_ButtonPopDirectionUp:
            {
                originPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height - self.mainView.frame.size.height);
                endPoint = CGPointMake(self.frame.size.width / 2, btn.frame.size.height / 2 + (btn.frame.size.height + self.buttonSpace) * btn.tag) ;
                [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.mas_bottom);

                }];
                
            }
                break;
                case SCX_ButtonPopDirectionDown:
            {
                originPoint =  CGPointMake(self.frame.size.width / 2, self.mainView.frame.size.height);
                endPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height - self.mainView.frame.size.height /2  - ( btn.frame.size.height + self.buttonSpace) * btn.tag);
                [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top);
                    
                }];
            }
                break;
                case SCX_ButtonPopDirectionLeft:
            {
                originPoint = CGPointMake(self.frame.size.width - self.mainView.frame.size.width, self.frame.size.height / 2);
                endPoint = CGPointMake(btn.frame.size.width / 2 + (btn.frame.size.width + self.buttonSpace) * btn.tag, self.frame.size.height / 2);
                [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.mas_right);
                    
                }];
            }
                break;
                case SCX_ButtonPopDirectionRight:
            {
                originPoint = CGPointMake(self.mainView.frame.size.width, self.frame.size.height / 2);
                endPoint = CGPointMake(self.frame.size.width -(btn.frame.size.width / 2 + (btn.frame.size.width + self.buttonSpace) * btn.tag), self.frame.size.height / 2);
                [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.mas_left);
                    
                }];
            }
                break;
                
            default:
                break;
        }
        block(originPoint , endPoint);
        
        return self;
    };
   
}

/**
 获取每一个按钮消失动画时候的终点位置
 */
- (SCXPopView * (^) (void (^block) (CGPoint endpoint) , UIButton *btn))_ConfigEveryBtnEndPoint{
    return ^ SCXPopView *(void (^block) (CGPoint endpoint) , UIButton *btn){
        CGPoint finishPoint = CGPointZero;
        switch (self.direction) {
            case SCX_ButtonPopDirectionUp:
            {
                finishPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height - self.mainView.frame.size.height / 2);
            }
                break;
            case SCX_ButtonPopDirectionDown:
            {
                finishPoint = CGPointMake(self.frame.size.width / 2, self.mainView.frame.size.height / 2);
            }
                break;
                case SCX_ButtonPopDirectionLeft:
            {
                finishPoint = CGPointMake(self.frame.size.width - self.mainView.frame.size.width / 2, self.frame.size.height / 2);
            }
                break;
                case SCX_ButtonPopDirectionRight:
            {
                finishPoint = CGPointMake(self.mainView.frame.size.width  / 2, self.frame.size.height / 2);
            }
                break;
            default:
                break;
        }
        block(finishPoint);
        return self;
    };

}


/**
 开始动画
 */
- (SCXPopView *(^) (CGPoint , CGPoint , UIButton * , BOOL dismiss ))_beginAnimation{

    return ^ SCXPopView * (CGPoint originPoint , CGPoint endPoint , UIButton *btn , BOOL dismiss ){
    
        // 添加组合动画
        // 位置变化动画
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:originPoint];
        positionAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
        
        // 大小缩放动画
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        if (!dismiss) {
            scaleAnimation.fromValue = [NSNumber numberWithFloat:0.01];
            scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
        }
        else{
        
            scaleAnimation.fromValue = [NSNumber numberWithFloat:1];
            scaleAnimation.toValue = [NSNumber numberWithFloat:0.01];
        }
        
        
        // 组动画（把位置动画和大小缩放动画放到组里）
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[positionAnimation , scaleAnimation];
        group.duration = self.animationDuration;
        
        // 每个btn的动画时间不能相同，要不然看不出效果，越近的动画时间越长
        group.beginTime = CACurrentMediaTime() + (self.animationDuration / self.buttonsArr.count) * btn.tag + 0.1;
        
        /**
         fillMode的作用就是决定当前对象过了非active时间段的行为. 比如动画开始之前,动画结束之后。如果是一个动画CAAnimation,则需要将其removedOnCompletion设置为NO,要不然fillMode不起作用.
         
         下面来讲各个fillMode的意义
         kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
         kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
         kCAFillModeBackwards 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
         kCAFillModeBoth 理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.
         */
        // 保持动画执行完成后的样子
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        
        // 设置动画特效
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        // 添加动画
        [btn.layer addAnimation:group forKey:@"groupAnimation"];
        // 按钮的最后位置
        btn.layer.position = endPoint;
        // 按钮还没有开始的时候让他缩放的最小，到时候执行动画的时候就会有放大的效果
        btn.transform = CGAffineTransformMakeScale(0.01, 0.01);
        return self;
    };

}

#pragma mark -------------- 手势处理 -----------------
- (void)SCX_TapHandle:(UITapGestureRecognizer *)tap{
    
}
#pragma mark -------------- 懒加载 -----------------
- (NSArray *)buttonsArr{
    
    if (!_buttonsArr) {
        _buttonsArr = [NSMutableArray array];
    }
    return _buttonsArr;
}
#pragma mark -------------- 共有方法 -----------------
#pragma mark -------------- 添加按钮 -----------------
- (void)SCX_MakeConfig:(void (^) (SCXPopView *make))block{
        block(self);
}

/**
 指针

 @return 指针
 */
- (SCX_SelfPoint)SCX{
    return ^ SCXPopView *{
        
        return self;
    };
}

/**
 设置主视图

 */
- (SCXPopView *(^) (UIView *mainView))SCX_MainView{
    return ^SCXPopView *(UIView *mainView){
        if (_mainView != mainView) {
            _mainView = mainView;
        }
        if ([_mainView isDescendantOfView:self] == false) {
            [self addSubview:_mainView];
            [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            
                make.width.height.mas_equalTo(SCX_DefaultBtnHeight);
            }];
            SCX_Self._ConfigMainViewFrame;
            [self layoutIfNeeded];
            
            _mainView.layer.cornerRadius = _mainView.frame.size.height / 2.f;
            _mainView.layer.masksToBounds = YES;
            
        }
        return self;
    };

}
/**
 添加弹出的按钮数组
 */

- (SCXPopView * (^) (NSArray *arr))SCX_AddButtons{
    return ^SCXPopView *(NSArray *arr){
        if (arr == nil) {
            return self;
        }
        for (UIButton *btn in arr) {
            SCX_Self._AddButton(btn);
        }
        
        return self;
    };

}

#pragma mark -------------- 按钮展示和消失 -----------------

/**
 展示按钮
 */
- (void)SCX_ShowButtons{

    // 标记弹出动画
    self.selected = YES;
    // 先根据不同方向配置Frame
    SCX_Self._configButtonsFrameFromDirection;
    // 动画期间不允许多次点击
    self.userInteractionEnabled = NO;
    
    // 动画事物
    [CATransaction begin];
    [CATransaction setAnimationDuration:self.animationDuration];
    
    // 动画完成后回调，将按钮恢复为原来的样子
    [CATransaction setCompletionBlock:^{
        for (UIButton *btn in self.buttonsArr) {
            btn.transform = CGAffineTransformIdentity;
        }
        // 动画执行完毕可以再次点击
        self.userInteractionEnabled = YES;
    }];
    
    // 设置每个button动画的其实位置
    for (NSInteger i= 0; i < self.buttonsArr.count; i ++) {
        
        // 取出button ， 因为动画是从后往前排的，第一个Button放在最远处 ，所以说为了避免传过来的数组，在显示的时候，第一个跑到了最后面，所以这里从后往前取，保持一致
        UIButton *btn = self.buttonsArr[self.buttonsArr.count - 1 - i];
        btn.hidden = NO;
        btn.tag = i;
        // 开始布局每个按钮的frame
        SCX_Self._configEveryButtonAnimationFrame(^ (CGPoint beginPoint, CGPoint endPoint){
        
            // 开始动画
            SCX_Self._beginAnimation(beginPoint , endPoint , btn , NO);
        } ,btn);
        
    }
    
}

/**
 消失按钮
 */
- (void)SCX_DismissButtons{

    // 标记消失动画
    self.selected = NO;
    
    // 开始动画
    [CATransaction begin];
    [CATransaction setAnimationDuration:self.animationDuration];
    [CATransaction setCompletionBlock:^{
        for (UIButton *btn  in self.buttonsArr) {
            btn.hidden = YES;
            btn.transform = CGAffineTransformIdentity;
        }
        // 将frame改成最初是的frame
        self.frame = self.originFrame;
        self.userInteractionEnabled = YES;
    }];
    
    // 开始配置每一个按钮的位置，开始动画
    for (NSInteger i = 0;i < self.buttonsArr.count ;i ++) {
        UIButton *btn = self.buttonsArr[self.buttonsArr.count - 1 - i];
        btn.tag = self.buttonsArr.count - 1 - i;
        CGPoint beginPoint = btn.layer.position;
        // 传入btn获取每一个btn的终点位置
        SCX_Self._ConfigEveryBtnEndPoint(^ (CGPoint endPoint){
        
            // 开始消失动画
            SCX_Self._beginAnimation(beginPoint , endPoint , btn , YES);
        } , btn);
        
    }
    
    
    
}

#pragma mark -------------- 点击方法 -----------------
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.selected) {
         SCX_Self.SCX_ShowButtons;
    }
    else{
    
        SCX_Self.SCX_DismissButtons;
    }
   
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

@end
