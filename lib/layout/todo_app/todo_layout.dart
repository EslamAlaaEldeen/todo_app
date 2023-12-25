import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todaapp/layout/todo_app/cubit/cubit.dart';
import 'package:todaapp/layout/todo_app/cubit/states.dart';
import 'package:todaapp/shared/components/components.dart';

import '../../shared/components/constants.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formdkey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {
        if (state is AppInsertDataBaseState) {
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldkey,
          appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text(
                cubit.titles[cubit.currentindex],
                style: TextStyle(color: Colors.white),
              )),
          body: ConditionalBuilder(
              condition: state is! AppGetDataBaseLoadingState,
              builder: (context) => cubit.Screens[cubit.currentindex],
              fallback: (context) => Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue,
                  ))),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formdkey.currentState!.validate()) {
                  cubit.InsertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text);
                }
              } else {
                scaffoldkey.currentState!
                    .showBottomSheet(
                      (context) => Container(
                        color: Colors.grey[200],
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formdkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'title must not empty';
                                    }
                                    return null;
                                  },
                                  labeltext: 'task title',
                                  prefex: Icons.title),
                              SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'time must not empty';
                                    }
                                    return null;
                                  },
                                  labeltext: 'task time',
                                  prefex: Icons.watch_later_outlined),
                              SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2024-12-25'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'date must not empty';
                                    }
                                    return null;
                                  },
                                  labeltext: 'task date',
                                  prefex: Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                      elevation: 20,
                    )
                    .closed
                    .then((value) {
                  cubit.ChangeBottomSheetState(
                    isShow: false,
                    icon: Icons.edit,
                  );
                });
                cubit.ChangeBottomSheetState(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(
              cubit.fabicon,
              color: Colors.white,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blue,
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentindex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: 'Archived'),
            ],
          ),
        );
      },
    );
  }
}
