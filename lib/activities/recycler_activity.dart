import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Helpers/ad_helper.dart';

class RecyclerActivity extends StatefulWidget {
  const RecyclerActivity({Key? key}) : super(key: key);

  @override
  State<RecyclerActivity> createState() => _RecyclerActivityState();
}

class _RecyclerActivityState extends State<RecyclerActivity> {
  // TODO: Add _kAdIndex
  static const _kAdIndex = 5;

  // TODO: Add a banner ad instance
  BannerAd? _ad;

  final List<String> countryNames = [
    'Pakistan',
    'India',
    'China',
    'USA',
    'Russia',
    'Germany',
    'France',
    'Italy',
    'Spain',
    'Canada',
    'UK'
  ];

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  String _language = 'اردو';

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();

    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _ad?.dispose();
    super.dispose();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      //adUnitId: 'your_ad_unit_id', //ca-app-pub-1924561159597541/2653015625
      //Note: Replace your_ad_unit_id with your actual Ad Unit ID obtained from
      //the Google AdMob dashboard.
      //adUnitId: 'ca-app-pub-1924561159597541/2653015625',
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdReady = false;
          _interstitialAd?.dispose();
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdReady) {
      _interstitialAd?.show();
      _loadInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false; // If a user gesture is in progress, don't handle back button.
        } else {
          // Handle back button press here
          // This code will be executed when the AppBar back button or device's back touch button is clicked.
          Navigator.pop(context, _language);
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recycler Activity'),
        ),
        body: ListView.builder(
          itemCount: countryNames.length,
          itemBuilder: (BuildContext context, int index) {
            // TODO: Render a banner ad
            if (_ad != null && index == _kAdIndex) {
              return Container(
                width: _ad!.size.width.toDouble(),
                height: _ad!.size.height.toDouble(),
                alignment: Alignment.center,
                child: AdWidget(ad: _ad!),
              );
            } else {
              return ListTile(
                title: Text(countryNames[index]),
                onTap: () {
                  setState(() {
                    _showInterstitialAd();
                  });
                },
              );
            }
          },
        ),
      ),
    );
  }
}
