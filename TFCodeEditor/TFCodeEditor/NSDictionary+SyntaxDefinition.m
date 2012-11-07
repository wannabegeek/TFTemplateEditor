//
//  NSDictionary+SyntaxDefinition.m
//  TFTemplateEditor
//
//  Created by Tom Fewster on 02/11/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import "NSDictionary+SyntaxDefinition.h"

#define ReplaceNilWithEmptyString(str) str?str:@""

NSString *TFMultilineComment = @"TFMultilineComment";
NSString *TFSingleLineComment = @"TFSingleLineComment";
NSString *TFString1Charactor = @"TFString1Charactor";
NSString *TFString2Charactor = @"TFString2Charactor";
NSString *TFCommandStart = @"TFCommandStart";
NSString *TFCommandEnd = @"TFCommandEnd";

@implementation NSDictionary (SyntaxDefinition)

- (NSString *)commandStart {
	return [self valueForKey:TFCommandStart];
}

- (NSString *)commandEnd {
	return [self valueForKey:TFCommandEnd];
}

- (NSString *)multilineComment {
	return [self valueForKey:TFMultilineComment];
}

- (NSString *)singleLineComment {
	return [self valueForKey:TFSingleLineComment];
}

- (NSString *)string1Charactor {
	return [self valueForKey:TFString1Charactor];
}

- (NSString *)string2Charactor {
	return [self valueForKey:TFString2Charactor];
}

- (NSRegularExpression *)stringMatch {
	NSError *error = nil;
	NSString *pattern = [NSString stringWithFormat:@"[%@%@].*?[%@%@]", ReplaceNilWithEmptyString(self.string1Charactor), ReplaceNilWithEmptyString(self.string2Charactor), ReplaceNilWithEmptyString(self.string1Charactor), ReplaceNilWithEmptyString(self.string2Charactor)];
	NSRegularExpression *stringMatch = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&error];
	return stringMatch;
}

- (NSRegularExpression *)multilineCommentMatch {
	NSRegularExpression *stringMatch = nil;
	if (self.multilineComment) {
		NSError *error = nil;
		stringMatch = [NSRegularExpression regularExpressionWithPattern:self.multilineComment options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:&error];
	}
	return stringMatch;
}

- (NSRegularExpression *)singlelineCommentMatch {
	NSRegularExpression *stringMatch = nil;
	if (self.singleLineComment) {
		NSError *error = nil;
		stringMatch = [NSRegularExpression regularExpressionWithPattern:self.singleLineComment options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines error:&error];
	}
	return stringMatch;
}

- (NSRegularExpression *)keywordMatch {
	NSRegularExpression *stringMatch = nil;
	NSMutableString *keywords = [NSMutableString string];

	for (NSString *keyword in [self valueForKey:@"keywords"]) {
		[keywords appendFormat:@"%@%@", (keywords.length?@"|":@""), keyword];
	}
	if (keywords.length) {
		NSError *error = nil;
		stringMatch = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"(%@)", keywords] options:NSRegularExpressionCaseInsensitive error:&error];
	}
	return stringMatch;
}

- (NSRegularExpression *)commandMatch {
	NSRegularExpression *stringMatch = nil;
	NSMutableString *command = [NSMutableString string];
	if (self.commandStart) {
		[command appendFormat:@"%@.*?", [NSRegularExpression escapedPatternForString:self.commandStart]];
	}
	if (self.commandEnd) {
		[command appendFormat:@"%@", [NSRegularExpression escapedPatternForString:self.commandEnd]];
	}
	if (command.length) {
		NSError *error = nil;
		stringMatch = [NSRegularExpression regularExpressionWithPattern:command options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines|NSRegularExpressionDotMatchesLineSeparators error:&error];
	}
	return stringMatch;
}

@end
