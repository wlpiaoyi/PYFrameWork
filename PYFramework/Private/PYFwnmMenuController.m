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
#import "PYFrameworkUtile.h"


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
-(void) setMenuStyle:(NSArray<NSDictionary *> *)menuStyle{
    _menuStyle = menuStyle;
    NSMutableArray * buttons = [NSMutableArray new];
    for (NSDictionary * style in menuStyle) {
        NSString * title = style[PYFwnmMenuTitle];
        UIFont * font = style[PYFwnmMenuTitleFontNormal];
        UIColor * color = style[PYFwnmMenuTitleColorNormal];
        UIImage * image = style[PYFwnmMenuImageNormal];
        UIImage * imageNormal = [PYFrameworkUtile createImageWithTitle:title font:font color:color image:image offH:5];
        if(style[PYFwnmMenuTitleFontHigthlight]) font = style[PYFwnmMenuTitleFontHigthlight];
        if(style[PYFwnmMenuTitleColorHigthlight]) color = style[PYFwnmMenuTitleColorHigthlight];
        if(style[PYFwnmMenuImageHigthlight]) image = style[PYFwnmMenuImageHigthlight];
        UIImage * imageHigthlight = [PYFrameworkUtile createImageWithTitle:title font:font color:color image:image offH:5];
        if(style[PYFwnmMenuTitleFontSelected]) font = style[PYFwnmMenuTitleFontSelected];
        if(style[PYFwnmMenuTitleColorSelected]) color = style[PYFwnmMenuTitleColorSelected];
        if(style[PYFwnmMenuImageSelected]) image = style[PYFwnmMenuImageSelected];
        UIImage * imageSelected = [PYFrameworkUtile createImageWithTitle:title font:font color:color image:image offH:5];
        PYFwnmMemuButton * button = [PYFwnmMemuButton buttonWithType:UIButtonTypeCustom];
        [button setImage:imageNormal forState:UIControlStateNormal];
        [button setImage:imageHigthlight forState:UIControlStateHighlighted];
        [button setImage:imageSelected forState:UIControlStateSelected];
        imageNormal = style[PYFwnmMenuBGImageNormal];
        imageHigthlight = style[PYFwnmMenuBGImageHigthlight];
        imageSelected = style[PYFwnmMenuBGImageSelected];
        if(imageNormal) [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
        if(imageHigthlight) [button setBackgroundImage:imageHigthlight forState:UIControlStateHighlighted];
        if(imageSelected) [button setBackgroundImage:imageSelected forState:UIControlStateSelected];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
