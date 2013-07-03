//
//  Prefs.m
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

#import "Prefs.h"
#import <Adium/AIPreferenceControllerProtocol.h>

@implementation Prefs

- (NSString *)label {
	return APP_NAME;
}

- (NSString *)nibName {
    return @"Prefs";
}

- (NSImage *)image {
    NSString* img = [[NSBundle bundleForClass:[self class]] pathForResource:@"icon" ofType:@"png"];
    return [[NSImage alloc] initWithContentsOfFile:img];
}

- (NSString *)paneIdentifier {
	return APP_NAME;
}

- (AIPreferenceCategory)category {
    return AIPref_Advanced;
}


-(void)viewDidLoad {
    NSInteger shortenImageLinks = [[[adium preferenceController] preferenceForKey:KEY_SHORTEN_IMAGE_LINKS group:APP_NAME] boolValue];
    [_shortenImageLinks setState:shortenImageLinks];
    
    NSInteger incomingEnabled = [[[adium preferenceController] preferenceForKey:KEY_INCOMING_ENABLED
                                                                          group:APP_NAME] boolValue];
    [_incomingEnabled setState:incomingEnabled];
    [_incomingMinLength setEnabled:incomingEnabled];
    
    NSInteger minIncomingLength = [[[adium preferenceController] preferenceForKey:KEY_MIN_INCOMING group:APP_NAME] intValue];
    [_incomingMinLength setStringValue:[NSString stringWithFormat:@"%li", minIncomingLength]];
    
    NSInteger outgoingEnabled = [[[adium preferenceController] preferenceForKey:KEY_OUTGOING_ENABLED
                                                                          group:APP_NAME] boolValue];
    [_outgoingEnabled setState:outgoingEnabled];
    [_outgoingMinLength setEnabled:outgoingEnabled];
    
    NSInteger minOutgoingLength = [[[adium preferenceController] preferenceForKey:KEY_MIN_OUTGOING group:APP_NAME] intValue];
    [_outgoingMinLength setStringValue:[NSString stringWithFormat:@"%li", minOutgoingLength]];
    
    NSInteger type = [[[adium preferenceController] preferenceForKey:KEY_SHORTENER_TYPE group:APP_NAME] intValue];
    [_whichShortener selectCellWithTag:type];
    if (type == VALUE_PRETTIFY)
        _prettifyWarning.hidden = false;
}

-(void) setPreference: (id)value forKey:(NSString *)key {
    NSObject<AIPreferenceController> *apref=[adium preferenceController];
    @try {
        [apref setPreference:value forKey:key group: APP_NAME];
    } @catch (NSException *excp) {
        NSLog(@"set preference exception %@",excp);
    }
}

- (IBAction)changePreference:(id)sender {
    if (sender == _shortenImageLinks) {
        [self setPreference:[NSNumber numberWithBool:[sender state]] forKey:KEY_SHORTEN_IMAGE_LINKS];
    } else if (sender == _incomingEnabled) {
        [self setPreference: [NSNumber numberWithBool:[sender state]] forKey:KEY_INCOMING_ENABLED];
        [_incomingMinLength setEnabled:[sender state]];
    } else if (sender == _outgoingEnabled) {
        [self setPreference: [NSNumber numberWithBool:[sender state]] forKey:KEY_OUTGOING_ENABLED];
        [_outgoingMinLength setEnabled:[sender state]];
        [_whichShortener setEnabled:[sender state]];
    } else if (sender == _incomingMinLength) {
        [self setPreference:[NSNumber numberWithInt:[[sender stringValue] intValue]] forKey:KEY_MIN_INCOMING];
    } else if (sender == _outgoingMinLength) {
        [self setPreference:[NSNumber numberWithInt:[[sender stringValue] intValue]] forKey:KEY_MIN_OUTGOING];
    }
}

- (IBAction)radioSelectorAction:(id)sender {
    NSInteger selectedItem=[sender selectedRow];
    
    [self setPreference:[NSNumber numberWithInt:(int)selectedItem] forKey:KEY_SHORTENER_TYPE];
    
    switch (selectedItem) {
        case VALUE_GOO_GL:
            _prettifyWarning.hidden = true;
            break;
        case VALUE_PRETTIFY:
            _prettifyWarning.hidden = false;
            break;
        default:
            _prettifyWarning.hidden = true;
            break;
    }
}

@end
