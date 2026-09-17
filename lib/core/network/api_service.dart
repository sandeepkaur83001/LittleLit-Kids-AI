import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:little_kids_ai/core/common_imports.dart';

class ApiService {
  // Use EnvConfig for URLs
  static String get _baseUrl => EnvConfig.baseUrl;
  static String get baseUrlPhoto => EnvConfig.baseUrlPhoto;

  ApiService();

  static Map<String, String> get defaultHeaders {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty)
        'Authorization': 'Bearer ${Globals.BearerToken}',
    };
  }

  static Map<String, String> get authHeaders {
    return {
      'Accept': 'application/json',
      if (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty)
        'Authorization': 'Bearer ${Globals.BearerToken}',
    };
  }

  static Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    bool showLoading = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoading) dialog.showLoader();
    final combinedHeaders = {...defaultHeaders, ...?headers};
    try {
      CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
      CommonApiClass().normalPrintJson("API_HEADER '$combinedHeaders");
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: combinedHeaders,
      );
      _handleResponse(response, endpoint: endpoint);
      return response;
    } catch (ex) {
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      CommonApiClass().normalPrintJson("API_ERROR_DATA  $ex");
      String jsonResponse = jsonEncode(response);

      var responses = http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
      _handleResponse(responses);
      return responses;
    } finally {
      if (showLoading) dialog.hideLoader();
    }
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    bool showLoading = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoading) dialog.showLoader();
    final combinedHeaders = {...defaultHeaders, ...?headers};
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$combinedHeaders");
    CommonApiClass().normalPrintJson("API_BODY '${jsonEncode(body)}");
    try {
      final jsonBody = body ?? {};
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: combinedHeaders,
        body: jsonEncode(jsonBody),
      );
      _handleResponse(response, endpoint: endpoint);
      return response;
    } catch (ex) {
      CommonApiClass().normalPrintJson("API_ERROR_DATA  $ex");
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      String jsonResponse = jsonEncode(response);

      var responses = http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
      _handleResponse(responses);

      return responses;
    } finally {
      if (showLoading) dialog.hideLoader();
    }
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    bool showLoading = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoading) dialog.showLoader();
    final combinedHeaders = {...defaultHeaders, ...?headers};
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$combinedHeaders");
    CommonApiClass().normalPrintJson("API_BODY '${jsonEncode(body)}");
    try {
      final jsonBody = body ?? {};
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: combinedHeaders,
        body: jsonEncode(jsonBody),
      );
      _handleResponse(response, endpoint: endpoint);
      return response;
    } catch (ex) {
      CommonApiClass().normalPrintJson("API_ERROR_DATA  $ex");
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      String jsonResponse = jsonEncode(response);

      var responses = http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
      _handleResponse(responses);

      return responses;
    } finally {
      if (showLoading) dialog.hideLoader();
    }
  }

  static Future<http.Response> formPost(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    List<File>? files,
    File? singleFile,
    String fileType = 'profile_picture',
    bool showLoading = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoading) dialog.showLoader();
    final combinedHeaders = {...authHeaders, ...?headers};
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$combinedHeaders");
    CommonApiClass().normalPrintJson("API_BODY '$body");
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl$endpoint'),
      );
      request.headers.addAll(combinedHeaders);

      if (body != null) {
        body.forEach((key, value) {
          if (value != null) {
            request.fields[key] = value.toString();
          }
        });
      }

      if (singleFile != null && singleFile.existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath(fileType, singleFile.path),
        );
      }

      if (files != null && files.isNotEmpty) {
        for (int i = 0; i < files.length; i++) {
          if (files[i].existsSync()) {
            request.files.add(
              await http.MultipartFile.fromPath(fileType, files[i].path),
            );
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      _handleResponse(response, endpoint: endpoint);
      return response;
    } catch (ex) {
      CommonApiClass().normalPrintJson("API_ERROR_DATA  $ex");
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      String jsonResponse = jsonEncode(response);
      var responses = http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
      _handleResponse(responses);

      return responses;
    } finally {
      if (showLoading) dialog.hideLoader();
    }
  }

  static Future<http.Response> formPut(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? body,
    required List<File> files,
    required String fileName,
    bool showLoading = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoading) dialog.showLoader();
    final combinedHeaders = {...authHeaders, ...?headers};
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$combinedHeaders");
    CommonApiClass().normalPrintJson("API_BODY '$body");
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$_baseUrl$endpoint'),
      );
      request.headers.addAll(combinedHeaders);
      if (body != null) {
        request.fields.addAll(body);
      }
      for (int i = 0; i < files.length; i++) {
        if (files[i].existsSync()) {
          request.files.add(
            await http.MultipartFile.fromPath(fileName, files[i].path),
          );
        }
      }
      final response = await http.Response.fromStream(await request.send());

      _handleResponse(response, endpoint: endpoint);
      return response;
    } catch (ex) {
      CommonApiClass().normalPrintJson("API_ERROR_DATA  $ex");
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      String jsonResponse = jsonEncode(response);
      var responses = http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
      _handleResponse(responses);

      return responses;
    } finally {
      if (showLoading) dialog.hideLoader();
    }
  }

  static Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    bool showLoading = true,
  }) async {
    final dialog = Get.find<DialogService>();
    if (showLoading) dialog.showLoader();
    final combinedHeaders = {...defaultHeaders, ...?headers};
    CommonApiClass().normalPrintJson("API_RESPONSE_URL '$_baseUrl$endpoint");
    CommonApiClass().normalPrintJson("API_HEADER '$combinedHeaders");
    CommonApiClass().normalPrintJson("API_BODY '${jsonEncode(body)}");
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: combinedHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      _handleResponse(response, endpoint: endpoint);
      return response;
    } catch (ex) {
      CommonApiClass().normalPrintJson("API_ERROR_DATA  $ex");
      CrashedApiResponse response = CrashedApiResponse(message: ex.toString());
      String jsonResponse = jsonEncode(response);
      var responses = http.Response(
        jsonResponse,
        response.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
      );
      _handleResponse(responses);

      return responses;
    } finally {
      if (showLoading) dialog.hideLoader();
    }
  }

  static void _handleResponse(http.Response response, {String? endpoint}) async {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        CommonApiClass().normalPrintJson(
          "API_STATUS_CODE${response.statusCode}",
        );
        CommonApiClass().prettyJson(response.body);

        _checkAndHandleUnauthenticated(response, endpoint);
      } else {
        CommonApiClass().normalPrintJson(
          "API_STATUS_CODE${response.statusCode}",
        );
        CommonApiClass().normalPrintJson(
          "API_RESPONSE_JSON_STRING ${response.body}",
        );

        _checkAndHandleUnauthenticated(response, endpoint);
      }
    } catch (e) {
      CommonApiClass().normalPrintJson("API_ERROR_IN_DECODING$e");
    }
  }

  static void _checkAndHandleUnauthenticated(http.Response response, String? endpoint) {
    if (endpoint != null) {
      if (endpoint.contains(ApiEndPointConstants.login) ||
          endpoint.contains(ApiEndPointConstants.register) ||
          endpoint.contains(ApiEndPointConstants.socialLogin) ||
          endpoint.contains(ApiEndPointConstants.forgotPassword) ||
          endpoint.contains(ApiEndPointConstants.resetPassword)) {
        return;
      }
    }

    // Only auto-logout if user was previously authenticated with a token
    if (Globals.BearerToken == null || Globals.BearerToken!.isEmpty) {
      return;
    }

    try {
      if (response.statusCode == 401) {
        AuthController.handleUnauthenticated();
        return;
      }

      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final status = decoded['status'];
          final message = decoded['message']?.toString().trim().toLowerCase();
          if (status == 401 ||
              status == '401' ||
              message == 'unauthenticated.' ||
              message == 'unauthenticated' ||
              message == 'unauthorized.' ||
              message == 'unauthorized') {
            AuthController.handleUnauthenticated();
          }
        }
      }
    } catch (_) {}
  }

  static void showJsonDialog(BuildContext context, String formattedJson) {
    /// this a code is use  functional but not use in current state
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Incoming Data",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: SelectableText(
            formattedJson,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: formattedJson));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copied to clipboard")),
              );
            },
            child: const Text(
              "Copy",
              style: TextStyle(color: Color(0xffFFDE59)),
            ),
          ),

          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Done", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- Dummy API Implementation for Future Use ---

  static Future<http.Response> fetchGameCategories() async {
    return await get('/games/categories', headers: defaultHeaders);
  }

  static Future<http.Response> generateMagicArt(Map<String, dynamic> data) async {
    return await post('/magic-art/generate', headers: defaultHeaders, body: data);
  }

  static Future<http.Response> fetchPortfolio(String category) async {
    return await get('/portfolio/items?category=$category', headers: defaultHeaders);
  }
}
