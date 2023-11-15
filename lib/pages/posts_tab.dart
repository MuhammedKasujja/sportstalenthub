import 'package:flutter/material.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/models/models.dart';
import 'package:sth/widgets/post_card.dart';
import 'package:sth/widgets/retry.dart';
import '../widgets/shimmers/shimmers.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage>
    with AutomaticKeepAliveClientMixin {
  final api = ApiService();
  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    posts = api.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerWidget(type: ShimmerType.post);
          // return PostShimmer();
        }
        if (snapshot.hasError) {
          return RetryAgainIcon(
            onTry: () {
              setState(() {
                posts = api.fetchPosts();
              });
            },
          );
        }
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) =>
              PostCard(tag: "$index", post: snapshot.data![index]),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  Post post = Post(
      postId: '3456789',
      title: "There is no doubt Lionel Messi's Talent has made him a legend",
      description: info,
      imageUrl: 'http://img.youtube.com/vi/rqahKvZZVdg/0.jpg',
      // imageUrl: 'lib/images/lionels_mesi.png',
      date: '20/04/2019 10:39 AM',
      category: 'Football');

  static String info = '''Lionel Andrés "Leo" Messi is an Argentine
       professional footballer who plays as a forward 
       for Spanish club FC Barcelona and the Argentina 
       national team. Often considered the best player in 
       the world and rated by many in the sport as the greatest 
       of all time, Messi is the only football player in history 
       to win five FIFA Ballons d'Or, four of which he won consecutively, 
       and the first player to win three European Golden Shoes. 
       With Barcelona he has won eight La Liga titles and four 
       UEFA Champions League titles, as well as four Copas del Rey. 
       Both a prolific goalscorer and a creative playmaker, Messi 
       holds the records for most goals scored in La Liga, a La Liga season (50), 
       a football season (82), and a calendar year (91), as well as those for most 
       assists made in La Liga and the Copa América. He has scored over 500 senior 
       career goals for club and country.''';
}
