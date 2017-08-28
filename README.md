<div align="center">
<h1>Desert Road</h1>
<div>Google Summer of Code 2017 project - VR application built with [processing-android](https://github.com/processing/processing-android).</div>
<p style="font-size:10px">made with :heart: by <a href="https://picorana.github.io">picorana</a></p>
</div>

<div align="center">
  <img src="docs/index4.gif">
</div>
<br>

Desert Road is a VR application made with Processing.
It lets you travel through a procedural landscape generated according to music. Play any music from any app on your phone, then run the app: it will automatically use as input any sound coming as output from the phone.

## Table of contents
- [Download](#Download)
- [Compiling Instructions](#How-to-compile-the-app-from-source)
- [Usage](#Usage)

## Download
- Download the app from the play store: [VR audioscape on Google Play](https://play.google.com/store/apps/details?id=com.picorana.vraudioscape)
- Or dowload the .apk from  this repository: [.apk ](https://github.com/picorana/VR_Demo_GSoC17/blob/master/Desert_Road/build/desert_road_release_signed_aligned.apk)

## Usage
After installing the app, 

## How to compile the app from source
* Download Processing from https://processing.org/
* Make sure you have *Android Mode* installed. If you don't, install it via selecting the *Add Mode...* from the menu in the upper-right corner of the PDE
* Clone the repository on your pc
* Open Desert_Road.pde with Processing
* Connect your phone to your pc, [enable USB debugging](https://developer.android.com/studio/run/device.html#setting-up) on your phone
* Use Processing IDE to compile the sketch on your phone

Requirements for compiling the sketch:
* Processing
* [Android Mode 262+](https://github.com/processing/processing-android/releases)

## Acknowledgements
Many thanks to [Andres Colubri](https://github.com/codeanticode) and [Gottfried Haider](https://github.com/gohai), who have been my mentors during the project, who put up with my messy code and made this possible.

Thanks to [dasaki's adaptation of minim fft classes to make them work on Android](https://github.com/dasaki/android_fft_minim) and [kctess5's beat detection sketch](https://github.com/kctess5/Processing-Beat-Detection), whose work is used in this project.

## Links:
* [Google Summer of Code](https://summerofcode.withgoogle.com/)
* [Processing for Android](http://android.processing.org/index.html)
