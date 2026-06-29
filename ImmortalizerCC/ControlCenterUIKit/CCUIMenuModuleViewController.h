#import <UIKit/UIKit.h>

@interface CCUIMenuModuleViewController : UIViewController
@property (nonatomic, retain) UIImage *glyphImage;
@property (nonatomic, retain) UIImage *selectedGlyphImage;
@property (nonatomic, retain) UIColor *selectedGlyphColor;
@property (nonatomic, copy) NSString *title;

- (void)setSelected:(BOOL)selected;
- (void)addActionWithTitle:(NSString *)title subtitle:(NSString *)subtitle glyph:(UIImage *)glyph handler:(dispatch_block_t)handler;
@end
