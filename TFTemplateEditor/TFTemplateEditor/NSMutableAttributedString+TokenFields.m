//
//  NSMutableAttributedString+TokenFields.m
//  TFTemplateEditor
//
//  Created by Tom Fewster on 06/11/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import "NSMutableAttributedString+TokenFields.h"
#import "TFTextElementAttachmentCell.h"

@implementation NSMutableAttributedString (TokenFields)

- (BOOL)replaceTokensInRange:(NSRange)range {

	if (range.length) {
		NSError *error = nil;

		NSRegularExpression *logicalMatch = [NSRegularExpression regularExpressionWithPattern:@"\\{\%[\\w\\d\\s.-|]*%\\}"
																					  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
																						error:&error];

		NSString *documentAsString = self.string;
		NSLog(@"Orig Length %ld", documentAsString.length);

		NSAssert(range.location + range.length <= documentAsString.length, @"Range is out side string (%ld > %ld)", range.location + range.length, documentAsString.length);

		__block NSRange adjustedRange = range;

		[[logicalMatch matchesInString:documentAsString options:0 range:range] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL *stop) {
			if (result) {
				TFTextElementAttachmentCell *cell = [[TFTextElementAttachmentCell alloc] init];
				cell.element = [documentAsString substringWithRange:result.range];
				cell.conditionalBlock = YES;
				//			NSLog(@"Found: %@", cell.element);

				NSString *wrapperFileName = cell.element;
				NSData *data = [cell.element dataUsingEncoding:NSUTF8StringEncoding];
				NSFileWrapper *wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
				wrapper.filename = wrapperFileName;
				wrapper.preferredFilename = wrapperFileName;

				NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithFileWrapper:wrapper];
				[attachment setAttachmentCell:cell];
				NSAttributedString *element = [NSMutableAttributedString attributedStringWithAttachment:attachment];

				[self replaceCharactersInRange:result.range withAttributedString:element];
				adjustedRange = NSMakeRange(adjustedRange.location, adjustedRange.length - result.range.length + 1);
			}
		}];

		documentAsString = self.string;
		NSLog(@"New Length %ld", documentAsString.length);

		NSRegularExpression *printMatch = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{[\\w\\d\\s.-|:\"']*\\}\\}"
																					options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
																					  error:&error];
		[[printMatch matchesInString:documentAsString options:0 range:adjustedRange] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL *stop) {
			if (result) {
				TFTextElementAttachmentCell *cell = [[TFTextElementAttachmentCell alloc] init];
				cell.element = [documentAsString substringWithRange:result.range];
				//		NSLog(@"Found: %@", cell.element);

				NSString *wrapperFileName = cell.element;
				NSData *data = [cell.element dataUsingEncoding:NSUTF8StringEncoding];
				NSFileWrapper *wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
				wrapper.filename = wrapperFileName;
				wrapper.preferredFilename = wrapperFileName;

				NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithFileWrapper:wrapper];
				[attachment setAttachmentCell:cell];
				NSAttributedString *element = [NSMutableAttributedString attributedStringWithAttachment:attachment];

				[self replaceCharactersInRange:result.range withAttributedString:element];
			}
		}];
	}
	
    return YES;
}

@end
