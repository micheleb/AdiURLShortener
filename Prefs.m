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
    NSInteger pluginEnabled=[[[adium preferenceController] preferenceForKey:KEY_ENABLED
        group:APP_NAME] boolValue];
    [_pluginEnabled setState:pluginEnabled];
    
    NSInteger type = [[[adium preferenceController] preferenceForKey:KEY_SHORTENER_TYPE group:APP_NAME] intValue];
    [_whichShortener selectCellWithTag:type];
    
    NSInteger urlMinLength = [[[adium preferenceController] preferenceForKey:KEY_URL_MIN_LENGTH group:APP_NAME] intValue];
    [_urlMinLength setStringValue:[NSString stringWithFormat:@"%li", urlMinLength]];
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
    if (sender == _pluginEnabled) {
        [self setPreference: [NSNumber numberWithBool:[sender state]] forKey:KEY_ENABLED];
        
        [_urlMinLength setEnabled:[sender state]];
        [_whichShortener setEnabled:[sender state]];
    } else if (sender == _urlMinLength) {
        [self setPreference:[NSNumber numberWithInt:[[sender stringValue] intValue]] forKey:KEY_URL_MIN_LENGTH];
    }
}

- (IBAction)radioSelectorAction:(id)sender {
    NSInteger selectedItem=[sender selectedRow];
    NSLog(@"Radio selector %li",(long)selectedItem);
    
    [self setPreference:[NSNumber numberWithInt:(int)selectedItem] forKey:KEY_SHORTENER_TYPE];
}

@end
