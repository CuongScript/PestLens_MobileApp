import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:pest_lens_app/utils/config.dart';

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
}
