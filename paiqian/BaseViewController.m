//
//  BaseViewController.m
//  paiqian
//
//  Created by LuoJiee on 15/9/24.
//  Copyright © 2015年 LuoJiee. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.navigationController  viewControllers].count > 1) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = YES ;
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self ;
        
    }
    // Do any additional setup after loading the view.
}

-(IBAction)backButtonClick:(id)sender{
    
    if ([self.navigationController childViewControllers].count > 1 ) {
        
        [self.navigationController  popViewControllerAnimated:YES] ;
        
    }else {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }]  ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
