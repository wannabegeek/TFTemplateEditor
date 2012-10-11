//
//  TFTemplateTextStorage.m
//  TFTemplateEditor
//
//  Created by Tom Fewster on 11/10/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import "TFTemplateTextStorage.h"

@interface TFTemplateTextStorage()
@property (strong) NSMutableAttributedString *backingStore;
@end

@implementation TFTemplateTextStorage

@synthesize backingStore = _backingStore;

- (id)init {
	if ((self = [super init])) {
		_backingStore = [[NSMutableAttributedString alloc] init];
	}

	return self;
}

- (id)initWithAttributedString:(NSAttributedString *)attrStr {
	if ((self = [super init])) {
		_backingStore = [[NSMutableAttributedString alloc] initWithAttributedString:attrStr];
	}

	return self;
}

- (NSString *)string {
	return _backingStore.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange {
	return [_backingStore attributesAtIndex:index effectiveRange:aRange];
}

- (void)replaceCharactersInRange:(NSRange)aRange withString:(NSString *)aString {
	return [_backingStore replaceCharactersInRange:aRange withString:aString];
}

- (void)setAttributes:(NSDictionary *)attributes range:(NSRange)aRange {
	return [_backingStore setAttributes:attributes range:aRange];
}

@end
