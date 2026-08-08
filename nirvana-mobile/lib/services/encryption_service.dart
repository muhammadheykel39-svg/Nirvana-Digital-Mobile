import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../config/app_constants.dart';

/// Security service for encrypting sensitive data
class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  late final Key _key;
  late final IV _iv;
  late final Encrypter _encrypter;

  /// Initialize encryption with secure key
  void init() {
    // In production, this key should be stored securely using platform-specific secure storage
    _key = Key.fromUtf8(AppConstants.encryptionKey.padRight(32).substring(0, 32));
    _iv = IV.fromUtf8(AppConstants.encryptionIv.padRight(16).substring(0, 16));
    _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
  }

  /// Encrypt plain text
  String encrypt(String plainText) {
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  /// Decrypt encrypted text
  String decrypt(String encryptedText) {
    try {
      final decrypted = _encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: _iv);
      return decrypted;
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  /// Encrypt JSON object
  String encryptJson(Map<String, dynamic> jsonData) {
    final jsonString = jsonEncode(jsonData);
    return encrypt(jsonString);
  }

  /// Decrypt JSON object
  Map<String, dynamic> decryptJson(String encryptedJson) {
    final decryptedString = decrypt(encryptedJson);
    return jsonDecode(decryptedString) as Map<String, dynamic>;
  }
}

/// Secure storage wrapper with encryption
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  final EncryptionService _encryption = EncryptionService();

  /// Initialize secure storage
  Future<void> init() async {
    _encryption.init();
  }

  /// Write encrypted value
  Future<void> write({required String key, required String value}) async {
    final encryptedValue = _encryption.encrypt(value);
    await _storage.write(key: key, value: encryptedValue);
  }

  /// Read and decrypt value
  Future<String?> read({required String key}) async {
    final encryptedValue = await _storage.read(key: key);
    if (encryptedValue == null) return null;
    return _encryption.decrypt(encryptedValue);
  }

  /// Delete value
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Clear all storage
  Future<void> clear() async {
    await _storage.deleteAll();
  }

  /// Check if key exists
  Future<bool> containsKey({required String key}) async {
    final value = await _storage.read(key: key);
    return value != null;
  }
}
