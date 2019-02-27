//
//  PYFwMenuController.m
//  PYFramework
//
//  Created by wlpiaoyi on 2017/8/20.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYFwMenuController.h"
#import "pyutilea.h"
#import "PYSelectorBarView.h"
#import "PYFrameworkUtile.h"


@interface PYFwnmMemuButton:UIButton
kPNSNN id identify;
@end
@implementation PYFwnmMemuButton @end
@interface PYFwMenuController ()
kPNSNN PYSelectorBarView *  menus;
@end

@implementation PYFwMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menus = [PYSelectorBarView new];
    [self.view addSubview:self.menus];
    [PYViewAutolayoutCenter persistConstraint:_menus relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
}
-(void) setColorSeletedBg:(UIColor *)colorSeletedBg{
    _colorSeletedBg = colorSeletedBg;
    self.menus.selectorTagHeight = self.colorSeletedHeight;
    self.menus.selectorTag = [UIView new];
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.menus.selectorTag = view;
    view = [UIView new];
    view.backgroundColor = self.colorSeletedBg;
    [self.menus.selectorTag addSubview:view];
    [view setAutotLayotDict:@{@"top":@0, @"left":@0, @"right":@0, @"bottom":@1}];
}
-(void) setMenuStyle:(NSArray<NSDictionary *> *)menuStyle{
    [self setMenuStyle:menuStyle maxHeight:0];
}
-(void) setMenuStyle:(NSArray<NSDictionary *> *)menuStyle maxHeight:(CGFloat) maxHeight{
    _menuStyle = menuStyle;
    NSMutableArray * buttons = [NSMutableArray new];
    for (NSDictionary * style in menuStyle) {
        NSString * title = style[PYFwMenuTitle];
        UIFont * font = style[PYFwMenuTitleFontNormal];
        UIColor * color = style[PYFwMenuTitleColorNormal];
        UIImage * image = style[PYFwMenuImageNormal];
        NSNumber * imgDirection = style[PYFwMenusImgDirection] ? : @(YES);
        CGFloat imageOffH = 0;
        if(maxHeight > 0) imageOffH = maxHeight - image.size.height;
        UIImage * imageNormal = [PYFrameworkUtile createImageWithTitle:title font:font color:color image:image offH:5 imageOffH:imageOffH direction:imgDirection.boolValue];
        if(style[PYFwMenuTitleFontHigthlight]) font = style[PYFwMenuTitleFontHigthlight];
        if(style[PYFwMenuTitleColorHigthlight]) color = style[PYFwMenuTitleColorHigthlight];
        if(style[PYFwMenuImageHigthlight]) image = style[PYFwMenuImageHigthlight];
        imageOffH = 0;
        if(maxHeight > 0) imageOffH = maxHeight - image.size.height;
        UIImage * imageHigthlight = [PYFrameworkUtile createImageWithTitle:title font:font color:color image:image offH:5 imageOffH:imageOffH direction:imgDirection.boolValue];
        if(style[PYFwMenuTitleFontSelected]) font = style[PYFwMenuTitleFontSelected];
        if(style[PYFwMenuTitleColorSelected]) color = style[PYFwMenuTitleColorSelected];
        if(style[PYFwMenuImageSelected]) image = style[PYFwMenuImageSelected];
        imageOffH = 0;
        if(maxHeight > 0) imageOffH = maxHeight - image.size.height;
        UIImage * imageSelected = [PYFrameworkUtile createImageWithTitle:title font:font color:color image:image offH:5 imageOffH:imageOffH direction:imgDirection.boolValue];
        PYFwnmMemuButton * button = [PYFwnmMemuButton buttonWithType:UIButtonTypeCustom];
        [button setImage:imageNormal forState:UIControlStateNormal];
        [button setImage:imageHigthlight forState:UIControlStateHighlighted];
        [button setImage:imageSelected forState:UIControlStateSelected];
        imageNormal = style[PYFwMenuBGImageNormal];
        imageHigthlight = style[PYFwMenuBGImageHigthlight];
        imageSelected = style[PYFwMenuBGImageSelected];
        if(imageNormal) [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
        if(imageHigthlight) [button setBackgroundImage:imageHigthlight forState:UIControlStateHighlighted];
        if(imageSelected) [button setBackgroundImage:imageSelected forState:UIControlStateSelected];
        button.identify = style[PYFwMenuIdentify];
        [buttons addObject:button];
    }
    self.menus.buttons = buttons;
    @unsafeify(self);
    [self.menus setBlockSelecteItem:^BOOL(NSUInteger index){
        @strongify(self);
        PYFwnmMemuButton * button  = self.menus.buttons[index];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
