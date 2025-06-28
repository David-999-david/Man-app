import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/home/notifier/home_notifier.dart';
import 'package:user_auth/presentation/home/widgets/addtodo.dart';
import 'package:user_auth/presentation/home/widgets/edittodo.dart';
import 'package:user_auth/presentation/widgets/loading_show.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomeNotifier()..getAllTodo(),
        child: Consumer<HomeNotifier>(
          builder: (scaffoldCtx, provider, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Home',
                  style: 21.sp(color: Color(0xFFBDBDBD)),
                ),
                centerTitle: true,
                actions: [
                  provider.selectedTodo.isNotEmpty
                      ? Row(
                          children: [
                            IconButton(
                                onPressed: () async {
                                  final success = await provider.removeMany();
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '${provider.deletedCounts} items had been deleted')));
                                    provider.getAllTodo();
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            TextButton(
                                onPressed: () {
                                  provider.cancel();
                                },
                                child: Text(
                                  'Cancel',
                                  style: 13.sp(color: Colors.white),
                                ))
                          ],
                        )
                      : SizedBox.shrink()
                ],
              ),
              body: provider.loading
                  ? LoadingShow()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 42,
                                  width: 300,
                                  color: Color(0xFF212121),
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: TextField(
                                      controller: provider.searchQuery,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide()),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide()),
                                      ),
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          provider.refresh();
                                          provider.getAllTodo();
                                        } else {
                                          provider.onSearch();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: provider.seeMore
                                      ? InkWell(
                                          onTap: () {
                                            provider.refresh();
                                            provider.getAllTodo();
                                          },
                                          child: Icon(
                                            Icons.refresh,
                                            color: Colors.lightBlue,
                                            size: 20,
                                          ))
                                      : InkWell(
                                          onTap: () {
                                            provider.loadMore();
                                            provider.getAllTodo();
                                          },
                                          child: Text(
                                            softWrap: true,
                                            'More..',
                                            style:
                                                12.sp(color: Colors.lightBlue),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          _todoItem(provider, scaffoldCtx),
                          provider.seeMore
                              ? Row()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: provider.currentPage <= 1
                                                  ? Colors.grey
                                                  : Colors.orange),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          backgroundColor:
                                              provider.currentPage <= 1
                                                  ? Color(0xFF212121)
                                                  : Color(0xFFBDBDBD),
                                        ),
                                        onPressed: provider.currentPage <= 1
                                            ? null
                                            : () {
                                                provider.prevPage();
                                                provider.getAllTodo();
                                              },
                                        child: Text(
                                          'Prev',
                                          style: 15.sp(
                                              color: provider.currentPage <= 1
                                                  ? Colors.grey
                                                  : Color(0xFF212121)),
                                        )),
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: provider.currentPage ==
                                                      provider.totalPage
                                                  ? Colors.grey
                                                  : Colors.orange),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          backgroundColor:
                                              provider.currentPage ==
                                                      provider.totalPage
                                                  ? Color(0xFF212121)
                                                  : Color(0xFFBDBDBD),
                                        ),
                                        onPressed: provider.currentPage ==
                                                provider.totalPage
                                            ? null
                                            : () {
                                                provider.nextPage();
                                                provider.getAllTodo();
                                              },
                                        child: Text(
                                          'Next',
                                          style: 15.sp(
                                              color: provider.currentPage ==
                                                      provider.totalPage
                                                  ? Colors.grey
                                                  : Color(0xFF212121)),
                                        ))
                                  ],
                                ),
                        ],
                      ),
                    ),
              floatingActionButton: FloatingActionButton(
                mini: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  final created = AppNavigator.push<bool>(
                      context,
                      ChangeNotifierProvider.value(
                        value: provider,
                        child: Addtodo(),
                      ));
                  if (created == true) {
                    provider.getAllTodo();
                  }
                },
                child: Icon(
                  Icons.add,
                  size: 20,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniEndDocked,
            );
          },
        ));
  }
}

Widget _todoItem(HomeNotifier provider, BuildContext scafflodCtx) {
  return Expanded(
    child: ListView.separated(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final currentTodo = provider.todoList[index];
          final isSelected = provider.selectedTodo.contains(currentTodo);
          return Slidable(
            key: ValueKey(currentTodo.id),
            endActionPane: ActionPane(
                motion: DrawerMotion(),
                extentRatio: 0.23,
                children: [
                  SlidableAction(
                    onPressed: (_) async {
                      final success = await AppNavigator.push<bool>(
                          context,
                          ChangeNotifierProvider<HomeNotifier>(
                            create: (_) =>
                                HomeNotifier(editTodo: currentTodo)..getOld(),
                            child: Edittodo(editTodo: currentTodo),
                          ));
                      if (success == true) {
                        provider.getAllTodo();
                      }
                    },
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SlidableAction(
                    onPressed: (_) async {
                      final bool success =
                          await provider.removeOne(currentTodo);
                      if (success == true) {
                        provider.getAllTodo();
                        ScaffoldMessenger.of(scafflodCtx).showSnackBar(SnackBar(
                            content: Text(
                          '1 items had been removed!',
                        )));
                      }
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.clear,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ]),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  child: Text(
                    ((provider.currentPage - 1) * provider.limit + index + 1)
                        .toString(),
                    style: 13.sp(),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: InkWell(
                    onLongPress: () {
                      provider.onSelect(currentTodo);
                    },
                    child: Card(
                      color: Color(0xFFBDBDBD),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: isSelected
                                  ? Colors.green
                                  : currentTodo.completed
                                      ? Colors.blue
                                      : Colors.red)),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentTodo.title,
                                style: 17.sp(color: Color(0xFF212121)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                currentTodo.description,
                                style: 14.sp(color: Color(0xFF212121)),
                              ),
                            ],
                          )),
                    ),
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 10,
          );
        },
        itemCount: provider.todoList.length),
  );
}
