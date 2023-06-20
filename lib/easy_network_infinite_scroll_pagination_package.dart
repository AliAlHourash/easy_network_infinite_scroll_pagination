library easy_network_infinite_scroll_pagination_package;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class EasyNetworkInfiniteScrollPagination extends StatefulWidget {
  ///===========================================
  ///Example of calling EasyNetworkInfiniteScrollPagination:
  ///   EasyNetworkInfiniteScrollPagination(
  /// data: (d) {
  /// print("data=====>>>  ${d}");
  /// },
  /// url: "http://ymp-api-test.vns.agency/api/services",
  /// child: (r) {
  ///  return Container(
  ///  margin: const EdgeInsets.all(8),
  ///  padding: const EdgeInsets.all(8),
  ///  color: Colors.green,
  ///  child: Text(r['id'].toString() + r['name']['ar'].toString()));
  ///   },
  ///  urlParameters: const {
  ///  "interested_category_ids": "[18]",
  ///   "perPage": "4",
  ///  },
  /// numberOfPostsPerRequest: 4,
  ///  initialPageNumber: 1,
  ///   function: (Response r){
  ///   return r.data['data'];
  ///  },)
  const EasyNetworkInfiniteScrollPagination({
    Key? key,
    // required this.model,
    required this.child,
    required this.function,
    this.urlParameters,
    this.initialPageNumber = 1,
    this.pageKey,
    this.appBar,
    this.options,
    required this.data,
    required this.url,
    required this.numberOfPostsPerRequest,
    this.firstPageErrorIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.animateTransitions = false,
    this.transitionDuration = const Duration(milliseconds: 250),
  }) : super(key: key);

  ///Example of using the child:
  /// child: (r) {
  /// return Container(
  /// margin: const EdgeInsets.all(8),
  /// padding: const EdgeInsets.all(8),
  /// color: Colors.green,
  ///  child: Text(r['id'].toString() + r['name']));}
  final Widget Function(dynamic data) child;
  final ValueChanged<dynamic> data;
  final String url;

  ///Example of parameters:
  /// urlParameters: const {
  ///   "interested_category_ids": '[18]',
  ///   "perPage": '4'
  /// },
  final Map<String, dynamic>? urlParameters;

  ///this function will return a List type of the response from `Dio` package.
  ///ex: if the response like: `{"data":[]}`, the function will return like:
  /// function: (Response response){ return response.data['data']; }
  final Function(Response val) function;

  ///page key like `page` that will send through the url. ex: ["page"]: 1,
  ///if this parameter is empty that means there is no pagination.
  final String? pageKey;

  /// the default of initial Page Number is `1`
  final int? initialPageNumber;

  /// the default of number Of Posts Per Request is `15`,
  /// it must be the same number with the urlParameters
  final int numberOfPostsPerRequest;
  final AppBar? appBar;
  final Options? options;

  /// The builder for the first page's error indicator.
  final WidgetBuilder? firstPageErrorIndicatorBuilder;

  /// The builder for a new page's error indicator.
  final WidgetBuilder? newPageErrorIndicatorBuilder;

  /// The builder for the first page's progress indicator.
  final WidgetBuilder? firstPageProgressIndicatorBuilder;

  /// The builder for a new page's progress indicator.
  final WidgetBuilder? newPageProgressIndicatorBuilder;

  /// The builder for a no items list indicator.
  final WidgetBuilder? noItemsFoundIndicatorBuilder;

  /// The builder for an indicator that all items have been fetched.
  final WidgetBuilder? noMoreItemsIndicatorBuilder;

  /// Whether status transitions should be animated.
  final bool animateTransitions;

  /// The duration of animated transitions when [animateTransitions] is `true`.
  final Duration transitionDuration;

  @override
  State<EasyNetworkInfiniteScrollPagination> createState() =>
      _EasyNetworkInfiniteScrollPaginationState();
}

class _EasyNetworkInfiniteScrollPaginationState extends State<EasyNetworkInfiniteScrollPagination> {
  late final int _numberOfPostsPerRequest;

  late final PagingController<int, dynamic> _pagingController;

  @override
  void initState() {
    _numberOfPostsPerRequest = widget.numberOfPostsPerRequest ?? 15;
    _pagingController =
        PagingController(firstPageKey: widget.initialPageNumber ?? 1);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    var p = widget.urlParameters ?? {};
    if (widget.pageKey != null) {
      p["page"] = "$pageKey";
    }
    try {
      await Future.delayed(const Duration(seconds: 3));
      final response = await getMETHOD(widget.url,
          queryParameters: p, options: widget.options);

      List responseList = [];

      responseList = widget.function(response) ?? [];
      widget.data(responseList);

      final isLastPage = responseList.length < _numberOfPostsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(responseList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(responseList, nextPageKey);
      }
    } catch (e) {
      if (kDebugMode) {
        print("error --> $e");
      }
      _pagingController.error = e;
    }
  }

  final Dio _dio = Dio();

  Future<Response> getMETHOD(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options ??
            Options(headers: {
              'accept': 'application/json',
              'content-type': 'application/json'
            }),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, dynamic>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) => widget.child(item),
              animateTransitions: widget.animateTransitions,
              firstPageErrorIndicatorBuilder:
                  widget.firstPageErrorIndicatorBuilder,
              firstPageProgressIndicatorBuilder:
                  widget.firstPageProgressIndicatorBuilder,
              newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder,
              newPageProgressIndicatorBuilder:
                  widget.newPageProgressIndicatorBuilder,
              noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder,
              noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder,
              transitionDuration: widget.transitionDuration),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
