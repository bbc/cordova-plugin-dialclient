//
//  DIALServiceDiscovery.h
//
//
//  Created by Rajiv Ramdhany on 01/12/2014.
//  Copyright (c) 2014 BBC RD. All rights reserved.
//
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

#import <dial_discovery_ios/DIALGlobals.h>
#import <dial_discovery_ios/DIALServiceDiscovery.h>

//------------------------------------------------------------------------------
#pragma mark - Data Structures
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
#pragma mark - Constants, Keys Declarations
//------------------------------------------------------------------------------

extern NSString* const kRefreshDiscoveredDevicesNotification;

//------------------------------------------------------------------------------
#pragma mark - DIALClient Class Definition
//------------------------------------------------------------------------------



@interface DIALClient : CDVPlugin


//------------------------------------------------------------------------------
#pragma mark - Public methods
//------------------------------------------------------------------------------


- (void)startDiscovery:(CDVInvokedUrlCommand*)command;

- (void)stopDiscovery:(CDVInvokedUrlCommand*)command;

- (NSString*) getDevices:(CDVInvokedUrlCommand*)command;

@end
