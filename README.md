![element](https://github.com/Element1/element-ios-face-sdk-remote-example/raw/master/images/element.png "element")

## Element iOS Face SDK - Remote Example

This demo app shows how to use the Element Face SDK to enroll and authenticate users.

## Version support

The Element Face iOS SDK supports iOS 10 and above.

## Prerequisites

### Element Dashboard Account
An account is required to access the Element Dashboard.

### Framework
The Element Face SDK is available on the Element Dashboard, under Account -> SDK -> SDK Files.

![dashboard-account](https://github.com/Element1/element-ios-face-sdk-remote-example/raw/master/images/dashboard-account.jpg "dashboard-account")
![dashboard-sdk-files](https://github.com/Element1/element-ios-face-sdk-remote-example/raw/master/images/dashboard-sdk-files.png "dashboard-sdk-files")

Note that the Framework was not built with Bitcode enabled so you may have to disable Bitcode for your app in order to link against the Element SDK.  To do that, click on your project in Xcode then go to the "Build Settings" tab and search for *Enable Bitcode* and set it to *No*.

![bitcode_off](https://github.com/Element1/element-ios-face-sdk-remote-example/raw/master/images/bitcode_off.png "bitcode_off")


## Using the demo application

A demo application that uses the SDK is in the Example folder.

Please download the Element SDK and the themes bundles and copy them in the Frameworks directory (element-ios-face-sdk-remote-example/Example/demo/Frameworks) of the demo (this repository doesn't include the actual SDK):

![framework](https://github.com/Element1/element-ios-face-sdk-remote-example/raw/master/images/framework_location.png "framework")

Once you have downloaded and copied the files in the Frameworks directory, you can open fm-demo-public.xcodeproj using Xcode and edit the "Bundle Identifier" of the app to use your company prefix and select your Team:

![bundle_and_company](https://github.com/Element1/element-ios-face-sdk-remote-example/raw/master/images/bundle_and_company.png "bundle_and_company")

The last step is to edit the AppDelegatePublic.swift file and replace your EAK with the one you received from Element.  The enrollments and authentications can either be handled by the SDK or by the app.  In order to handle enrollment and authentication on the app level, replace YOUR_API_KEY and YOUR_BASE_BACKEND_URL with the values you received from Element.

To run the demo app, click on the arrow on the top left:

![run](https://github.com/Element1/element-ios-face-sdk-remote-example/raw/master/images/run.png "run")

- Note that the XCode project is set to "Automatically manage signing" so you will need to be signed into your Apple developer account in order to run the demo app on your phone (see https://developer.apple.com/library/content/qa/qa1814/_index.html).

## Documentation

More documentation is available on the Element Dashboard.
