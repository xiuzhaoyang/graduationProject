//
//  ViewController.m
//  graduationProject
//
//  Created by ZhaoyangSu on 12-11-27.
//  Copyright (c) 2012年 ZhaoyangSu. All rights reserved.
//

#import "ViewController.h"
#import "GLView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GLView *glView = [[GLView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:glView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotate
{
    return NO;
}

@end
