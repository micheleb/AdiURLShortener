//
//  AdiURLShortener.h
//  AdiURLShortener
//
//  Created by Michele Bonazza on May 25th, 2013.
//  Copyright (c) 2013 MB. All rights reserved.
//
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

#import <Adium/AIPlugin.h>
#import <Adium/AIContentControllerProtocol.h>
#import <Adium/AIPreferencePane.h>
#import "AdiURLPrettifier.h"
#import "Prefs.h"

#define APP_NAME @"AdiURLShortener"
#define KEY_ENABLED	@"Enable automatic shortening of URLs"
#define KEY_URL_MIN_LENGTH @"Minimum URL length to shorten"
#define KEY_SHORTENER_TYPE @"Shortening style"
#define VALUE_PRETTIFY 0
#define VALUE_GOO_GL 1
#define FORMAT_SHORT_URL @"adi_url"
@interface AdiURLShortener : AIPlugin <AIContentFilter> {
    AIPreferencePane *prefs;
}

@property(strong) AdiURLPrettifier *prettifier;

@end
