
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todaapp/layout/todo_app/cubit/cubit.dart';
import 'package:todaapp/layout/todo_app/cubit/states.dart';
import 'package:todaapp/shared/components/components.dart';

import '../../../shared/components/constants.dart';

class HomeTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newtasks;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}
