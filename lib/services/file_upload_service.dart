import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:silentsignal/utils/logger.dart';

class FileUploadService {
  final String baseUrl;
  
  FileUploadService({String? baseUrl}) 
    : baseUrl = baseUrl ?? dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011';

  /// Get presigned URL from backend (matching your web app's getPresignedLink)
  Future<String?> getPresignedLinkFromBackend() async {
    try {
      final url = Uri.parse('$baseUrl/presigned-upload-link');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'];
      } else {
        logger.error('Failed to get presigned URL: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.error('Error getting presigned URL from backend', e);
      return null;
    }
  }

  /// Generate presigned URL directly in the mobile app (no backend call needed)
  Future<String?> generatePresignedLink() async {
    try {
      // First try to get from backend
      final backendUrl = await getPresignedLinkFromBackend();
      if (backendUrl != null) {
        return backendUrl;
      }

      // If backend fails, generate locally
      logger.info('Generating presigned URL locally...');
      
      // AWS S3 configuration from environment variables
      final accessKey = dotenv.env['AWS_ACCESS_KEY_ID'];
      final secretKey = dotenv.env['AWS_SECRET_ACCESS_KEY'];
      final region = dotenv.env['AWS_REGION'] ?? 'us-east-1';
      final bucket = dotenv.env['S3_BUCKET'];

      if (accessKey == null || secretKey == null || bucket == null) {
        logger.warning('Missing AWS credentials in .env file');
        return null;
      }

      // Generate random file key
      final randomKey = _generateRandomString(12);
      
      // Create presigned URL
      final url = _createPresignedUrl(
        accessKey: accessKey,
        secretKey: secretKey,
        region: region,
        bucket: bucket,
        key: randomKey,
        expiresInSeconds: 300, // 5 minutes
      );

      return url;
    } catch (e) {
      logger.error('Error generating presigned URL', e);
      return null;
    }
  }

  /// Generate random string for file key
  String _generateRandomString(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))
    ));
  }

  /// Create AWS S3 presigned URL
  String _createPresignedUrl({
    required String accessKey,
    required String secretKey,
    required String region,
    required String bucket,
    required String key,
    required int expiresInSeconds,
  }) {
    final now = DateTime.now().toUtc();
    
    
    // AWS signature version 4
    final dateStamp = now.toIso8601String().split('T')[0].replaceAll('-', '');
    final timeStamp = now.toIso8601String().replaceAll(RegExp(r'[:\-]'), '').split('.')[0] + 'Z';
    
    final credentialScope = '$dateStamp/$region/s3/aws4_request';
    final credential = '$accessKey/$credentialScope';
    
    // Query parameters
    final queryParams = {
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential': credential,
      'X-Amz-Date': timeStamp,
      'X-Amz-Expires': expiresInSeconds.toString(),
      'X-Amz-SignedHeaders': 'host',
    };

    // Create canonical request
    final host = '$bucket.s3.$region.amazonaws.com';
    final canonicalUri = '/$key';
    final canonicalQueryString = queryParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    final canonicalHeaders = 'host:$host\n';
    final signedHeaders = 'host';
    final payloadHash = 'UNSIGNED-PAYLOAD';
    
    final canonicalRequest = [
      'PUT',
      canonicalUri,
      canonicalQueryString,
      canonicalHeaders,
      signedHeaders,
      payloadHash,
    ].join('\n');

    // Create string to sign
    final stringToSign = [
      'AWS4-HMAC-SHA256',
      timeStamp,
      credentialScope,
      sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');

    // Calculate signature
    final signingKey = _getSignatureKey(secretKey, dateStamp, region, 's3');
    final signature = Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).toString();

    // Build final URL
    final finalQueryParams = Map<String, String>.from(queryParams);
    finalQueryParams['X-Amz-Signature'] = signature;
    
    final finalQueryString = finalQueryParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return 'https://$host$canonicalUri?$finalQueryString';
  }

  /// Generate AWS signing key
  List<int> _getSignatureKey(String key, String dateStamp, String regionName, String serviceName) {
    final kDate = Hmac(sha256, utf8.encode('AWS4$key')).convert(utf8.encode(dateStamp)).bytes;
    final kRegion = Hmac(sha256, kDate).convert(utf8.encode(regionName)).bytes;
    final kService = Hmac(sha256, kRegion).convert(utf8.encode(serviceName)).bytes;
    final kSigning = Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;
    return kSigning;
  }

  /// Compress image file to reduce size (matching your web compressImage function)
  Future<File?> compressImage(File file, {int quality = 85}) async {
    try {
      final String targetPath = file.path.replaceAll(
        path.extension(file.path),
        '_compressed${path.extension(file.path)}',
      );

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: 1024,
        minHeight: 1024,
      );

      return compressedFile != null ? File(compressedFile.path) : file;
    } catch (e) {
      logger.error('Error compressing image', e);
      return file; // Return original if compression fails
    }
  }

  /// Upload file to S3 using presigned URL (exactly like your web handleImageUpload)
  Future<String?> uploadFileToS3(File file) async {
    try {
      // Step 1: Generate presigned URL
      final presignedUrl = await generatePresignedLink();
      if (presignedUrl == null) {
        throw Exception('Failed to generate upload URL');
      }

      // Step 2: Compress image if it's an image file
      File fileToUpload = file;
      final extension = path.extension(file.path).toLowerCase();
      if (['.jpg', '.jpeg', '.png'].contains(extension)) {
        final compressedFile = await compressImage(file);
        if (compressedFile != null) {
          fileToUpload = compressedFile;
        }
      }

      // Step 3: Read file bytes
      final fileBytes = await fileToUpload.readAsBytes();
      
      // Step 4: Upload to S3 using PUT
      final contentType = _getContentType(fileToUpload.path);
      final uploadResponse = await http.put(
        Uri.parse(presignedUrl),
        headers: {
          'Content-Type': contentType,
        },
        body: fileBytes,
      );

      if (uploadResponse.statusCode == 200) {
        // Step 5: Return the URL without query parameters
        final uploadedUrl = presignedUrl.split('?')[0];
        return uploadedUrl;
      } else {
        throw Exception('Upload failed with status: ${uploadResponse.statusCode}');
      }
    } catch (e) {
      logger.error('Error uploading file', e);
      return null;
    }
  }

  /// Upload voice recording to S3
  Future<String?> uploadVoiceRecording(String voicePath) async {
    try {
      final voiceFile = File(voicePath);
      if (!await voiceFile.exists()) {
        throw Exception('Voice file does not exist');
      }

      return await uploadFileToS3(voiceFile);
    } catch (e) {
      logger.error('Error uploading voice recording', e);
      return null;
    }
  }

  /// Upload multiple files and return their URLs
  Future<List<MediaUploadResult>> uploadMultipleFiles(List<File> files) async {
    final List<MediaUploadResult> results = [];
    
    for (final file in files) {
      try {
        final uploadedUrl = await uploadFileToS3(file);
        if (uploadedUrl != null) {
          results.add(MediaUploadResult(
            filePath: uploadedUrl,
            mediaType: _getContentType(file.path),
            isSuccess: true,
          ));
        } else {
          results.add(MediaUploadResult(
            filePath: file.path,
            mediaType: _getContentType(file.path),
            isSuccess: false,
            error: 'Upload failed',
          ));
        }
      } catch (e) {
        results.add(MediaUploadResult(
          filePath: file.path,
          mediaType: _getContentType(file.path),
          isSuccess: false,
          error: e.toString(),
        ));
      }
    }
    
    return results;
  }

  /// Upload media info to backend
  Future<bool> uploadMediaInfo(int crimeReportId, String filePath, String mediaType) async {
    try {
      final url = Uri.parse('$baseUrl/media');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'file_path': filePath,
          'media_type': mediaType,
          'crime_report_id': crimeReportId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        logger.error('Media upload failed: ${response.statusCode}');
        logger.error('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      logger.error('Error uploading media info', e);
      return false;
    }
  }

  /// Handle post-report media upload
  Future<void> handlePostReportMedia(int reportId, List<MediaUploadResult> uploadedMedia) async {
    if (uploadedMedia.isEmpty) return;

    try {
      for (final media in uploadedMedia) {
        if (media.isSuccess) {
          await uploadMediaInfo(reportId, media.filePath, media.mediaType);
        }
      }
    } catch (error) {
      logger.error('Error in handlePostReportMedia', error);
      throw Exception('Failed to upload some media files');
    }
  }

  /// Get content type based on file extension
  String _getContentType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.mp4':
        return 'video/mp4';
      case '.mov':
        return 'video/quicktime';
      case '.avi':
        return 'video/x-msvideo';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.aac':
        return 'audio/aac';
      case '.wav':
        return 'audio/wav';
      case '.mp3':
        return 'audio/mpeg';
      default:
        return 'application/octet-stream';
    }
  }
}

/// Result class for file upload operations
class MediaUploadResult {
  final String filePath;
  final String mediaType;
  final bool isSuccess;
  final String? error;

  MediaUploadResult({
    required this.filePath,
    required this.mediaType,
    required this.isSuccess,
    this.error,
  });

  /// Convert to the format expected by your backend
  Map<String, String> toMediaMap() {
    return {
      'file_path': filePath,
      'media_type': mediaType,
    };
  }
}