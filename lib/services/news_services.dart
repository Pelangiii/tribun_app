import 'package:tribun_app/models/news_response.dart';
import 'package:tribun_app/utils/constants.dart';

class NewsServices {
  static const String _baseUrl = Constants.baseUrl;
  static final String _apiKey = Constants.apiKey;
// fungsi yg bertujuan untuk membuat request GET ke server
  Future<NewsResponse> getTopHeadlines({
    String country = Constants.defaultCountry,
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'apiKey': _apiKey,
        'country': country,
        'page': page.toString(),
        'pageSize': pageSize.toString()
      };
      // statement yang dijalan kan ketika kategori tidak kosong
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      // uri = untuk mengidentifikasikan sebuah url
      // berfungsi untuk parsing data dari json ke UI
      // simpelnya - kita daftarin baseurl + endpoint yg akan digunakan 
      // parsing = melempar dan mengambil
      //Kode itu membuat URL lengkap untuk request API, dengan base URL, endpoint, dan parameter pencarian (query), lalu menyimpannya ke dalam variabel uri.
      final uri = Uri.parse('$_baseUrl${Constants.topHeadlines}').replace(queryParameters: queryParams);
      //e = error
      
    } catch (e) {
      
    }
  }

  
}