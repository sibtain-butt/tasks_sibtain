// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/7049598008';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3964253750';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/8673189370';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/7552160883';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2521693316';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2521693316';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}

/*
Ad format	Demo        ad unit ID
App Open	            ca-app-pub-3940256099942544/5662855259
Banner	              ca-app-pub-3940256099942544/2934735716
Interstitial	        ca-app-pub-3940256099942544/4411468910
Interstitial Video	  ca-app-pub-3940256099942544/5135589807
Rewarded	            ca-app-pub-3940256099942544/1712485313
Rewarded Interstitial	ca-app-pub-3940256099942544/6978759866
Native Advanced	      ca-app-pub-3940256099942544/3986624511
Native Advanced Video	ca-app-pub-3940256099942544/2521693316
*/
