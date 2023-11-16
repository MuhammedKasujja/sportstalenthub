class Urls {
  Urls._();

  // static const BASE_URL =  "http://192.168.1.106/hub/api";
  // static const BASE_URL =  "http://josemusicapps.000webhostapp.com/hub/api";
  // static const BASE_URL =  "http://kasmudtech.000webhostapp.com/hub/api";
  static const baseUrl = "https://www.sportstalenthub.com/hub/api";
  static const GET_PLAYERS = "/getPlayers.php?category=";
  static const GET_SPORTS = "/getSportsCategories.php";
  static const GET_PLAYERS_ATTACHMENTS = "/getAttachments.php?";
  static const GET_PAGING_PLAYERS = "/pagingPlayers.php?category=";
  static const SEARCH_PLAYERS = "/searchPlayers.php?query=";
  static const MY_FAVOURITE_PLAYERS = "/fetchFavouritePlayers.php?";
  static const GET_POSTS = "/fetchPosts.php?";
  static const FILTER_PLAYERS = "/filterPlayers.php?";
  static const GET_PLAYERS_ACHIEVEMENTS = "/getAchievements.php?";

  static const POST_FULL_ARTICLE = "/postFullArticle.php?";

  static const PROFILE_PHOTO_LINK =
      "https://www.sportstalenthub.com/media/cache/my_thumb_330x242/images/players/";
  static const ACTION_PHOTOS_LINKS =
      "https://www.sportstalenthub.com/media/cache/my_thumb_690x450/images/action_photos/";
  static const POST_IMAGE_LINKS =
      "https://www.sportstalenthub.com/media/cache/my_thumb_690x450/images/posts/";
}
