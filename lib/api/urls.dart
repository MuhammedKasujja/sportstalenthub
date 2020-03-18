class Urls{
  Urls._();
  
 // static const BASE_URL =  "http://192.168.1.106/hub/api";
 // static const BASE_URL =  "http://josemusicapps.000webhostapp.com/hub/api";
  // static const BASE_URL =  "http://kasmudtech.000webhostapp.com/hub/api";
  static const BASE_URL =  "https://www.sportstalenthub.com/hub/api";
  static const GET_PLAYERS = BASE_URL+"/getPlayers.php?category=";
  static const GET_SPORTS = BASE_URL+"/getSportsCategories.php";
  static const GET_PLAYERS_ATTACHMENTS = BASE_URL+"/getAttachments.php?";
  static const GET_PAGING_PLAYERS = BASE_URL+"/pagingPlayers.php?category=";
  static const SEARCH_PLAYERS = BASE_URL+"/searchPlayers.php?query=";
  static const MY_FAVOURITE_PLAYERS = BASE_URL+"/fetchFavouritePlayers.php?";
  static const GET_POSTS = BASE_URL+"/fetchPosts.php?";

  static const PROFILE_PHOTO_LINK = "https://www.sportstalenthub.com/media/cache/my_thumb_330x242/images/players/";
  static const ACTION_PHOTOS_LINKS = "https://www.sportstalenthub.com/media/cache/my_thumb_690x450/images/action_photos/";
  static const POST_IMAGE_LINKS = "https://www.sportstalenthub.com/media/cache/my_thumb_690x450/images/posts/";

}