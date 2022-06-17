//
//  ResultViewController.m
//  VNRecognizeTextDemo
//
//  Created by Mac on 2022/6/17.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@property(nonatomic, strong) NSString * transcript;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.transcript = @"";
}

- (void)addRecognizedText:(NSString *)text {
    
    self.transcript = [NSString stringWithFormat:@"%@%@",self.transcript,text];
    
    self.textView.text = self.transcript;
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
