import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_hit_times_app/bookmark_service/bookmark_service.dart';
import 'package:the_hit_times_app/card_ui.dart';
import 'package:the_hit_times_app/models/postmodel.dart';
import 'package:the_hit_times_app/news.dart';
import 'package:the_hit_times_app/display.dart';

class Weeklies extends StatefulWidget {
  @override
  _WeekliesState createState() => _WeekliesState();
}

class _WeekliesState extends State<Weeklies> {
  List<PostModel> items = [];
  List<PostModel> localnews = [];
  int limit = 15;
  int page = 1;
  bool hasmore = true;
  bool loading = false;
  late PostList allPosts;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    getSWData();
    getLocalNews();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print("Bottom");

        this.getSWData();
      }
    });
  }

  Future<String> getSWData() async {
    if (!hasmore) return "";
    if (loading) return "Loading";
    loading = true;
    final String url =
        "https://the-hit-times-admin-production.up.railway.app/api/posts/weeklies?limit=$limit&page=$page";
    print("Fetching... $url");
    var res = await http.get(Uri.parse(Uri.encodeFull(url)),
        headers: {"Accept": "application/json"});
    setState(() {
      page = page + 1;

      var resBody = json.decode(res.body);
      allPosts = PostList.fromJson(resBody);
      allPosts.posts.map((e) => print(e.body));
      if (resBody.length < limit) {
        hasmore = false;
      }
      items.addAll(allPosts.posts);
      loading = false;
    });
    return "Success";
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getLocalNews() async {
    localnews = await BookMarkService().getLocalNews();
  }

  addnews(PostModel data) {
    BookMarkService().saveNews(data);
    setState(() {
      getLocalNews();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: const Text('News is added to bookmark'),
    ));
  }

  deletenews(PostModel data) {
    BookMarkService().deleteNews(data);
    setState(() {
      getLocalNews();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: const Text('News is removed from bookmark'),
    ));
  }

  bool checkAdded(PostModel data) {
    final ispresent = localnews.any((item) => item.id == data.id);
    return ispresent;
  }

  Future<String> handelRefresh() async {
    setState(() {
      items = [];
      limit = 15;
      page = 1;
      hasmore = true;
      loading = false;
    });
    getSWData();
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        // child : DisplayBody(author: "Ayab", body: "bidu",date: "today",)
        child: RefreshIndicator(
          onRefresh: handelRefresh,
          child: items.isEmpty
              ? const Center(child: const CircularProgressIndicator())
              : items.length != 0
                  ? ListView.builder(
                      itemCount: items.length + 1,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < items.length) {
                          return InkWell(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      DisplayPost(
                                    pIndex: index,
                                    title: items[index].title,
                                    body: items[index].body,
                                    imgUrl: items[index].link,
                                    description: items[index].description,
                                    date: items[index].createdAt,
                                    category: int.parse(items[index].dropdown),
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ));
                              },
                              child: CusCard(
                                link: items[index].link,
                                title: items[index].title,
                                description: items[index].description,
                                body: items[index].body,
                                createdAt: items[index].createdAt,
                                cImage: items[index].cImage,
                                dropdown: items[index].dropdown,
                                id: items[index].id,
                                updatedAt: items[index].updatedAt,
                                bookmarked: checkAdded(items[index]),
                                add: addnews,
                                delete: deletenews,
                              ));
                        } else {
                          return hasmore
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: const Center(
                                      child: CircularProgressIndicator()))
                              : Container();
                        }
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chrome_reader_mode,
                              color: Colors.grey, size: 60.0),
                          Text(
                            "No articles found",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    ]);
  }
}

class AppX extends StatefulWidget {
  @override
  _AppXState createState() => _AppXState();
}

class _AppXState extends State<AppX> {
  List<PostModel> items = [];
  List<PostModel> localnews = [];
  int limit = 15;
  int page = 1;
  bool hasmore = true;
  bool loading = false;
  late PostList allPosts;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    getSWData();
    getLocalNews();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print("Bottom");

        this.getSWData();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<String> getSWData() async {
    if (!hasmore) return "";
    if (loading) return "Loading";
    loading = true;
    final String url =
        "https://the-hit-times-admin-production.up.railway.app/api/posts/appx?limit=$limit&page=$page";
    print("Fetching... $url");
    var res = await http.get(Uri.parse(Uri.encodeFull(url)),
        headers: {"Accept": "application/json"});
    setState(() {
      page = page + 1;

      var resBody = json.decode(res.body);
      allPosts = PostList.fromJson(resBody);
      allPosts.posts.map((e) => print(e.body));
      if (resBody.length < limit) {
        hasmore = false;
      }
      items.addAll(allPosts.posts);
      loading = false;
    });
    return "Success";
  }

  getLocalNews() async {
    localnews = await BookMarkService().getLocalNews();
    print(localnews);
  }

  addnews(PostModel data) {
    BookMarkService().saveNews(data);
    setState(() {
      getLocalNews();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: const Text('News is added to bookmark'),
    ));
  }

  deletenews(PostModel data) {
    BookMarkService().deleteNews(data);
    setState(() {
      getLocalNews();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: const Text('News is removed from bookmark'),
    ));
  }

  bool checkAdded(PostModel data) {
    final ispresent = localnews.any((item) => item.id == data.id);
    return ispresent;
  }

  Future<String> handelRefresh() async {
    setState(() {
      items = [];
      limit = 15;
      page = 1;
      hasmore = true;
      loading = false;
    });
    getSWData();
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        // child : DisplayBody(author: "Ayab", body: "bidu",date: "today",)
        child: RefreshIndicator(
          onRefresh: handelRefresh,
          child: items.isEmpty
              ? const Center(child: const CircularProgressIndicator())
              : items.length != 0
                  ? ListView.builder(
                      itemCount: items.length + 1,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < items.length) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        DisplayPost(
                                  pIndex: index,
                                  title: items[index].title,
                                  body: items[index].body,
                                  imgUrl: items[index].link,
                                  description: items[index].description,
                                  date: items[index].createdAt,
                                  category: int.parse(items[index].dropdown),
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(0.0, 1.0);
                                  const end = Offset.zero;
                                  const curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ));
                            },
                            child: CusCard(
                              link: items[index].link,
                              title: items[index].title,
                              description: items[index].description,
                              body: items[index].body,
                              createdAt: items[index].createdAt,
                              cImage: items[index].cImage,
                              dropdown: items[index].dropdown,
                              id: items[index].id,
                              updatedAt: items[index].updatedAt,
                              bookmarked: checkAdded(items[index]),
                              add: addnews,
                              delete: deletenews,
                            ),
                          );
                        } else {
                          return hasmore
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: const Center(
                                      child: CircularProgressIndicator()))
                              : Container();
                        }
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chrome_reader_mode,
                              color: Colors.grey, size: 60.0),
                          Text(
                            "No articles found",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    ]);
  }
}
