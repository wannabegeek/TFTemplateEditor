//
//  NSMutableAttributedString+TokenFields.h
//  TFTemplateEditor
//
//  Created by Tom Fewster on 06/11/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (TokenFields)

- (BOOL)replaceTokensInRange:(NSRange)range;

@end
