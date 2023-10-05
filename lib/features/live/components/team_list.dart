import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:the_hit_times_app/features/live/models/team_detail.dart';
import 'package:the_hit_times_app/util/cache_manager.dart';

class TeamList extends StatefulWidget {
  String team1Code;
  String team2Code;

  TeamList({super.key, required this.team1Code, required this.team2Code});

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> with AutomaticKeepAliveClientMixin  {
  static const String BASE_URL = "https://tht-admin.onrender.com/api/team/";

  bool isLoading = true;
  bool isError = false;
  late TeamDetails team1Details;
  late TeamDetails team2Details;

  @override
  initState() {
    super.initState();
    loadTeams();
  }

  // load teams information from api
  void loadTeams() async {

      var team1Response = await CachedHttp.get(BASE_URL + widget.team1Code,
          headers: {"Content-Type": "application/json"});
      var team2Response = await CachedHttp.get(BASE_URL + widget.team2Code,
          headers: {"Content-Type": "application/json"});

      if (team1Response.error ||
          team2Response.error || team1Response.responseBody['data'] == null || team2Response.responseBody['data'] == null) {
        setState(() {
          isError = true;
          isLoading = false;
        });
        return;
      }
      setState(() {
        team1Details = TeamDetails.fromJson(team1Response.responseBody['data']);
        team2Details = TeamDetails.fromJson(team2Response.responseBody['data']);
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : isError
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Failed to load team details",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    FilledButton.icon(
                      icon: Icon(Icons.refresh),
                      onPressed: () {

                        setState(() {
                          isLoading = true;
                          isError = false;
                        });

                      loadTeams();
                    }, label: Text("Retry"),)
                  ],
                ),
              )
            :
    Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Team ${team1Details.football.teamName}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              Text(
                "Team ${team2Details.football.teamName}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8.0),
              shrinkWrap: true,
              itemCount: max(team1Details.football.players.length, team2Details.football.players.length),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      index > team1Details.football.players.length - 1 ? Container() :
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: team1Details
                                    .football.players[index].getPlayerImage(),
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.person ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                team1Details
                                    .football.players[index].playerName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 2.0,),
                              Text(
                                  team1Details.football.players[index]
                                      .playerDescription,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.grey[400])),
                            ],
                          ),
                        ],
                      ),
                      index > team2Details.football.players.length - 1 ? Container() :
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                team2Details
                                    .football.players[index].playerName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 2.0,),
                              Text(
                                  team2Details.football.players[index]
                                      .playerDescription,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.grey[400])),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: team2Details
                                    .football.players[index].getPlayerImage(),
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.person ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // This is used to keep the state of the widget alive
  // ie. when we switch between tabs, the state of the widget is not lost.
  @override
  bool get wantKeepAlive => true;
}
