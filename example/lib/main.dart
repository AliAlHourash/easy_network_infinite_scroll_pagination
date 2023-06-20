import 'package:dio/dio.dart';
import 'package:easy_network_infinite_scroll_pagination_package/easy_network_infinite_scroll_pagination_package.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: EasyNetworkInfiniteScrollPagination(
          data: (d) {
            print("data=====>>>  ${d}");
          },
          url: "http://xxx/api/services",
          child: (r) {
            return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                color: Colors.green,
                child: Text(r['id'].toString() + r['name']['ar'].toString()));
          },
          urlParameters: const {
            "interested_category_ids": "[18]",
            "perPage": "4",
          },
          numberOfPostsPerRequest: 4,
          initialPageNumber: 1,
          function: (Response r) {
            return r.data['data'];
          },
        ));
  }
}
