import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sth/models/player.dart';
import 'package:sth/pages/fancy_profile.dart';
import 'package:sth/pages/view_image.dart';
import 'package:sth/utils/app_utils.dart';

class ProfileCard extends StatelessWidget {
  final Player player;

  const ProfileCard({
    Key? key,
    required this.player,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _tag = createStringTag();
    return GestureDetector(
      onTap: () {
        AppUtils(
          context: context,
        ).gotoPage(
            page: FancyProfilePage(
          player: player,
        ));
      },
      child: Card(
        margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4, top: 4),
        elevation: 3.0,
        child: Row(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Hero(
                tag: _tag,
                child: Container(
                  width: 100.0,
                  height: 125.0,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(5.0)),
                    image: DecorationImage(
                        image: NetworkImage(
                          "${player.profilePhoto}",
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              onTap: () {
                AppUtils(
                  context: context,
                ).gotoPage(
                    page: ViewImagePage(
                  tag: _tag,
                  imageUrl: "${player.profilePhoto}",
                ));
              },
            ),
            Expanded(
              child: Container(
                height: 125.0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(player.fullname,
                          style: Theme.of(context).textTheme.subtitle1),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        player.nationality,
                        style: Theme.of(context).textTheme.bodyText2,
                        // maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        player.category,
                        style: Theme.of(context).textTheme.bodyText2,
                        // maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '${player.teamName}',
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String createStringTag() {
    final Random random = Random.secure();
    var values = List<int>.generate(12, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }
}
