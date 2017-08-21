//
//  PYFwnmMenuController.m
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/20.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYFwnmMenuController.h"
#import "pyutilea.h"
#import "PYSelectorBarView.h"
#import "PYFwnmParam.h"
@interface PYFwnmMemuButton:UIButton
PYPNSNN id identify;
@end
@implementation PYFwnmMemuButton @end
@interface PYFwnmMenuController ()
PYPNSNN PYSelectorBarView *  menus;
@end

@implementation PYFwnmMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menus = [PYSelectorBarView new];
    [self.view addSubview:self.menus];
    [PYViewAutolayoutCenter persistConstraint:_menus relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
}
-(void) setColorSeletedBg:(UIColor *)colorSeletedBg{
    _colorSeletedBg = colorSeletedBg;
    self.menus.selectorColor = _colorSeletedBg;
}
-(void) setDictButtonStyle:(NSArray<NSDictionary *> *)dictButtonStyle{
    _dictButtonStyle = dictButtonStyle;
    NSMutableArray * buttons = [NSMutableArray new];
    for (NSDictionary * style in dictButtonStyle) {
        NSString * title = style[PYFwnmMenuTitle];
        UIFont * font = style[PYFwnmMenuTitleFont];
        UIColor * color = style[PYFwnmMenuTitleNormalColor];
        UIImage * image = style[PYFwnmMenuImageNormal];
        UIImage * imageNormal = [PYFwnmMenuController createImageWithTitle:title font:font color:color image:image offH:5];
         color = style[PYFwnmMenuTitleHigthlightColor];
         image = style[PYFwnmMenuImageHigthlight];
        UIImage * imageSelected = [PYFwnmMenuController createImageWithTitle:title font:font color:color image:image offH:5];
        PYFwnmMemuButton * button = [PYFwnmMemuButton buttonWithType:UIButtonTypeCustom];
        [button setImage:imageNormal forState:UIControlStateNormal];
        [button setImage:imageSelected forState:UIControlStateSelected];
        button.identify = style[PYFwnmMenuIdentify];
        [buttons addObject:button];
    }
    self.menus.buttons = buttons;
    @unsafeify(self);
    [self.menus setBlockSelecteItem:^BOOL(int index){
        @strongify(self);
        PYFwnmMemuButton * button  =self.menus.buttons[index];
        return self.blockOnclickMenu ? self.blockOnclickMenu(button.identify) : NO;
    }];
}

-(void) setSelectedMenuWithIdentify:(nonnull id) identify{
    int index = 0;
    for (PYFwnmMemuButton * button in self.menus.buttons) {
        if([button.identify isEqual:identify]) break;
        index ++;
    }
    [self.menus setSelectIndex:index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+(UIImage *) createImageWithTitle:(NSString *) title font:(UIFont *) font color:(UIColor *) color image:(UIImage *) image offH:(CGFloat) offH{
    
    NSAttributedString * attribute = [[NSAttributedString alloc] initWithString:title attributes:@{(NSString *)kCTForegroundColorAttributeName:color,(NSString *)kCTFontAttributeName:font}];
    CGSize tSize = [PYUtile getBoundSizeWithAttributeTxt:attribute size:CGSizeMake(999, [PYUtile getFontHeightWithSize:font.pointSize fontName:font.fontName])];
    UIImage * tImage = [UIImage imageWithSize:tSize blockDraw:^(CGContextRef  _Nonnull context, CGRect rect) {
        [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:CGRectMake(0, 0, 400, 400) y:rect.size.height scaleFlag:YES];
    }];
    
    tSize = CGSizeMake(tImage.size.width/2, tImage.size.height/2);
    tImage = [tImage setImageSize:tSize];
    
    tSize = tImage.size;
    CGSize tS = CGSizeMake(MAX(tSize.width, image.size.width), tSize.height + offH + image.size.height);
    UIGraphicsBeginImageContextWithOptions(tS, NO, 2);
    [tImage drawInRect:CGRectMake((tS.width - tSize.width)/2, 0, tImage.size.width, tImage.size.height)];
    [image drawInRect:CGRectMake((tS.width - image.size.width)/2, tSize.height + offH, image.size.width, image.size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
