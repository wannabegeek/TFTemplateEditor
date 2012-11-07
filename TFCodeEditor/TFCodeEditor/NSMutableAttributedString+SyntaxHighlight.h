//
//  NSMutableAttributedString+SyntaxHighlight.h
//  TFTemplateEditor
//
//  Created by Tom Fewster on 03/11/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMutableAttributedString (SyntaxHighlight)

- (void)applySyntaxHighlight:(NSDictionary *)syntaxDefinition inRange:(NSRange)range;

@end
