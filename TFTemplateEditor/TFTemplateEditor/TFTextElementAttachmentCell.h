//
//  TFTextElementAttachmentCell.h
//  NSTokenFieldTest
//
//  Created by Tom Fewster on 02/10/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TFTextElementAttachmentCell : NSTextAttachmentCell

@property (copy) NSString *element;
@property (nonatomic, strong) NSFont *font;

@property (assign) BOOL conditionalBlock;
@end
