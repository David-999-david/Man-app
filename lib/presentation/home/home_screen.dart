import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/home/notifier/home_notifier.dart';
import 'package:user_auth/presentation/widgets/loading_show.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomeNotifier()..getAllTodo(),
        child: Consumer<HomeNotifier>(
          builder: (context, provider, child) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Home',
                    style: 21.sp(color: Color(0xFFBDBDBD)),
                  ),
                  centerTitle: true,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          provider.onSearch();
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
                                              style: 12
                                                  .sp(color: Colors.lightBlue),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          child: Text(
                                            ((provider.currentPage - 1) *
                                                        provider.limit +
                                                    index +
                                                    1)
                                                .toString(),
                                            style: 13.sp(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: Color(0xFFBDBDBD),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: provider
                                                            .todoList[index]
                                                            .completed
                                                        ? Colors.blue
                                                        : Colors.red)),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      provider.todoList[index]
                                                          .title,
                                                      style: 17.sp(
                                                          color: Color(
                                                              0xFF212121)),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      provider.todoList[index]
                                                          .description,
                                                      style: 14.sp(
                                                          color: Color(
                                                              0xFF212121)),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemCount: provider.todoList.length),
                            ),
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
                                  )
                          ],
                        ),
                      ));
          },
        ));
  }
}
