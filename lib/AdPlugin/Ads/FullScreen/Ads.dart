// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';

// 📦 Package imports:
import 'package:ironsource_adpluginx/ironsource_adpluginx.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../../AdLoader/AdLoaderProvider.dart';
import '../../AdsWidget/AppLovin/Interstitial/AppLovinInterstitial.dart';
import '../../AdsWidget/Google/Interstitial/GoogleInterstitial.dart';
import '../../AdsWidget/Google/Rewarded Interstitial/GoogleRewardedInterstitial.dart';
import '../../AdsWidget/Google/Rewarded/GoogleRewarded.dart';
import '../../AdsWidget/IronSource/Interstitial/IronSourceInterstitial.dart';
import '../../AdsWidget/Unity/UnityInterstitial.dart';
import '../../MainJson/MainJson.dart';

class AdsRN {
  static final AdsRN _singleton = AdsRN._internal();

  factory AdsRN() {
    return _singleton;
  }

  AdsRN._internal();

  Map routeIndex = {};
  int currentAdIndex = 0;
  int failCounter = 0;

  Timer? timer;

  indexIncrement(String? route, int arrayLength) {
    failCounter = 0;
    if (route != null) {
      if (routeIndex[route] == null) {
        if ((arrayLength + 1) == 1) {
          routeIndex[route] = 0;
        } else {
          routeIndex[route] = 1;
        }
      } else {
        if (routeIndex[route] != arrayLength &&
            routeIndex[route] < arrayLength) {
          routeIndex[route]++;
        } else {
          routeIndex[route] = 0;
        }
      }
    } else {
      if (currentAdIndex < arrayLength && currentAdIndex != arrayLength) {
        currentAdIndex++;
      } else {
        currentAdIndex = 0;
      }
    }
  }

  bool loopBreaker(int retry) {
    if (failCounter < retry) {
      failCounter++;
      return false;
    }
    failCounter = 0;
    return true;
  }

