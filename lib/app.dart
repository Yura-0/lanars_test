import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanars_test/core/injector.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/pages/auth_page.dart';
import 'features/home/bloc/photo_bloc.dart';
import 'features/home/pages/home_page.dart';

class LanarsApp extends StatelessWidget {
  const LanarsApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => locator<AuthBloc>()..add(AppStarted()),
            ),
            BlocProvider(
              create: (context) => PhotoBloc(),
            ),
          ],
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              Widget initialWidget;
              if (state is AuthSuccess) {
                initialWidget = const HomePage();
              } else {
                initialWidget = const AuthPage();
              }

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: initialWidget,
              );
            },
          ),
        );
      },
    );
  }
}
