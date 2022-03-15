import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qinghe_ios/config/data_config.dart';
import 'package:qinghe_ios/controller/count_controller.dart';
import 'package:qinghe_ios/data/config/base_route.dart';
import 'package:qinghe_ios/theme/theme_bloc.dart';
import 'package:qinghe_ios/theme/theme_event.dart';
import 'package:qinghe_ios/theme/theme_state.dart';
import 'package:qinghe_ios/ui/page/home_page.dart';
import 'package:qinghe_ios/config/base_theme.dart';

void main() async {
  // ///GetStorage
  // await GetStorage.init();
  // runApp(const MyApp());

  ///SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  DataConfig.getIns().doAfterCreated(() {
    runApp(const MyApp());
  });

  if (Platform.isAndroid) {
    SystemUiOverlayStyle style = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<CountController>(() => CountController(),
        tag: CountController.tag);

    ///GetX
    return GetMaterialApp(
      themeMode: DataConfig.getIns().themeMode
          ? ThemeMode.system
          : DataConfig.getIns().themeType == 0
              ? ThemeMode.light
              : ThemeMode.dark,
      theme: BaseTheme.light,
      darkTheme: BaseTheme.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: BaseRoute.Initial,
      getPages: BasePage.pages,
    );

    ///Bloc
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc()..add(const ThemeInitEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          var mode = state == ThemeState.Light
              ? ThemeMode.light
              : state == ThemeState.Dark
                  ? ThemeMode.dark
                  : ThemeMode.system;
          return MaterialApp(
            themeMode: mode,
            theme: BaseTheme.light,
            darkTheme: BaseTheme.dark,
            debugShowCheckedModeBanner: false,
            initialRoute: BaseRoute.Initial,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
