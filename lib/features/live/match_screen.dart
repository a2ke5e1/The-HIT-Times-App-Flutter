import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';
import 'package:the_hit_times_app/features/live/repo/live_match_repo.dart';

import 'components/football_score_card.dart';
import 'components/timeline_listview.dart';

class MatchScreenArguments {
  final String id;

  MatchScreenArguments({required this.id});
}

class MatchScreen extends StatelessWidget {
  static const ROUTE_NAME = "/live-screen/timeline";

  String? matchId;

  MatchScreen({super.key, this.matchId});

  LiveMatchRepo _liveMatchRepo = LiveMatchRepo();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as MatchScreenArguments?;

    if (matchId == null && args != null) {
      matchId = args.id;
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              title: Text("The Hit Times"),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.teal,
              expandedHeight: 200.0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    debugPrint("Share");
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: _liveMatchRepo.getLiveMatchById(matchId!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    if (snapshot.hasData) {
                      final match = LiveMatch.fromFirestore(snapshot.data!, null);
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 40.0),
                          child: FootballScoreCard(liveMatch: match, backgroundColor: Colors.teal),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(60.0),
                child: TabBar(
                  indicatorWeight: 3.0,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text(
                        "Timeline",
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Lineup",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TabBarView(
                  children: [
                    TimelineListView(matchFirebaseId: matchId!),
                    Center(child: Text("Lineup", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),)),
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
