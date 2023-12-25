import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todaapp/layout/todo_app/cubit/states.dart';

import 'layout/todo_app/cubit/cubit.dart';
import 'layout/todo_app/todo_layout.dart';
import 'shared/components/bloc_observer.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  Widget widget;
  widget = HomeLayout();
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  MyApp({this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..CreateDataBase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
                debugShowCheckedModeBanner: false, home: startWidget);
          },
        ));
  }
}
