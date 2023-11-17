import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sth/models/enums.dart';
import 'package:sth/widgets/shimmers/shimmers.dart';

class ShimmerWidget extends StatelessWidget {
  final ShimmerType type;
  final int itemLength;

  const ShimmerWidget({super.key,  required this.type, this.itemLength = 10});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 16.0,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: itemLength,
          padding: const EdgeInsets.only(bottom: 8.0),
          itemBuilder: (_, index) {
            Widget shimmer = type == ShimmerType.player
                ? const PlayerShimmer()
                : type == ShimmerType.post
                    ? const PostShimmer()
                    : type == ShimmerType.careerPath
                        ? const CareerPathShimmer()
                        : Container();
            return shimmer;
          },
          separatorBuilder: (context, index) => Container(
            height: 10,
          ),
        ),
      ),
    );
  }
}
