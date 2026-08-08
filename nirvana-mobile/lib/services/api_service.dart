import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../config/app_constants.dart';
import 'encryption_service.dart';

/// API Service for network communication with Laravel backend
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  String? _authToken;
  final SecureStorageService _secureStorage = SecureStorageService();

  /// Initialize API service
  Future<void> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token to headers if available
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) {
        // Handle errors globally
        if (error.response?.statusCode == 401) {
          // Token expired, handle logout
        }
        return handler.next(error);
      },
    ));

    // Load stored token
    await _loadAuthToken();
  }

  /// Load auth token from secure storage
  Future<void> _loadAuthToken() async {
    _authToken = await _secureStorage.read(key: AppConstants.authTokenKey);
  }

  /// Set auth token
  Future<void> setAuthToken(String token) async {
    _authToken = token;
    await _secureStorage.write(key: AppConstants.authTokenKey, value: token);
  }

  /// Clear auth token
  Future<void> clearAuthToken() async {
    _authToken = null;
    await _secureStorage.delete(key: AppConstants.authTokenKey);
  }

  /// Check internet connectivity
  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  /// GET request
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<Response> patch(String endpoint, {dynamic data}) async {
    try {
      return await _dio.patch(endpoint, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload file with multipart
  Future<Response> upload(String endpoint, String filePath, {Map<String, dynamic>? data}) async {
    try {
      final formData = FormData.fromMap(data ?? {});
      formData.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(filePath),
      ));
      return await _dio.post(endpoint, data: formData);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Download file
  Future<void> download(String endpoint, String savePath) async {
    try {
      await _dio.download(endpoint, savePath);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Sync offline data to server
  Future<Map<String, dynamic>> syncData(List<Map<String, dynamic>> pendingItems) async {
    try {
      final response = await _dio.post(AppConstants.syncEndpoint, data: {
        'items': pendingItems,
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Export report as PDF
  Future<List<int>> exportPdf({
    required String reportType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.exportPdfEndpoint,
        data: {
          'report_type': reportType,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
        responseType: ResponseType.bytes,
      );
      return response.data as List<int>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Export report as Excel
  Future<List<int>> exportExcel({
    required String reportType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.exportExcelEndpoint,
        data: {
          'report_type': reportType,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
        responseType: ResponseType.bytes,
      );
      return response.data as List<int>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'An error occurred';
        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error: ${error.message}');
    }
  }
}
