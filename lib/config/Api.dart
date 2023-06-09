import 'dart:io';
import 'Urls.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
class Api {
  get context => null;

  getApi(apiname, params, [type = true]) async {
    final box = GetStorage();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse(baseurl + apiname);
        print("url=>" + url.toString());
        print("token=>" + box.read("token").toString());
        print("request=>" + jsonEncode(params).toString());

        try {
          var userHeader = {
            "Content-type": "application/json",
            "Authorization":
                box.read("token") == null ? "" : "Bearer" + box.read("token"),
            // "Accept-Language": box.read("lang") == 1 ? "en-Fr" : "en-Us"
          };
          var response = await http.post(url,
              body: jsonEncode(params), headers: userHeader);

          if (response.statusCode == 401) {
            // box.erase();
            // nextScreen(context, Login());
          } else {
            return jsonDecode(response.body);
          }
        } catch (e) {
          // Get.snackbar('Error'.tr, 'Something Went Wrong Try Again');
          log("catch execute on Api -- Error" + e.toString());
        }
      }
    } on SocketException catch (_) {}
  }
}
