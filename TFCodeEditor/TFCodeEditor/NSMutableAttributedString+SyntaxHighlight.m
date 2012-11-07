//
//  NSMutableAttributedString+SyntaxHighlight.m
//  TFTemplateEditor
//
//  Created by Tom Fewster on 03/11/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import "NSMutableAttributedString+SyntaxHighlight.h"
#import "NSDictionary+SyntaxDefinition.h"

@implementation NSMutableAttributedString (SyntaxHighlight)

- (void)applySyntaxHighlight:(NSDictionary *)syntaxDefinition inRange:(NSRange)range {

	// remove the old colors
	NSRange area = range;
	[self removeAttribute:NSForegroundColorAttributeName range:area];

	NSString *string = [self string];

	[syntaxDefinition.commandMatch enumerateMatchesInString:string options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionAnchorsMatchLines range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		[self addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:0.800 green:0.000 blue:0.631 alpha:1] range:result.range];

		[syntaxDefinition.keywordMatch enumerateMatchesInString:string options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators range:result.range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
			[self addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:0.627 green:0.502 blue:0.302 alpha:1] range:result.range];
		}];

		[syntaxDefinition.stringMatch enumerateMatchesInString:string options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators range:result.range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
			[self addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:0.886 green:0.000 blue:0.000 alpha:1] range:result.range];
		}];
	}];

	[syntaxDefinition.multilineCommentMatch enumerateMatchesInString:string options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		[self addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:0.000 green:0.557 blue:0.537 alpha:1] range:result.range];
	}];
	[syntaxDefinition.singlelineCommentMatch enumerateMatchesInString:string options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		[self addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:0.000 green:0.557 blue:0.537 alpha:1] range:result.range];
	}];
}

@end
