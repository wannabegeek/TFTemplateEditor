//
//  TFTemplateCodeTextView.m
//  TFTemplateEditor
//
//  Created by Tom Fewster on 06/11/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import "TFTemplateCodeTextView.h"
#import "NSMutableAttributedString+TokenFields.h"

#import "TFTextElementAttachmentCell.h"


@interface TFTemplateCodeTextView ()
@end

@implementation TFTemplateCodeTextView

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:NSTextStorageWillProcessEditingNotification object:self.textStorage queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
		if (note.object == self.textStorage && (self.textStorage.editedMask & NSTextStorageEditedCharacters) == NSTextStorageEditedCharacters) {
			NSRange editedRange = self.textStorage.editedRange;

			[self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:self.textStorage.editedRange options:NSAttributedStringEnumerationReverse|NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
				//		NSAttributedString *b = [s attributedSubstringFromRange:range];
				if (value != nil) {
					NSTextAttachment *attachment = value;
					//			NSLog(@"%@", attachment.fileWrapper.preferredFilename);
					//[s replaceCharactersInRange:range withAttributedString:[[NSAttributedString alloc] initWithString:attachment.fileWrapper.preferredFilename]];

					TFTextElementAttachmentCell *cell = [[TFTextElementAttachmentCell alloc] init];
					cell.element = attachment.fileWrapper.preferredFilename;
					[attachment setAttachmentCell:cell];

					[self.textStorage replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
				}
			}];

			[self.textStorage replaceTokensInRange:editedRange];
		}
	}];

	self.delegate = self;
}

NSString *TFTemplatMarkupPboardType = @"com.wannabegeek.TemplateMarkup";

- (NSArray *)textView:(NSTextView *)aTextView writablePasteboardTypesForCell:(id <NSTextAttachmentCell>)cell atIndex:(NSUInteger)charIndex {
    return [NSArray arrayWithObject:TFTemplatMarkupPboardType];
}

- (BOOL)textView:(NSTextView *)aTextView writeCell:(id <NSTextAttachmentCell>)cell atIndex:(NSUInteger)charIndex toPasteboard:(NSPasteboard *)pboard type:(NSString *)type {
    if (type == TFTemplatMarkupPboardType) {
		NSString *wrapperFileName = ((TFTextElementAttachmentCell *)cell).element;
		NSData *data = [wrapperFileName dataUsingEncoding:NSUTF8StringEncoding];
		NSFileWrapper *wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
		wrapper.filename = wrapperFileName;
		wrapper.preferredFilename = wrapperFileName;

		NSTextAttachment *t = [[NSTextAttachment alloc] initWithFileWrapper:wrapper];
		[t setAttachmentCell:cell];

		NSAttributedString *s = [NSAttributedString attributedStringWithAttachment:t];
        [pboard writeObjects:[NSArray arrayWithObject:s]];
    }

    return YES;
}

@end
