//
//  TFTextElementAttachmentCell.m
//  NSTokenFieldTest
//
//  Created by Tom Fewster on 02/10/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import "TFTextElementAttachmentCell.h"

#define VERTICAL_PADDING -2.0f
#define HORIZONTAL_PADDING 5.0f

@interface TFTextElementAttachmentCell ()
@property (strong) NSDictionary *textAttributes;
@end

@implementation TFTextElementAttachmentCell

@synthesize element = _element;
@synthesize font = _font;
@synthesize textAttributes = _textAttributes;
@synthesize conditionalBlock = _conditionalBlock;

- (id)init {
	if ((self = [super init])) {
		self.font = [NSFont fontWithName:@"Menlo Regular" size:11.0f];
	}

	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	TFTextElementAttachmentCell *copy = [[[self class] allocWithZone:zone] init];
	copy.font = self.font;
	copy.textAttributes = self.textAttributes;
	return copy;
}

- (void)setFont:(NSFont *)font {
	[self willChangeValueForKey:@"font"];
	_font = font;
	[self didChangeValueForKey:@"font"];
	if (_font) {
		_textAttributes = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : [NSColor darkGrayColor] };
	} else {
		_textAttributes = @{ NSForegroundColorAttributeName : [NSColor darkGrayColor] };
	}
}

- (NSSize)cellSize {
	NSString *str = [_element substringWithRange:NSMakeRange(2, _element.length - 4)];
	NSSize elementSize = [str sizeWithAttributes:_textAttributes];
	return NSMakeSize(elementSize.width + HORIZONTAL_PADDING + HORIZONTAL_PADDING, elementSize.height + VERTICAL_PADDING + VERTICAL_PADDING);
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)aView {

	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:cellFrame.size.height/2.0f yRadius:cellFrame.size.height/2.0f];
	path.lineWidth = 1.0f;
	[_conditionalBlock?[NSColor colorWithCalibratedRed:0.918 green:0.992 blue:0.941 alpha:1]:[NSColor colorWithCalibratedRed:0.914 green:0.937 blue:0.984 alpha:1] set];
	[path fill];
	[_conditionalBlock?[NSColor colorWithCalibratedRed:0.796 green:0.980 blue:0.859 alpha:1]:[NSColor colorWithCalibratedRed:0.765 green:0.824 blue:0.957 alpha:1] set];
	[path stroke];
	[super drawWithFrame:cellFrame inView:aView];

	NSString *str = [_element substringWithRange:NSMakeRange(2, _element.length - 4)];
//	_textAttributes = @{NSFontAttributeName : _font, NSForegroundColorAttributeName: [NSColor blackColor]};

	[str drawAtPoint:NSMakePoint(cellFrame.origin.x + HORIZONTAL_PADDING, cellFrame.origin.y + VERTICAL_PADDING + VERTICAL_PADDING) withAttributes:_textAttributes];
}

- (NSPoint)cellBaselineOffset {
	return NSMakePoint(0.0f, -3.0);
}

@end
