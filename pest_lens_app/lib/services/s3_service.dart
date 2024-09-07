import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:pest_lens_app/utils/config.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

class S3Service {
  static const String region = Config.s3Region;
  static const String bucket = Config.s3Bucket;

  final AWSSigV4Signer _signer;
  final AWSCredentialScope _scope;

  S3Service({AWSCredentialsProvider? credentialsProvider})
      : _signer = AWSSigV4Signer(
          credentialsProvider:
              credentialsProvider ?? const AWSCredentialsProvider.environment(),
        ),
        _scope = AWSCredentialScope(
          region: region,
          service: AWSService.s3,
        );

  Future<Uint8List> getImageData(String objectKey) async {
    const String host = '$bucket.s3.$region.amazonaws.com';
    final String endpoint = 'https://$host/outputs/$objectKey';

    final request = AWSHttpRequest(
      method: AWSHttpMethod.get,
      uri: Uri.parse(endpoint),
      headers: const {
        AWSHeaders.host: host,
      },
    );

    try {
      final signedRequest = await _signer.sign(
        request,
        credentialScope: _scope,
      );

      final response = await http.get(
        signedRequest.uri,
        headers: signedRequest.headers,
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching image from S3: $e');
    }
  }

  Future<Uint8List> getUserProfileImageData(String objectKey) async {
    const String host = '$bucket.s3.$region.amazonaws.com';
    final String endpoint = 'https://$host/$objectKey';

    final request = AWSHttpRequest(
      method: AWSHttpMethod.get,
      uri: Uri.parse(endpoint),
      headers: const {
        AWSHeaders.host: host,
      },
    );

    try {
      final signedRequest = await _signer.sign(
        request,
        credentialScope: _scope,
      );

      final response = await http.get(
        signedRequest.uri,
        headers: signedRequest.headers,
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching image from S3: $e');
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    final String originalFileName = path.basename(imageFile.path);
    final String uniqueFileName = _generateUniqueFileName(originalFileName);
    final String objectKey = 'profile_images/$uniqueFileName';
    const String host = '$bucket.s3.$region.amazonaws.com';
    final String endpoint = 'https://$host/$objectKey';

    final fileBytes = await imageFile.readAsBytes();
    final fileLength = fileBytes.length;
    final mimeType =
        lookupMimeType(imageFile.path) ?? 'application/octet-stream';

    final request = AWSHttpRequest(
      method: AWSHttpMethod.put,
      uri: Uri.parse(endpoint),
      headers: {
        AWSHeaders.host: host,
        'Content-Type': mimeType,
        'Content-Length': fileLength.toString(),
      },
      body: fileBytes, // This should be List<int> or Uint8List
    );

    try {
      final signedRequest = await _signer.sign(
        request,
        credentialScope: _scope,
      );

      // Check and ensure the body is in the correct format
      final requestBody = signedRequest.body;
      // Convert the Stream to a List<int>
      final byteList = await requestBody.toList();
      final combinedBytes = byteList.expand((bytes) => bytes).toList();
      final response = await http.put(
        signedRequest.uri,
        headers: signedRequest.headers,
        body: combinedBytes,
      );

      if (response.statusCode == 200) {
        return objectKey;
      } else {
        throw Exception(
            'Failed to upload image: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error uploading image to S3: $e');
    }
  }

  String _generateUniqueFileName(String originalFileName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    final extension = path.extension(originalFileName);
    final baseName = path.basenameWithoutExtension(originalFileName);
    return '${baseName}_${timestamp}_$random$extension';
  }
}
