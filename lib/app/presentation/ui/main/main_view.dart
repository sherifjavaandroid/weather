import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weather/app/presentation/ui/main/widgets/day_hourly_view.dart';
import 'package:weather/app/presentation/ui/main/widgets/location_widget.dart';
import 'package:weather/app/presentation/ui/main/widgets/main_widgets.dart';
import 'package:weather/app/presentation/ui/main/widgets/temp_widget.dart';
import 'package:weather/app/presentation/ui/main/widgets/time_widget.dart';

import '../../../shared/constant/string_keys.dart';
import '../../../shared/core/base/baseview.dart';
import '../../../shared/core/base/refresh_view.dart';
import '../../../shared/style/color.dart';
import '../../../shared/style/widgets.dart';
import '../../../shared/utils/utils.dart';
import 'mainviewmodel.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<MainViewModel>(
      init: (MainViewModel vm) => vm.init(),
      builder: (BuildContext context, MainViewModel vm, Widget? child) {
        return vm.isBusy()
            ? const AppProgress()
            : Scaffold(
                backgroundColor: Color(0xfff0f1141),
                appBar: AppBar(
                  backgroundColor: Color(0xfff0f1141),
                  actions: vm.screenError
                      ? null
                      : <Widget>[
                          buildMainPopUp(
                            context: context,
                            popUpItems: vm.popupmodel,
                          ),
                        ],
                  //   bottom: appBarDivider(),
                ),
                body: refreshIndicatorView(
                  onRefresh: () => vm.refreshScreen(context),
                  child: vm.screenError
                      ? const SomethingWentWrongView()
                      : Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 760.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Stack(
                                  children: [
                                    SizedBox(
                                      height: 370,
                                      width: 360,
                                      child: Image.asset(
                                          "assets/png/main_card.png"),
                                    ),
                                    const Positioned(
                                      left: 5,
                                      right: 0,
                                      top: 130,
                                      bottom: 0,
                                      child: Text(
                                        "Weather",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: -140,
                                      top: -150,
                                      bottom: 0,
                                      child: Image.asset("assets/png/sun.png"),
                                    ),
                                    Positioned(
                                        left: 5,
                                        right: 0,
                                        top: 180,
                                        bottom: 0,
                                        child: Text(
                                            "${vm.weather?.current?.weather?[0].description}")),
                                    Positioned(
                                      left: 5,
                                      right: 0,
                                      top: 200,
                                      bottom: 0,
                                      child: buildTimeWidget(
                                        context: context,
                                        time: vm.weather?.current?.dt,
                                      ),
                                    ),
                                    Positioned(
                                      left: 5,
                                      right: 0,
                                      top: 95,
                                      bottom: 0,
                                      child: buildLocationWidget(
                                        context: context,
                                        location: getClearName(
                                          vm.location?.city,
                                          vm.location?.country,
                                          comma: true,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 5,
                                      right: 0,
                                      top: 250,
                                      bottom: 0,
                                      child: buildTempWidget(
                                        context: context,
                                        temp: vm.weather?.current?.temp,
                                        description: "",
                                        icon: vm
                                            .weather?.current?.weather?[0].icon,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                buildDayOrHourlyView(
                                  context: context,
                                  viewIndex: vm.viewIndex,
                                  weatherHourly: vm.weather?.hourly ?? [],
                                  weatherByDay: vm.weather?.daily ?? [],
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              );
      },
    );
  }
}





/*

  
                             



*/