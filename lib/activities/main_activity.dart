import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../Helpers/ad_helper.dart';
import '../activities/recycler_activity.dart';

class MainActivity extends StatefulWidget {
  const MainActivity({Key? key}) : super(key: key);

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  InterstitialAd? _interstitialAd;
  bool _isButtonClickable = true;
  BannerAd? _bannerAd;
  NativeAd? _nativeAd;
  bool _isInterstitialAdReady = false;
  String _text = 'Task';
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();

    _bannerAd = BannerAd(
      //adUnitId: '[YOUR_AD_UNIT_ID]', // Replace with your ad unit ID
      //adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Failed to load a Banner Ad: ${error.message}');
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();

    _nativeAd = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: "listTile",
      listener: NativeAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          setState(() {
            _nativeAd = ad as NativeAd;
            isAdLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('NativeAd failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
        // Called when a click is recorded for a NativeAd.
        onAdClicked: (ad) => print('Ad clicked.'),
        // onNativeAdClicked: (NativeAd ad) => print('Ad clicked.'),
        onAdWillDismissScreen: (ad) => print('Ad will dismiss screen.'),
      ),
      request: const AdRequest(),
    );
    _nativeAd!.load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      //adUnitId: 'your_ad_unit_id',
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              const MainActivity();
            },
          );

          setState(() {
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
            _isButtonClickable = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdReady = false;
          _isButtonClickable = false;
          _interstitialAd?.dispose();
          print('Failed to load an interstitial ad: ${error.message}');
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdReady) {
      setState(() {
        _interstitialAd?.show();
        _loadInterstitialAd();
      });
    }
  }

  void _onButtonPressed() {
    if (_interstitialAd != null) {
      setState(() {
        _showInterstitialAd();
      });
    } else {
      setState(() {
        _isButtonClickable = false;
      });
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // TODO: Display a banner when ready
                  (_bannerAd != null && isAdLoaded)
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: _bannerAd!.size.width.toDouble(),
                            height: _bannerAd?.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ],
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RecyclerActivity()),
                                ).then((value) {
                                  if (value != null) {
                                    print('value from _language $value');
                                    setState(() {
                                      _text = value;
                                    });
                                  }
                                });
                              },
                              child: const Text('Recycler Activity'),
                            ),
                            ElevatedButton(
                              onPressed:
                                  _isButtonClickable ? _onButtonPressed : null,
                              child: const Text('Show Interstitial Ad'),
                            ),
                            //const Text('Task'),
                            Text(_text),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TODO: Display a banner when ready
                          (_nativeAd != null && isAdLoaded)
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width:
                                        300, //_nativeAd!.size.width.toDouble(),
                                    height:
                                        300, //_nativeAd?.size.height.toDouble(),
                                    child: AdWidget(ad: _nativeAd!),
                                    //child: AdWidget(ad: _loadBannarAd()),
                                  ),
                                )
                              : const CircularProgressIndicator(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
