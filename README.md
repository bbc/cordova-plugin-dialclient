`cordova-plugin-dialclient`
===========================

A Cordova library for discovery of HbbTV2.0 devices on iOS platforms using DIAL.

Usage
-----

You can add the plugin to your Cordova application by adding the following line
to your app's `config.xml`:

    <plugin name="cordova-dialclient" spec="https://github.com/bbc/cordova-plugin-dialclient.git" /> 

The plugin is available to the global Javascript namespace via the `DIALClient`
object. This object has a single method: `DIALClient.getDIALClient()`
which creates a new DIAL discovery client. The client object has the following
methods:

* `startDiscovery(callback)`: Start discovery of DIAL devices and register a
  callback to be called whenever the set of discovered devices changes. The
  callback is called with an array of `DiscoveredTerminal` objects representing
  the current set of all available terminals.
* `stopDiscovery()`: Stops the DIAL discovery service.

Each `DiscoveredTerminal` object returned by the callback of `startDiscovery`
has the following properties:

* `enum_id`: A unique ID for each discovered terminal.
* `friendly_name`: A human readable name provided by the terminal.
* `X_HbbTV_App2AppURL`: The remote service endpoint on the discovered HbbTV
  terminal for application to application communication.
* `X_HbbTV_InterDevSyncURL`: The remote service endpoint on the discovered
  HbbTV terminal for inter-device synchronisation.
* `X_HbbTV_UserAgent`: The User Agent string of the discovered HbbTV terminal.

Example usage
-------------

A minimal code snippet:

    var client = DIALClient.getDIALClient();
    client.startDiscovery(function (terminals) {
        console.log("Discovered terminals changed:");
        for (var i = 0; i < terminals.length; i++) {
            console.log(terminals[i]);
        }
    });

A minimal example Cordova app is [also available
here](https://github.com/bbc/cordova-dialclient-exampleapp).
