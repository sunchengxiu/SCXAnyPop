//
//  ViewController.m
//  自定义弹出按钮和方向
//
//  Created by 孙承秀 on 2017/3/30.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import "ViewController.h"
#import "SCXPopView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UILabel *label = [self creatHomeView:@"弹"];
    SCXPopView *popView = [[SCXPopView alloc]init];
    // popView的配置
    [popView SCX_MakeConfig:^(SCXPopView *make) {
        // 在这里切换位置，测试不同位置的pop
        make.SCX().initWithFrameAndDirection(CGRectMake((self.view.bounds.size.width - SCX_DefaultBtnHeight ) / 2,( self.view.bounds.size.height - SCX_DefaultBtnHeight) / 2,SCX_DefaultBtnHeight, SCX_DefaultBtnHeight) , SCX_ButtonPopDirectionUp);
        make.SCX().SCX_AddButtons([self creatBubbleBtnArray]);
        make.SCX().SCX_MainView(label);
        
    }];
    [self.view addSubview:popView];
    
    
    
}
- (NSArray *)creatBubbleBtnArray {
    NSMutableArray *buttonsArr = [NSMutableArray array];
    int i = 0;
    for (NSString *title in @[@"A",@"B",@"C",@"D"]) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setTitle:title forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        [button setBackgroundColor:[UIColor colorWithRed:229. / 255. green:229. / 255. blue:229. / 255. alpha:1.]];
        button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
        button.layer.cornerRadius = button.frame.size.width / 2.f;
        button.clipsToBounds = YES;
        button.tag = i++;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [buttonsArr addObject:button];
    }
    return [buttonsArr copy];
}
- (void)buttonAction:(UIButton *)btn{

    
}
- (UILabel *)creatHomeView:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
     //UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(0.f, 0.f, 40.f, 40.f))];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.backgroundColor = [UIColor lightGrayColor];
    label.clipsToBounds = YES;
    return label;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
