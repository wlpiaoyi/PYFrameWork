//
//  ViewController.m
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Expand.h"
#import "PYViewAutolayoutCenter.h"
#import "PYFwnmParam.h"
#import "UIImage+Expand.h"
#import "PYGraphicsDraw.h"
#import <CoreText/CoreText.h>

@interface ViewController () <PYFrameworkAllTag>{
@private UIButton * buttonNext;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * view = [UIView new];
    [view setCornerRadiusAndBorder:1 borderWidth:1 borderColor:[UIColor greenColor]];
    [self.view addSubview:view];
    [PYViewAutolayoutCenter persistConstraint:view relationmargins:UIEdgeInsetsMake(5, 5, 5, 5) relationToItems:PYEdgeInsetsItemNull()];
    [self.view setCornerRadiusAndBorder:1 borderWidth:1 borderColor:[UIColor redColor]];
    buttonNext = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonNext.frame = CGRectMake(0, 68, 100, 100);
    [buttonNext setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [buttonNext.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:buttonNext];
    [buttonNext addTarget:self action:@selector(onClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIFont * font = [UIFont boldSystemFontOfSize:24];
    NSAttributedString * attribute = [[NSAttributedString alloc] initWithString:@"哈哈哈" attributes:@{(NSString *)kCTForegroundColorAttributeName:[UIColor greenColor],(NSString *)kCTFontAttributeName:font}];
    CGSize size = [PYUtile getBoundSizeWithAttributeTxt:attribute size:CGSizeMake(999, [PYUtile getFontHeightWithSize:font.pointSize fontName:font.fontName])];
    UIImage * image = [UIImage imageWithSize:size blockDraw:^(CGContextRef  _Nonnull context, CGRect rect) {
        CGSize s = [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:CGRectMake(0, 0, 400, 400) y:rect.size.height scaleFlag:YES];
        s = s;
    }];
    image = [ViewController createImageWithTitle:@"哈哈哈哈" font:[UIFont boldSystemFontOfSize:26] color:[UIColor redColor] image:image offH:5];
    [buttonNext setImage:image forState:UIControlStateNormal];
    [buttonNext setContentMode:UIViewContentModeScaleAspectFit];
    
    // Do any additional setup after loading the view, typically from a nib.
}

+(UIImage *) createImageWithTitle:(NSString *) title font:(UIFont *) font color:(UIColor *) color image:(UIImage *) image offH:(CGFloat) offH{
    
    NSAttributedString * attribute = [[NSAttributedString alloc] initWithString:title attributes:@{(NSString *)kCTForegroundColorAttributeName:color,(NSString *)kCTFontAttributeName:font}];
    CGSize tSize = [PYUtile getBoundSizeWithAttributeTxt:attribute size:CGSizeMake(999, [PYUtile getFontHeightWithSize:font.pointSize fontName:font.fontName])];
    UIImage * tImage = [UIImage imageWithSize:tSize blockDraw:^(CGContextRef  _Nonnull context, CGRect rect) {
        [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:CGRectMake(0, 0, 400, 400) y:rect.size.height scaleFlag:YES];
    }];
    tImage = [tImage setImageSize:CGSizeMake(tImage.size.width/2, tImage.size.height/2)];
    tSize = tImage.size;
    CGSize tS = CGSizeMake(MAX(tSize.width, image.size.width), tSize.height + offH + image.size.height);
    UIGraphicsBeginImageContextWithOptions(tS, NO, 2);
    [tImage drawInRect:CGRectMake((tS.width - tSize.width)/2, 0, tImage.size.width, tImage.size.height)];
    [image drawInRect:CGRectMake((tS.width - image.size.width)/2, tSize.height + offH, image.size.width, image.size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)onClicked {
    NSMutableString * str = [NSMutableString stringWithUTF8String:"vc"];
    [str appendString:@(self.navigationController.viewControllers.count).stringValue];
    [self performSegueWithIdentifier:str sender:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
