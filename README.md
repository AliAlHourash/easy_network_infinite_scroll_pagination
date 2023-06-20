<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

An easy Flutter package that enables data pagination from a network source.

## Features

By utilizing your widget, you can easily call API data by incorporating the URL and query parameters.

## Getting started

add dio into the dependencies section in your pubspec.yaml:
```
easy_network_infinite_scroll_pagination:
```

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
EasyNetworkInfiniteScrollPagination(
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
                                                function: (Response r){
                                                      return r.data['data'];
                                                },)
```


