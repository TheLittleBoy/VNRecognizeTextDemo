//
//  ResultViewController.h
//  VNRecognizeTextDemo
//
//  Created by Mac on 2022/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (void)addRecognizedText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
