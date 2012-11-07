//
//  TFDocument.h
//  TemplateEditor
//
//  Created by Tom Fewster on 02/10/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TFDocument : NSDocument

@property (strong) NSMutableAttributedString *documentContents;

@end
