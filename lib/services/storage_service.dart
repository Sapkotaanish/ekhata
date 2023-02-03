import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
    final _secureStorage = const FlutterSecureStorage();

    Future<void> write(String key, String value) async{
        await _secureStorage.write(
            key: key,
            value: value,
            aOptions: _getAndroidOptions(),
        );
    }

    Future<String?> read(String key) async{
        var readStorage = await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
        return readStorage;
    } 

    Future<void> delete(String key) async{
        await _secureStorage.delete(key: key, aOptions: _getAndroidOptions());
    }

    Future<bool> contains(String key) async{
        var containsKey = await _secureStorage.containsKey(key: key);
        return containsKey;
    }

    AndroidOptions _getAndroidOptions() => const AndroidOptions(
        // encryptedSharedPreference: true,
    );
}