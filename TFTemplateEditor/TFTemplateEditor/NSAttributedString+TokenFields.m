//
//  NSAttributedString+TokenFields.m
//  TFTemplateEditor
//
//  Created by Tom Fewster on 07/11/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import "NSAttributedString+TokenFields.h"

@implementation NSAttributedString (TokenFields)

- (NSAttributedString *)stringWithoutTokens {
	NSMutableAttributedString *s = [self mutableCopy];

	NSUInteger N = 0;
	while (N < s.length) {
		NSRange theEffectiveRange;
		NSDictionary *theAttributes = [s attributesAtIndex:N longestEffectiveRange:&theEffectiveRange inRange:NSMakeRange(0, s.length)];
		NSTextAttachment *attachment = [theAttributes objectForKey:NSAttachmentAttributeName];
		if (attachment != NULL) {
			//			NSLog(@"%@", attachment.fileWrapper.preferredFilename);
			//			[theAttachments addObject:theAttachment];
		}
		N = theEffectiveRange.location + theEffectiveRange.length;
	}

	[s enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, s.length) options:NSAttributedStringEnumerationReverse|NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
		//		NSAttributedString *b = [s attributedSubstringFromRange:range];
		if (value != nil) {
			NSTextAttachment *attachment = value;
			//			NSLog(@"%@", attachment.fileWrapper.preferredFilename);
			[s replaceCharactersInRange:range withAttributedString:[[NSAttributedString alloc] initWithString:attachment.fileWrapper.preferredFilename]];
		}
	}];

	return s;
}

@end
