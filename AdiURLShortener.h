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
#define KEY_INCOMING_ENABLED	@"Automatic shortening of incoming messages"
#define KEY_OUTGOING_ENABLED	@"Automatic shortening of outgoing messages"
#define KEY_MIN_INCOMING        @"Minimum URL length to shorten for incoming messages"
#define KEY_MIN_OUTGOING        @"Minimum URL length to shorten for outgoing messages"
#define KEY_SHORTENER_TYPE @"Shortening style for outgoing messages"
#define VALUE_PRETTIFY 0
#define VALUE_GOO_GL 1

@interface AdiURLShortener : AIPlugin <AIContentFilter> {
    AIPreferencePane *prefs;
}

@property(strong) AdiURLPrettifier *incomingPrettifier;
@property(strong) AdiURLPrettifier *outgoingPrettifier;

@end
