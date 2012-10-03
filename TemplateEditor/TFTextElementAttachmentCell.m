//
//  TFTextElementAttachmentCell.m
//  NSTokenFieldTest
//
//  Created by Tom Fewster on 02/10/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import "TFTextElementAttachmentCell.h"

#define VERTICAL_PADDING 0.0f
#define HORIZONTAL_PADDING 5.0f

@interface TFTextElementAttachmentCell ()
@property (strong) NSDictionary *textAttributes;
@end

@implementation TFTextElementAttachmentCell

@synthesize element = _element;
@synthesize font = _font;
@synthesize textAttributes = _textAttributes;

- (void)setFont:(NSFont *)font {
	[self willChangeValueForKey:@"font"];
	_font = font;
	[self didChangeValueForKey:@"font"];
	_textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName, [NSColor blackColor], NSForegroundColorAttributeName, nil];
}

- (NSSize)cellSize {
	NSSize elementSize = [_element sizeWithAttributes:_textAttributes];
	return NSMakeSize(elementSize.width + HORIZONTAL_PADDING + HORIZONTAL_PADDING, elementSize.height + VERTICAL_PADDING + VERTICAL_PADDING);
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)aView {

	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:cellFrame.size.height/2.0f yRadius:cellFrame.size.height/2.0f];
	path.lineWidth = 1.0f;
	[[NSColor colorWithCalibratedRed:0.914 green:0.937 blue:0.984 alpha:1] set];
	[path fill];
	[[NSColor colorWithCalibratedRed:0.765 green:0.824 blue:0.957 alpha:1] set];
	[path stroke];
	[super drawWithFrame:cellFrame inView:aView];

	[_element drawAtPoint:NSMakePoint(cellFrame.origin.x + HORIZONTAL_PADDING, cellFrame.origin.y + VERTICAL_PADDING) withAttributes:_textAttributes];
}

- (NSPoint)cellBaselineOffset {
	return NSMakePoint(0.0f, -3.0);
}

@end
