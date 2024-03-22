import 'package:http/http.dart' as http;

Future<void> fetchFoodInfo() async {
  final String apiKey = '9443393ff172a59d6172b6c5689b7beb';
  final String foodName = 'banana'; // Example food name

  final response = await http.get(
    Uri.parse('https://api.nutritionix.com/v1_1/search/$foodName'),
    headers: {
      'x-app-id': apiKey,
      'x-app-key': apiKey,
    },
  );

  if (response.statusCode == 200) {
    // Xử lý dữ liệu nhận được từ phản hồi API
    print(response.body);
  } else {
    // Xử lý lỗi nếu có
    print('Failed to load food info: ${response.statusCode}');
  }
}
