import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sth/models/player.dart';
import 'package:sth/pages/fancy_profile.dart';
import 'package:sth/pages/view_image.dart';
import 'package:sth/utils/app_utils.dart';

class ProfileCard extends StatelessWidget {
  final Player player;

  const ProfileCard({
    super.key,
    required this.player,
  });
  @override
  Widget build(BuildContext context) {
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
        margin: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 4,
          top: 4,
        ),
        elevation: 3.0,
        child: Row(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Hero(
                tag: player.imageTag,
                child: Container(
                  width: 100.0,
                  height: 125.0,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(5.0),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        player.profilePhoto,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              onTap: () {
                AppUtils(
                  context: context,
                ).gotoPage(
                    page: ViewImagePage(
                  tag: player.imageTag,
                  imageUrl: player.profilePhoto,
                ));
              },
            ),
            Expanded(
              child: SizedBox(
                height: 125.0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        player.fullname,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        player.nationality,
                        style: Theme.of(context).textTheme.bodyMedium,
                        // maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        player.category,
                        style: Theme.of(context).textTheme.bodyMedium,
                        // maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          player.teamName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
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
}