  showFullScreen(
      {required BuildContext context, required Function() onComplete}) async {
    MainJson mainJson = context.read<MainJson>();
    AdLoaderProvider loaderProvider = context.read<AdLoaderProvider>();
    loaderProvider.isAdLoading = true;
    String? route = ModalRoute.of(context)?.settings.name;
    int index = route != null ? (routeIndex[route] ?? 0) : currentAdIndex;

    timer = Timer.periodic(
        Duration(
            seconds: mainJson.data![mainJson.version]['globalConfig']
                ['overrideTimer']), (timer) {
      Logger().d("override Timer");
      loaderProvider.isAdLoading = false;
      onComplete();
      timer.cancel();
      return;
    });

    if ((mainJson.data![mainJson.version]['globalConfig']['globalAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;
      timer!.cancel();

      onComplete();
      return;
    }
    if ((mainJson.data![mainJson.version]['screens']
                [ModalRoute.of(context)?.settings.name]['localAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;
      timer!.cancel();

      onComplete();
      return;
    }
    switch (mainJson.data![mainJson.version]['screens']
        [ModalRoute.of(context)?.settings.name]['localClick'][index]) {
      case 0:
        Logger().d("Google Inter Called");
        GoogleInterstitial().loadAd(
          context: context,
          onLoaded: () {
            Logger().d("Google Inter Loaded");
            timer!.cancel();
          },
          onComplete: () {
            Logger().d("Google Inter Complete");
            indexIncrement(
                route,
                mainJson.data![mainJson.version]['screens'][route]['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            onComplete();
            timer!.cancel();
          },
          onFailed: () {
            Logger().d("Google Inter Failed");
            failedFullScreen(
              from: 0,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                onComplete();
                timer!.cancel();
              },
            );
          },
        );
        break;
      case 1:
        Logger().d("Applovin Inter Called");
        AppLovinInterstitial().loadAd(
          context: context,
          onLoaded: () {
            Logger().d("Applovin Inter Loaded");
            timer!.cancel();
          },
          onComplete: () {
            Logger().d("Applovin Inter Complete");
            indexIncrement(
                route,
                mainJson.data![mainJson.version]['screens'][route]['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer!.cancel();

            onComplete();
          },
          onFailed: () {
            Logger().d("Applovin Inter Failed");
            failedFullScreen(
              from: 1,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer!.cancel();

                onComplete();
              },
            );
          },
        );
        break;
      case 2:
        Logger().d("IronSource Inter Called");
        IronSourceFullScreenX ironSourceFullScreenX =
            IronSourceFullScreenX.onInit(
          onLoaded: () {
            Logger().d("IronSource Inter Loaded");
            timer!.cancel();
            IronSource.showInterstitial();
          },
          onComplete: () {
            Logger().d("IronSource Inter Complete");
            indexIncrement(
                route,
                mainJson.data![mainJson.version]['screens'][route]['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer!.cancel();

            onComplete();
          },
          onFailed: () {
            Logger().d("IronSource Inter Failed");
            failedFullScreen(
              from: 2,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer!.cancel();
                onComplete();
              },
            );
          },
        );
        IronSource.setLevelPlayInterstitialListener(ironSourceFullScreenX);
        IronSource.loadInterstitial();
        // IronSource.loadInterstitial();
        break;
      case 3:
        Logger().d("Unity Inter Called");
        UnityInterstitial().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Unity Inter Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Unity Inter Complete");
              indexIncrement(
                  route,
                  mainJson
                          .data![mainJson.version]['screens'][route]
                              ['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer!.cancel();

              onComplete();
            },
            onFailed: () {
              Logger().d("Unity Inter Failed");
              failedFullScreen(
                from: 3,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer!.cancel();

                  onComplete();
                },
              );
            });
        break;
      case 4:
        Logger().d("Google Reward Called");
        GoogleRewarded().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Google Reward Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Google Reward Complete");
              indexIncrement(
                  route,
                  mainJson
                          .data![mainJson.version]['screens'][route]
                              ['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer!.cancel();

              onComplete();
            },
            onFailed: () {
              Logger().d("Google Reward Failed");
              failedFullScreen(
                from: 4,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer!.cancel();
                  onComplete();
                },
              );
            });
        break;
      case 5:
        Logger().d("Google Reward Inter Called");
        GoogleRewardedInterstitial().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Google Reward Inter Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Google Reward Inter Complete");
              indexIncrement(
                  route,
                  mainJson
                          .data![mainJson.version]['screens'][route]
                              ['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer!.cancel();

              onComplete();
            },
            onFailed: () {
              Logger().d("Google Reward Inter Failed");
              failedFullScreen(
                from: 5,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer!.cancel();

                  onComplete();
                },
              );
            });
        break;
      default:
        indexIncrement(
            route,
            mainJson.data![mainJson.version]['screens'][route]['localClick']
                    .length -
                1);
        loaderProvider.isAdLoading = false;
        timer!.cancel();

        onComplete();
        break;
    }
  }

  showActionBasedAds(
      {required BuildContext context,
      required String actionName,
      required Function() onComplete}) {
    MainJson mainJson = context.read<MainJson>();
    AdLoaderProvider loaderProvider = context.read<AdLoaderProvider>();
    loaderProvider.isAdLoading = true;
    int index =
        actionName != null ? (routeIndex[actionName] ?? 0) : currentAdIndex;
    if ((mainJson.data![mainJson.version]['globalConfig']['globalAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;

      onComplete();
      return;
    }

    if ((mainJson.data![mainJson.version]['actions'][actionName]
                ['localAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;

      onComplete();
      return;
    }

    timer = Timer.periodic(
        Duration(
            seconds: mainJson.data![mainJson.version]['globalConfig']
                ['overrideTimer']), (timer) {
      Logger().d("override Timer");
      loaderProvider.isAdLoading = false;
      onComplete();
      timer.cancel();
      return;
    });

    switch (mainJson.data![mainJson.version]['actions'][actionName]
        ['localClick'][index]) {
      case 0:
        Logger().d("Google Inter Called");
        GoogleInterstitial().loadAd(
          context: context,
          onLoaded: () {
            Logger().d("Google Inter Loaded");
            timer!.cancel();
          },
          onComplete: () {
            Logger().d("Google Inter Complete");
            indexIncrement(
                actionName,
                mainJson
                        .data![mainJson.version]['actions'][actionName]
                            ['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer!.cancel();
            onComplete();
          },
          onFailed: () {
            Logger().d("Google Inter Failed");
            failedActionBasedAds(
              actionName: actionName,
              from: 0,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer!.cancel();
                onComplete();
              },
            );
          },
        );
        break;
      case 1:
        Logger().d("Applovin Inter Called");
        AppLovinInterstitial().loadAd(
          context: context,
          onLoaded: () {
            Logger().d("Applovin Inter Loaded");
            timer!.cancel();
          },
          onComplete: () {
            Logger().d("Applovin Inter Complete");
            indexIncrement(
                actionName,
                mainJson
                        .data![mainJson.version]['actions'][actionName]
                            ['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer!.cancel();
            onComplete();
          },
          onFailed: () {
            Logger().d("Applovin Inter Failed");
            failedActionBasedAds(
              actionName: actionName,
              from: 1,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer!.cancel();
                onComplete();
              },
            );
          },
        );
        break;
      case 2:
        Logger().d("IronSource Inter Called");
        IronSourceFullScreenX ironSourceFullScreenX =
            IronSourceFullScreenX.onInit(
          onLoaded: () {
            Logger().d("IronSource Inter Loaded");
            timer!.cancel();
            IronSource.showInterstitial();
          },
          onComplete: () {
            Logger().d("IronSource Inter Complete");
            indexIncrement(
                actionName,
                mainJson
                        .data![mainJson.version]['actions'][actionName]
                            ['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer!.cancel();
            onComplete();
          },
          onFailed: () {
            Logger().d("IronSource Inter Failed");
            failedActionBasedAds(
              actionName: actionName,
              from: 2,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer!.cancel();
                onComplete();
              },
            );
          },
        );

        IronSource.setLevelPlayInterstitialListener(ironSourceFullScreenX);
        IronSource.loadInterstitial();
        break;
      case 3:
        Logger().d("Unity Inter Called");
        UnityInterstitial().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Unity Inter Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Unity Inter Complete");
              indexIncrement(
                  actionName,
                  mainJson
                          .data![mainJson.version]['actions'][actionName]
                              ['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("Unity Inter Failed");
              failedActionBasedAds(
                actionName: actionName,
                from: 3,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer!.cancel();
                  onComplete();
                },
              );
            });
        break;
      case 4:
        Logger().d("Google Reward Called");
        GoogleRewarded().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Google Reward Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Google Reward Complete");
              indexIncrement(
                  actionName,
                  mainJson
                          .data![mainJson.version]['actions'][actionName]
                              ['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("Google Reward Failed");
              failedActionBasedAds(
                actionName: actionName,
                from: 4,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer!.cancel();
                  onComplete();
                },
              );
            });
        break;
      case 5:
        Logger().d("Google Reward Inter Called");
        GoogleRewardedInterstitial().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Google Reward Inter Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Google Reward Inter Complete");
              indexIncrement(
                  actionName,
                  mainJson
                          .data![mainJson.version]['actions'][actionName]
                              ['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("Google Reward Inter Failed");
              failedActionBasedAds(
                actionName: actionName,
                from: 5,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer!.cancel();
                  onComplete();
                },
              );
            });
        break;

      default:
        indexIncrement(
            actionName,
            mainJson
                    .data![mainJson.version]['actions'][actionName]
                        ['localClick']
                    .length -
                1);
        loaderProvider.isAdLoading = false;
        timer!.cancel();
        onComplete();
        break;
    }
  }

  showScreenActionBasedAds(
      {required BuildContext context,
      required String actionName,
      required Function() onComplete}) {
    MainJson mainJson = context.read<MainJson>();
    String? route = ModalRoute.of(context)?.settings.name;
    AdLoaderProvider loaderProvider = context.read<AdLoaderProvider>();
    loaderProvider.isAdLoading = true;
    int index = actionName != null
        ? (routeIndex['$route/$actionName'] ?? 0)
        : currentAdIndex;
    if ((mainJson.data![mainJson.version]['globalConfig']['globalAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;

      onComplete();
      return;
    }

    if ((mainJson.data![mainJson.version]['screens'][route]['localAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;

      onComplete();
      return;
    }
    if ((mainJson.data![mainJson.version]['screens'][route]['actions']
                [actionName]['localAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;

      onComplete();
      return;
    }

    timer = Timer.periodic(
        Duration(
            seconds: mainJson.data![mainJson.version]['globalConfig']
                ['overrideTimer']), (timer) {
      Logger().d("override Timer");
      loaderProvider.isAdLoading = false;
      onComplete();
      timer.cancel();
      return;
    });

    switch (mainJson.data![mainJson.version]['screens'][route]['actions']
        [actionName]['localClick'][index]) {
      case 0:
        Logger().d("Google Inter Called");
        GoogleInterstitial().loadAd(
          context: context,
          onLoaded: () {
            Logger().d("Google Inter Loaded");
            timer!.cancel();
          },
          onComplete: () {
            Logger().d("Google Inter Complete");
            indexIncrement(
                '$route/$actionName',
                mainJson
                        .data![mainJson.version]['screens'][route]['actions']
                            [actionName]['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer!.cancel();
            onComplete();
          },
          onFailed: () {
            Logger().d("Google Inter Failed");
            failedScreenActionBasedAds(
              actionName: actionName,
              from: 0,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer!.cancel();
                onComplete();
              },
            );
          },
        );
        break;
      case 1:
        Logger().d("Applovin Inter Called");
        AppLovinInterstitial().loadAd(
          context: context,
          onLoaded: () {
            Logger().d("Applovin Inter Loaded");
            timer!.cancel();
          },
          onComplete: () {
            Logger().d("Applovin Inter Complete");
            indexIncrement(
                '$route/$actionName',
                mainJson
                        .data![mainJson.version]['screens'][route]['actions']
                            [actionName]['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer!.cancel();
            onComplete();
          },
          onFailed: () {
            Logger().d("Applovin Inter Failed");
            failedScreenActionBasedAds(
              actionName: actionName,
              from: 1,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer!.cancel();
                onComplete();
              },
            );
          },
        );
        break;
      case 2:
        Logger().d("IronSource Inter Called");
        IronSourceFullScreenX ironSourceFullScreenX =
            IronSourceFullScreenX.onInit(
          onLoaded: () {
            Logger().d("IronSource Inter Loaded");
            timer!.cancel();
            IronSource.showInterstitial();
          },
          onComplete: () {
            Logger().d("IronSource Inter Complete");
            indexIncrement(
                '$route/$actionName',
                mainJson
                        .data![mainJson.version]['screens'][route]['actions']
                            [actionName]['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer!.cancel();
            onComplete();
          },
          onFailed: () {
            Logger().d("IronSource Inter Failed");
            failedScreenActionBasedAds(
              actionName: actionName,
              from: 2,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer!.cancel();
                onComplete();
              },
            );
          },
        );

        IronSource.setLevelPlayInterstitialListener(ironSourceFullScreenX);
        IronSource.loadInterstitial();
        break;
      case 3:
        Logger().d("Unity Inter Called");
        UnityInterstitial().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Unity Inter Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Unity Inter Complete");
              indexIncrement(
                  '$route/$actionName',
                  mainJson
                          .data![mainJson.version]['screens'][route]['actions']
                              [actionName]['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("Unity Inter Failed");
              failedScreenActionBasedAds(
                actionName: actionName,
                from: 3,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer!.cancel();
                  onComplete();
                },
              );
            });
        break;
      case 4:
        Logger().d("Google Reward Called");
        GoogleRewarded().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Google Reward Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Google Reward Complete");
              indexIncrement(
                  '$route/$actionName',
                  mainJson
                          .data![mainJson.version]['screens'][route]['actions']
                              [actionName]['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("Google Reward Failed");
              failedScreenActionBasedAds(
                actionName: actionName,
                from: 4,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer!.cancel();
                  onComplete();
                },
              );
            });
        break;
      case 5:
        Logger().d("Google Reward Inter Called");
        GoogleRewardedInterstitial().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Google Reward Inter Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Google Reward Inter Complete");
              indexIncrement(
                  '$route/$actionName',
                  mainJson
                          .data![mainJson.version]['screens'][route]['actions']
                              [actionName]['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("Google Reward Inter Failed");
              failedScreenActionBasedAds(
                actionName: actionName,
                from: 5,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer!.cancel();
                  onComplete();
                },
              );
            });
        break;

      default:
        indexIncrement(
            '$route/$actionName',
            mainJson
                    .data![mainJson.version]['screens'][route]['actions']
                        [actionName]['localClick']
                    .length -
                1);
        loaderProvider.isAdLoading = false;
        timer!.cancel();
        onComplete();
        break;
    }
  }

  failedFullScreen(
      {required int from,
      required BuildContext context,
      required Function() onComplete}) {
    MainJson mainJson = context.read<MainJson>();
    String? route = ModalRoute.of(context)?.settings.name;
    Map? failedMapArray = mainJson.data![mainJson.version]['screens']
        [ModalRoute.of(context)?.settings.name]['localFail'];
    int caseIndex = failedMapArray![from.toString()] ?? 0;

    if (failedMapArray[from.toString()] == null) {
      onComplete();
      return;
    }

    if (loopBreaker(
        mainJson.data![mainJson.version]['globalConfig']['maxFailed'])) {
      Logger().d("max failed");
      onComplete();
    } else {
      // timer = Timer.periodic(
      //     Duration(
      //         seconds: mainJson.data![mainJson.version]['globalConfig']
      //             ['overrideTimer']), (timer) {
      //   Logger().d("override Timer");
      //   onComplete();
      //   timer.cancel();
      //   return;
      // });

      switch (caseIndex) {
        case 0:
          Logger().d("Google Inter Called");
          GoogleInterstitial().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Google Inter Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Google Inter Complete");
              indexIncrement(
                  route,
                  mainJson
                          .data![mainJson.version]['screens'][route]
                              ['localClick']
                          .length -
                      1);
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("Google Inter Failed");
              failedFullScreen(
                from: 0,
                context: context,
                onComplete: () {
                  timer!.cancel();
                  onComplete();
                },
              );
            },
          );
          break;
        case 1:
          Logger().d("Applovin Inter Called");
          AppLovinInterstitial().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Applovin Inter Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Applovin Inter Complete");
              indexIncrement(
                  route,
                  mainJson
                          .data![mainJson.version]['screens'][route]
                              ['localClick']
                          .length -
                      1);
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("Applovin Inter Failed");
              failedFullScreen(
                from: 1,
                context: context,
                onComplete: () {
                  timer!.cancel();
                  onComplete();
                },
              );
            },
          );
          break;
        case 2:
          Logger().d("IronSource Inter Called");
          IronSourceFullScreenX ironSourceFullScreenX =
              IronSourceFullScreenX.onInit(
            onLoaded: () {
              Logger().d("IronSource Inter Loaded");
              timer!.cancel();
              IronSource.showInterstitial();
            },
            onComplete: () {
              Logger().d("IronSource Inter Complete");
              indexIncrement(
                  route,
                  mainJson
                          .data![mainJson.version]['screens'][route]
                              ['localClick']
                          .length -
                      1);
              timer!.cancel();

              onComplete();
            },
            onFailed: () {
              Logger().d("IronSource Inter Failed");
              failedFullScreen(
                from: 2,
                context: context,
                onComplete: () {
                  timer!.cancel();
                  onComplete();
                },
              );
            },
          );
          IronSource.setLevelPlayInterstitialListener(ironSourceFullScreenX);
          IronSource.loadInterstitial();
          break;
        case 3:
          Logger().d("Unity Inter Called");
          UnityInterstitial().loadAd(
              onLoaded: () {
                Logger().d("Unity Inter Loaded");
                timer!.cancel();
              },
              context: context,
              onComplete: () {
                Logger().d("Unity Inter Complete");
                indexIncrement(
                    route,
                    mainJson
                            .data![mainJson.version]['screens'][route]
                                ['localClick']
                            .length -
                        1);
                timer!.cancel();
                onComplete();
              },
              onFailed: () {
                Logger().d("Unity Inter Failed");
                failedFullScreen(
                  from: 3,
                  context: context,
                  onComplete: () {
                    timer!.cancel();
                    onComplete();
                  },
                );
              });
          break;
        case 4:
          Logger().d("Google Reward Called");
          GoogleRewarded().loadAd(
              context: context,
              onLoaded: () {
                Logger().d("Google Reward Loaded");
                timer!.cancel();
              },
              onComplete: () {
                Logger().d("Google Reward Complete");
                indexIncrement(
                    route,
                    mainJson
                            .data![mainJson.version]['screens'][route]
                                ['localClick']
                            .length -
                        1);
                timer!.cancel();
                onComplete();
              },
              onFailed: () {
                Logger().d("Google Reward Failed");
                failedFullScreen(
                  from: 4,
                  context: context,
                  onComplete: () {
                    timer!.cancel();
                    onComplete();
                  },
                );
              });
          break;
        case 5:
          Logger().d("Google Reward Inter Called");
          GoogleRewardedInterstitial().loadAd(
              context: context,
              onLoaded: () {
                Logger().d("Google Reward Inter Loaded");
                timer!.cancel();
              },
              onComplete: () {
                Logger().d("Google Reward Inter Complete");
                indexIncrement(
                    route,
                    mainJson
                            .data![mainJson.version]['screens'][route]
                                ['localClick']
                            .length -
                        1);
                timer!.cancel();
                onComplete();
              },
              onFailed: () {
                Logger().d("Google Reward Inter Failed");
                failedFullScreen(
                  from: 5,
                  context: context,
                  onComplete: () {
                    timer!.cancel();
                    onComplete();
                  },
                );
              });
          break;
        default:
          indexIncrement(
              route,
              mainJson.data![mainJson.version]['screens'][route]['localClick']
                      .length -
                  1);
          timer!.cancel();
          onComplete();
          break;
      }
    }
  }

  failedActionBasedAds(
      {required int from,
      required String actionName,
      required BuildContext context,
      required Function() onComplete}) {
    MainJson mainJson = context.read<MainJson>();
    Map? failedMapArray =
        mainJson.data![mainJson.version]['actions'][actionName]['localFail'];
    int caseIndex = failedMapArray![from.toString()];

    if (loopBreaker(
        mainJson.data![mainJson.version]['globalConfig']['maxFailed'])) {
      Logger().d("max failed");
      onComplete();
    } else {
      // timer = Timer.periodic(
      //     Duration(
      //         seconds: mainJson.data![mainJson.version]['globalConfig']
      //             ['overrideTimer']), (timer) {
      //   Logger().d("override Timer");
      //   onComplete();
      //   timer.cancel();
      //   return;
      // });
      switch (caseIndex) {
        case 0:
          Logger().d("Google Inter Called");
          GoogleInterstitial().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Google Inter Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Google Inter Complete");
              indexIncrement(
                  actionName,
                  mainJson
                          .data![mainJson.version]['actions'][actionName]
                              ['localClick']
                          .length -
                      1);
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("Google Inter Failed");
              failedActionBasedAds(
                actionName: actionName,
                from: 0,
                context: context,
                onComplete: () {
                  timer!.cancel();
                  onComplete();
                },
              );
            },
          );
          break;
        case 1:
          Logger().d("Applovin Inter Called");
          AppLovinInterstitial().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Applovin Inter Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Applovin Inter Complete");
              indexIncrement(
                  actionName,
                  mainJson
                          .data![mainJson.version]['actions'][actionName]
                              ['localClick']
                          .length -
                      1);
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("Applovin Inter Failed");
              failedActionBasedAds(
                actionName: actionName,
                from: 1,
                context: context,
                onComplete: () {
                  timer!.cancel();
                  onComplete();
                },
              );
            },
          );
          break;
        case 2:
          Logger().d("IronSource Inter Called");
          IronSourceFullScreenX ironSourceFullScreenX =
              IronSourceFullScreenX.onInit(
            onLoaded: () {
              Logger().d("IronSource Inter Loaded");
              timer!.cancel();
              IronSource.showInterstitial();
            },
            onComplete: () {
              Logger().d("IronSource Inter Complete");
              indexIncrement(
                  actionName,
                  mainJson
                          .data![mainJson.version]['actions'][actionName]
                              ['localClick']
                          .length -
                      1);
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("IronSource Inter Failed");
              failedActionBasedAds(
                actionName: actionName,
                from: 2,
                context: context,
                onComplete: () {
                  timer!.cancel();
                  onComplete();
                },
              );
            },
          );

          IronSource.setLevelPlayInterstitialListener(ironSourceFullScreenX);
          IronSource.loadInterstitial();
          break;

        case 3:
          Logger().d("Unity Inter Called");
          UnityInterstitial().loadAd(
              context: context,
              onLoaded: () {
                Logger().d("Unity Inter Loaded");
                timer!.cancel();
              },
              onComplete: () {
                Logger().d("Unity Inter Complete");
                indexIncrement(
                    actionName,
                    mainJson
                            .data![mainJson.version]['actions'][actionName]
                                ['localClick']
                            .length -
                        1);
                timer!.cancel();
                onComplete();
              },
              onFailed: () {
                Logger().d("Unity Inter Failed");
                failedActionBasedAds(
                  actionName: actionName,
                  from: 3,
                  context: context,
                  onComplete: () {
                    timer!.cancel();
                    onComplete();
                  },
                );
              });
          break;
        case 4:
          Logger().d("Google Reward Called");
          GoogleRewarded().loadAd(
              context: context,
              onLoaded: () {
                Logger().d("Google Reward Loaded");
                timer!.cancel();
              },
              onComplete: () {
                Logger().d("Google Reward Complete");
                indexIncrement(
                    actionName,
                    mainJson
                            .data![mainJson.version]['actions'][actionName]
                                ['localClick']
                            .length -
                        1);
                timer!.cancel();
                onComplete();
              },
              onFailed: () {
                Logger().d("Google Reward Failed");
                failedActionBasedAds(
                  actionName: actionName,
                  from: 4,
                  context: context,
                  onComplete: () {
                    timer!.cancel();

                    onComplete();
                  },
                );
              });
          break;
        case 5:
          Logger().d("Google Reward Inter Called");
          GoogleRewardedInterstitial().loadAd(
              context: context,
              onLoaded: () {
                Logger().d("Google Reward Inter Loaded");
                timer!.cancel();
              },
              onComplete: () {
                Logger().d("Google Reward Inter Complete");
                indexIncrement(
                    actionName,
                    mainJson
                            .data![mainJson.version]['actions'][actionName]
                                ['localClick']
                            .length -
                        1);
                timer!.cancel();

                onComplete();
              },
              onFailed: () {
                Logger().d("Google Reward Inter Failed");
                failedActionBasedAds(
                  actionName: actionName,
                  from: 5,
                  context: context,
                  onComplete: () {
                    timer!.cancel();

                    onComplete();
                  },
                );
              });
          break;

        default:
          indexIncrement(
              actionName,
              mainJson
                      .data![mainJson.version]['actions'][actionName]
                          ['localClick']
                      .length -
                  1);
          timer!.cancel();

          onComplete();
          break;
      }
    }
  }

  failedScreenActionBasedAds(
      {required int from,
      required String actionName,
      required BuildContext context,
      required Function() onComplete}) {
    MainJson mainJson = context.read<MainJson>();
    String? route = ModalRoute.of(context)?.settings.name;

    Map? failedMapArray = mainJson.data![mainJson.version]['screens'][route]
        ['actions'][actionName]['localFail'];
    int caseIndex = failedMapArray![from.toString()];

    if (loopBreaker(
        mainJson.data![mainJson.version]['globalConfig']['maxFailed'])) {
      Logger().d("max failed");
      onComplete();
    } else {
      // timer = Timer.periodic(
      //     Duration(
      //         seconds: mainJson.data![mainJson.version]['globalConfig']
      //             ['overrideTimer']), (timer) {
      //   Logger().d("override Timer");
      //   onComplete();
      //   timer.cancel();
      //   return;
      // });
      switch (caseIndex) {
        case 0:
          Logger().d("Google Inter Called");
          GoogleInterstitial().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Google Inter Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Google Inter Complete");
              indexIncrement(
                  '$route/$actionName',
                  mainJson
                          .data![mainJson.version]['screens'][route]['actions']
                              [actionName]['localClick']
                          .length -
                      1);
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("Google Inter Failed");
              failedScreenActionBasedAds(
                actionName: actionName,
                from: 0,
                context: context,
                onComplete: () {
                  timer!.cancel();
                  onComplete();
                },
              );
            },
          );
          break;
        case 1:
          Logger().d("Applovin Inter Called");
          AppLovinInterstitial().loadAd(
            context: context,
            onLoaded: () {
              Logger().d("Applovin Inter Loaded");
              timer!.cancel();
            },
            onComplete: () {
              Logger().d("Applovin Inter Complete");
              indexIncrement(
                  '$route/$actionName',
                  mainJson
                          .data![mainJson.version]['screens'][route]['actions']
                              [actionName]['localClick']
                          .length -
                      1);
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("Applovin Inter Failed");
              failedScreenActionBasedAds(
                actionName: actionName,
                from: 1,
                context: context,
                onComplete: () {
                  timer!.cancel();
                  onComplete();
                },
              );
            },
          );
          break;
        case 2:
          Logger().d("IronSource Inter Called");
          IronSourceFullScreenX ironSourceFullScreenX =
              IronSourceFullScreenX.onInit(
            onLoaded: () {
              Logger().d("IronSource Inter Loaded");
              timer!.cancel();
              IronSource.showInterstitial();
            },
            onComplete: () {
              Logger().d("IronSource Inter Complete");
              indexIncrement(
                  '$route/$actionName',
                  mainJson
                          .data![mainJson.version]['screens'][route]['actions']
                              [actionName]['localClick']
                          .length -
                      1);
              timer!.cancel();
              onComplete();
            },
            onFailed: () {
              Logger().d("IronSource Inter Failed");
              failedScreenActionBasedAds(
                actionName: actionName,
                from: 2,
                context: context,
                onComplete: () {
                  timer!.cancel();
                  onComplete();
                },
              );
            },
          );

          IronSource.setLevelPlayInterstitialListener(ironSourceFullScreenX);
          IronSource.loadInterstitial();
          break;

        case 3:
          Logger().d("Unity Inter Called");
          UnityInterstitial().loadAd(
              context: context,
              onLoaded: () {
                Logger().d("Unity Inter Loaded");
                timer!.cancel();
              },
              onComplete: () {
                Logger().d("Unity Inter Complete");
                indexIncrement(
                    '$route/$actionName',
                    mainJson
                            .data![mainJson.version]['screens'][route]
                                ['actions'][actionName]['localClick']
                            .length -
                        1);
                timer!.cancel();
                onComplete();
              },
              onFailed: () {
                Logger().d("Unity Inter Failed");
                failedScreenActionBasedAds(
                  actionName: actionName,
                  from: 3,
                  context: context,
                  onComplete: () {
                    timer!.cancel();
                    onComplete();
                  },
                );
              });
          break;
        case 4:
          Logger().d("Google Reward Called");
          GoogleRewarded().loadAd(
              context: context,
              onLoaded: () {
                Logger().d("Google Reward Loaded");
                timer!.cancel();
              },
              onComplete: () {
                Logger().d("Google Reward Complete");
                indexIncrement(
                    '$route/$actionName',
                    mainJson
                            .data![mainJson.version]['screens'][route]
                                ['actions'][actionName]['localClick']
                            .length -
                        1);
                timer!.cancel();
                onComplete();
              },
              onFailed: () {
                Logger().d("Google Reward Failed");
                failedScreenActionBasedAds(
                  actionName: actionName,
                  from: 4,
                  context: context,
                  onComplete: () {
                    timer!.cancel();

                    onComplete();
                  },
                );
              });
          break;
        case 5:
          Logger().d("Google Reward Inter Called");
          GoogleRewardedInterstitial().loadAd(
              context: context,
              onLoaded: () {
                Logger().d("Google Reward Inter Loaded");
                timer!.cancel();
              },
              onComplete: () {
                Logger().d("Google Reward Inter Complete");
                indexIncrement(
                    '$route/$actionName',
                    mainJson
                            .data![mainJson.version]['screens'][route]
                                ['actions'][actionName]['localClick']
                            .length -
                        1);
                timer!.cancel();

                onComplete();
              },
              onFailed: () {
                Logger().d("Google Reward Inter Failed");
                failedScreenActionBasedAds(
                  actionName: actionName,
                  from: 5,
                  context: context,
                  onComplete: () {
                    timer!.cancel();
                    onComplete();
                  },
                );
              });
          break;

        default:
          indexIncrement(
              '$route/$actionName',
              mainJson
                      .data![mainJson.version]['screens'][route]['actions']
                          [actionName]['localClick']
                      .length -
                  1);
          timer!.cancel();

          onComplete();
          break;
      }
    }
  }
}
