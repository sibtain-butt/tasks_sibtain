import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import '../Helpers/ad_helper.dart';
import './main_activity.dart';

class SplashActivity extends StatefulWidget {
  const SplashActivity({Key? key}) : super(key: key);

  @override
  State<SplashActivity> createState() => _SplashActivityState();
}

class _SplashActivityState extends State<SplashActivity> {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    Timer(const Duration(seconds: 5), () {
      if (_isInterstitialAdReady) {
        _interstitialAd?.show();
      }
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainActivity()));
    });
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      //adUnitId: 'your_ad_unit_id', //ca-app-pub-1924561159597541/2653015625
      //adUnitId: 'ca-app-pub-3940256099942544/7049598008',
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Splash Screen...',
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
