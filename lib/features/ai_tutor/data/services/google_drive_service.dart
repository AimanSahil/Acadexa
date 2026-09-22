import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleDriveFile {
  const GoogleDriveFile({
    required this.id,
    required this.name,
    required this.mimeType,
    this.size,
    this.modifiedTime,
  });

  final String id;
  final String name;
  final String mimeType;
  final int? size;
  final DateTime? modifiedTime;

  bool get isFolder =>
      mimeType == 'application/vnd.google-apps.folder';

  bool get isGoogleDocument =>
      mimeType.startsWith('application/vnd.google-apps.');

  factory GoogleDriveFile.fromJson(
    Map<String, dynamic> json,
  ) {
    return GoogleDriveFile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed file',
      mimeType:
          json['mimeType'] as String? ?? 'application/octet-stream',
      size: int.tryParse(
        json['size']?.toString() ?? '',
      ),
      modifiedTime: json['modifiedTime'] != null
          ? DateTime.tryParse(
              json['modifiedTime'].toString(),
            )
          : null,
    );
  }
}

class GoogleDriveService {
  GoogleDriveService({
    FirebaseAuth? auth,
    Dio? dio,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://www.googleapis.com',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 30),
              ),
            );

  final FirebaseAuth _auth;
  final Dio _dio;

  static const String driveReadonlyScope =
      'https://www.googleapis.com/auth/drive.readonly';

  /// Requests Google Drive read access.
  ///
  /// This is called only when the user taps "Add from Drive".
  Future<String> authorizeDrive() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw const GoogleDriveException(
        'Please sign in with Google before accessing Google Drive.',
      );
    }

    final provider = GoogleAuthProvider();

    provider.addScope(driveReadonlyScope);

    try {
      final UserCredential credential =
          await user.reauthenticateWithPopup(provider);

      final OAuthCredential? oauthCredential =
          credential.credential as OAuthCredential?;

      final String? accessToken =
          oauthCredential?.accessToken;

      if (accessToken == null || accessToken.isEmpty) {
        throw const GoogleDriveException(
          'Google did not return a Drive access token.',
        );
      }

      return accessToken;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user') {
        throw const GoogleDriveException(
          'Google Drive authorization was cancelled.',
        );
      }

      if (e.code == 'popup-blocked') {
        throw const GoogleDriveException(
          'Chrome blocked the Google authorization popup. '
          'Please allow popups for Acadexa.',
        );
      }

      throw GoogleDriveException(
        'Google Drive authorization failed: ${e.message ?? e.code}',
      );
    } catch (e) {
      if (e is GoogleDriveException) {
        rethrow;
      }

      throw GoogleDriveException(
        'Google Drive authorization failed: $e',
      );
    }
  }

  /// Lists files from the user's Google Drive.
  Future<List<GoogleDriveFile>> listFiles({
    required String accessToken,
    String? search,
  }) async {
    try {
      String query =
          "trashed = false and mimeType != "
          "'application/vnd.google-apps.folder'";

      if (search != null && search.trim().isNotEmpty) {
        final escaped =
            search.trim().replaceAll("'", "\\'");
        query +=
            " and name contains '$escaped'";
      }

      final response = await _dio.get<Map<String, dynamic>>(
        '/drive/v3/files',
        queryParameters: {
          'pageSize': 100,
          'orderBy': 'modifiedTime desc',
          'q': query,
          'fields':
              'files(id,name,mimeType,size,modifiedTime)',
          'supportsAllDrives': true,
          'includeItemsFromAllDrives': true,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data;

      if (data == null) {
        return [];
      }

      final files = data['files'];

      if (files is! List) {
        return [];
      }

      return files
          .whereType<Map<String, dynamic>>()
          .map(GoogleDriveFile.fromJson)
          .where((file) => !file.isFolder)
          .toList();
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if (statusCode == 401) {
        throw const GoogleDriveException(
          'Google Drive authorization expired. '
          'Please authorize Drive again.',
        );
      }

      if (statusCode == 403) {
        throw const GoogleDriveException(
          'Google Drive access was denied. '
          'Make sure the Drive API is enabled for your Google project.',
        );
      }

      throw GoogleDriveException(
        'Could not load Google Drive files: '
        '${e.message ?? 'Unknown error'}',
      );
    } catch (e) {
      if (e is GoogleDriveException) {
        rethrow;
      }

      throw GoogleDriveException(
        'Could not load Google Drive files: $e',
      );
    }
  }

  /// Downloads a regular Drive file into memory.
  ///
  /// Google Docs/Sheets/Slides require export instead of alt=media,
  /// so those will be handled separately in the next step.
  Future<List<int>> downloadFile({
    required String accessToken,
    required String fileId,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        '/drive/v3/files/$fileId',
        queryParameters: {
          'alt': 'media',
        },
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      return response.data ?? <int>[];
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if (statusCode == 401) {
        throw const GoogleDriveException(
          'Google Drive authorization expired.',
        );
      }

      if (statusCode == 403) {
        throw const GoogleDriveException(
          'This Drive file cannot be downloaded.',
        );
      }

      if (statusCode == 404) {
        throw const GoogleDriveException(
          'The Drive file could not be found.',
        );
      }

      throw GoogleDriveException(
        'Could not download the Drive file: '
        '${e.message ?? 'Unknown error'}',
      );
    }
  }
}

class GoogleDriveException implements Exception {
  const GoogleDriveException(this.message);

  final String message;

  @override
  String toString() => message;
}