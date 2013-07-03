//
//  Prefs.h
//  AdiURLShortener
//
//  Created by michele bonazza on 25/06/2013.
//  Copyright (c) 2013 MB. All rights reserved.
//
// This file is part of AdiURLShortener.
//
// AdiURLShortener is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// AdiURLShortener is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with AdiURLShortener.  If not, see <http://www.gnu.org/licenses/>.

#import <Cocoa/Cocoa.h>
#import <Adium/AIAdvancedPreferencePane.h>
#import "AdiURLShortener.h"

@interface Prefs : AIAdvancedPreferencePane {}

// items that set preferences
@property (assign) IBOutlet NSButton *shortenImageLinks;
@property (assign) IBOutlet NSButton *incomingEnabled;
@property (assign) IBOutlet NSTextField *incomingMinLength;
@property (assign) IBOutlet NSButton *outgoingEnabled;
@property (assign) IBOutlet NSTextField *outgoingMinLength;
@property (assign) IBOutlet NSMatrix *whichShortener;

// items that do nothing at all
@property (assign) IBOutlet NSTextField *prettifyWarning;

- (IBAction)radioSelectorAction:(id)sender;

@end
