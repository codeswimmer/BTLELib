BTLELib
=======

iOS library for connecting with and sending data to another device via Bluetooth LE.

##### Features:
* Simplified, abstracted API to CoreBluetooth
  * [<code>BTLEPeripheral</code>](https://github.com/KeithErmel/BTLELib/blob/master/BTLELib/BTLELib/Source/Bluetooth/BTLEPeripheral.h) - data provider
  * [<code>BTLECentral</code>](https://github.com/KeithErmel/BTLELib/blob/master/BTLELib/BTLELib/Source/Bluetooth/BTLECentral.h) - consumer of data provided by peripheral
  * Send & Receive Data
      * [<code>BTLEDataSender</code>](https://github.com/KeithErmel/BTLELib/blob/master/BTLELib/BTLELib/Source/Bluetooth/BTLEDataSender.h)
      * [<code>BTLEReceiver</code>](https://github.com/KeithErmel/BTLELib/blob/master/BTLELib/BTLELib/Source/Bluetooth/BTLEDataReceiver.h)
      * Can send either a packet (<= 20 bytes) or package of data
          * Packaged data is parceled into 20 byte chunks
          * Queued up & sent in order to receiver via GCD
          * Provides progress updates to delegates (both sender & receiver)
* Ideal for adding BTLE support to your apps
* Easily turn any device that provides BTLE into a peripheral or central
* Note that this is not yet a full-featured BTLE library:
    * The initial release focuses on seamless pairing & data transfer between devices
    * Future additions will provide generalized support for:
        * Services
        * Read / write characteristics
        * etc.

##### Using
* Clone repo
* Drag & drop <code>BTLELib.xcodeproj</code> into your workspace
* Follow [Apple's documentation](https://developer.apple.com/library/ios/technotes/iOSStaticLibraries/Articles/configuration.html) on how to use static libraries in iOS

The library uses ARC. It has been developed using Xcode 5 & tested against iOS 7.x.

##### Examples
* The <code>[BTLELibExample](https://github.com/KeithErmel/BTLELib/tree/master/Examples/BTLELibExample)</code> sends a bit over 10K of data to a receiver
* Requires two devices running the example app
* One serves as sender, the other as receiver; user selectable
* Provides progress updates to UI via progress bar on both the sending & receiving devices
