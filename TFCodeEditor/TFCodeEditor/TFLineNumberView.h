
#import <Cocoa/Cocoa.h>

@class TFLineNumberMarker;

@interface TFLineNumberView : NSRulerView

- (id)initWithScrollView:(NSScrollView *)aScrollView;

- (id)initWithScrollView:(NSScrollView *)scrollView orientation:(NSRulerOrientation)orientation;

- (void)setFont:(NSFont *)aFont;
- (NSFont *)font;

- (void)setTextColor:(NSColor *)color;
- (NSColor *)textColor;

- (void)setAlternateTextColor:(NSColor *)color;
- (NSColor *)alternateTextColor;

- (void)setBackgroundColor:(NSColor *)color;
- (NSColor *)backgroundColor;

- (NSUInteger)lineNumberForLocation:(CGFloat)location;
- (TFLineNumberMarker *)markerAtLine:(NSUInteger)line;

@end
