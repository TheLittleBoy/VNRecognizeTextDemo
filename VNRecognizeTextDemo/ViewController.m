//
//  ViewController.m
//  VNRecognizeTextDemo
//
//  Created by Mac on 2022/6/17.
//

#import "ViewController.h"
#import <VisionKit/VisionKit.h>
#import <Vision/Vision.h>
#import "ResultViewController.h"

@interface ViewController ()<VNDocumentCameraViewControllerDelegate>

@property(nonatomic, strong) VNRecognizeTextRequest *textRecognitionRequest;
@property(nonatomic, strong) ResultViewController *resultViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textRecognitionRequest = [[VNRecognizeTextRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        //
        NSMutableString *string = [NSMutableString string];
        NSArray<VNRecognizedTextObservation*> *result = [request results];
        for (VNRecognizedTextObservation *observation in result) {
            
            //取可信度最高的一个结果
            VNRecognizedText *candidate = [[observation topCandidates:1] firstObject];
            if (candidate) {
                [string appendString:candidate.string];
                [string appendString:@"\n"];
            }
        }
        
        NSLog(@"%@",string);
        
        //主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.resultViewController addRecognizedText:string];
        });
    }];
    
    self.textRecognitionRequest.recognitionLevel = VNRequestTextRecognitionLevelAccurate; //精确的
    self.textRecognitionRequest.usesLanguageCorrection = NO;    //禁用语言更正，更具性能优势
    self.textRecognitionRequest.recognitionLanguages = @[@"zh-Hans"]; //iOS 14及以上系统支持简体中文
}

- (IBAction)scanButtonAction:(id)sender {
    
    VNDocumentCameraViewController *documentCameraViewController = [[VNDocumentCameraViewController alloc] init];
    documentCameraViewController.delegate = self;
    [self presentViewController:documentCameraViewController animated:YES completion:nil];
    
}

#pragma mark - VNDocumentCameraViewControllerDelegate

- (void)documentCameraViewController:(VNDocumentCameraViewController *)controller didFinishWithScan:(VNDocumentCameraScan *)scan
{
    NSLog(@"Finish With Scan");
    
    [controller dismissViewControllerAnimated:YES completion:^{
        //
    }];
    
    //异步执行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (int i = 0;i<scan.pageCount;i++) {
            
            UIImage *image = [scan imageOfPageAtIndex:i];
            
            NSError *error;
            VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage options:@{}];
            [handler performRequests:@[self.textRecognitionRequest] error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
        }
        
    });
    [self performSegueWithIdentifier:@"resultViewController" sender:nil];
    
    NSLog(@"push");
}

// The delegate will receive this call when the user cancels.
- (void)documentCameraViewControllerDidCancel:(VNDocumentCameraViewController *)controller
{
    NSLog(@"Did Cancel");
    
    [controller dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

// The delegate will receive this call when the user is unable to scan, with the following error.
- (void)documentCameraViewController:(VNDocumentCameraViewController *)controller didFailWithError:(NSError *)error
{
    NSLog(@"Fail With Error:%@",error);
    
    [controller dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.resultViewController = [segue destinationViewController];
    
}

@end
