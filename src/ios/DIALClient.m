#import "DIALClient.h"



//------------------------------------------------------------------------------
#pragma mark - Constants, Keys Declarations
//------------------------------------------------------------------------------

NSString * const kHbbTVApp = @"HbbTV";

NSString* const kRefreshDiscoveredDevicesNotification =@"RefreshDiscoveredDevices";
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
#pragma mark - DIALClient (Interface Extension)
//------------------------------------------------------------------------------

@interface DIALClient()

//------------------------------------------------------------------------------
#pragma mark - Properties
//------------------------------------------------------------------------------

@property (nonatomic)   DIALServiceDiscovery *tvDiscoveryComponent;


@end


//------------------------------------------------------------------------------
#pragma mark - DIALClient implementation
//------------------------------------------------------------------------------
@implementation DIALClient
{
    NSArray* devices;
    NSString *applicationName;
    CDVInvokedUrlCommand* myCommand;
}



//------------------------------------------------------------------------------
#pragma mark - Initialiser methods, Lifecycle methods
//------------------------------------------------------------------------------

- (id) init{
    self = [super init];
    if (self != nil) {

        self.tvDiscoveryComponent = [[DIALServiceDiscovery alloc] init];
        devices = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DIALServiceDiscoveryNotificationReceived:) name:nil object:self.tvDiscoveryComponent];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshDiscoveredDevicesNotificationReceived:) name:kRefreshDiscoveredDevicesNotification object:nil];


    }
    return self;
}

//------------------------------------------------------------------------------


- (void) dealloc
{
    _tvDiscoveryComponent = nil;
    devices = nil;

}


//------------------------------------------------------------------------------
#pragma mark - Public methods
//------------------------------------------------------------------------------

- (void)startDiscovery:(CDVInvokedUrlCommand*)command{


    [self.commandDelegate runInBackground:^{
        self.tvDiscoveryComponent = [[DIALServiceDiscovery alloc] init];
        devices = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DIALServiceDiscoveryNotificationReceived:) name:nil object:self.tvDiscoveryComponent];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshDiscoveredDevicesNotificationReceived:) name:kRefreshDiscoveredDevicesNotification object:nil];

        NSLog(@"TEST1");
        myCommand = command;
        CDVPluginResult* pluginResult = nil;

        NSString* str = [command.arguments objectAtIndex:0];


        if (str == nil || [str length] == 0) {
            applicationName = @"HbbTV";
        }else{
            applicationName = str;
        }

        self.tvDiscoveryComponent.applicationName = applicationName;

        [self.tvDiscoveryComponent start];
        NSLog(@"TEST2");


        NSLog(@"TEST3");

        devices =  [_tvDiscoveryComponent getDevices];

//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
//                                         messageAsString:[_tvDiscoveryComponent getDevicesJSON]];
//
//
//
//        [self.commandDelegate sendPluginResult:pluginResult
//                                    callbackId:command.callbackId];
    }];




}

//------------------------------------------------------------------------------

- (void) stopDiscovery:(CDVInvokedUrlCommand*)command{

    CDVPluginResult* pluginResult = nil;
    [self.tvDiscoveryComponent stop];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];

    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];


}

//------------------------------------------------------------------------------


- (NSString*) getDevices:(CDVInvokedUrlCommand*)command
{

    CDVPluginResult* pluginResult = nil;

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                     messageAsString:[_tvDiscoveryComponent getDevicesJSON]];

    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];

    return @"OK";

}
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
#pragma mark - Notification handlers
//------------------------------------------------------------------------------

/**

 Handle RefreshDiscoveredDevicesNotification notification

 */
- (void) RefreshDiscoveredDevicesNotificationReceived: (NSNotification*) aNotification
{
     NSLog(@"DIALClient.m: RefreshDiscoveredDevices notification: %@ received.", [aNotification name]);

    CDVPluginResult* pluginResult = nil;
    devices =  [_tvDiscoveryComponent getDevices];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                     messageAsString:[_tvDiscoveryComponent getDevicesJSON]];
   [pluginResult setKeepCallbackAsBool:YES];

    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:myCommand.callbackId];
}

//------------------------------------------------------------------------------

/**
 Handle a received DIALServiceDiscoveryNotifcation
 */
/** Handler for DIAL service discovery and update notifications */
- (void) DIALServiceDiscoveryNotificationReceived:(NSNotification*) aNotification
{
    DIALDevice *device;

    NSLog(@"DIALClient.m: dial service discovery notification: %@ received.", [aNotification name]);

    if ([[aNotification name] caseInsensitiveCompare:kNewDIALDeviceDiscoveryNotification] == 0) {
        id temp = [[aNotification userInfo] objectForKey:kNewDIALDeviceDiscoveryNotification];

        if ([temp isKindOfClass: [DIALDevice class]] )
        {
            device = (DIALDevice*) temp;

            NSLog(@"DIALClient.m: Master Device %@ found on network.", device.friendlyName);

            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshDiscoveredDevicesNotification object:nil];
        }


    } else if ([[aNotification name] caseInsensitiveCompare:kDIALDeviceExpiryNotification] == 0)
    {
        device = (DIALDevice*) [[aNotification userInfo] objectForKey:kDIALDeviceExpiryNotification];

        NSLog(@"DIALClient.m: Master Device %@ no longer available.", device.friendlyName);

        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshDiscoveredDevicesNotification object:nil];

    }

}
//------------------------------------------------------------------------------






@end
