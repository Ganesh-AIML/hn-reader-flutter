class ApiConstants {
  static const String baseUrl = 'https://hacker-news.firebaseio.com/v0';
  static const String topStories = '/topstories.json';
  static String item(int id) => '/item/$id.json';
}