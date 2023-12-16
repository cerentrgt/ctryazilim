import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart'; // image_gallery_saver paketini içe aktarın

class ImagePage extends StatefulWidget {
  final String imageName;
  final String userName;

  const ImagePage({
    Key? key,
    required this.imageName,
    required this.userName,
  }) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  late Dio _dio; // HTTP isteği için Dio örneği

  @override
  void initState() {
    super.initState();
    _dio = Dio();
  }

  @override
  void dispose() {
    _dio.close(); // Widget kaldırıldığında Dio örneğini kapatın
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.userName),
            IconButton(
              onPressed: () {
                _downloadImage(widget.imageName);
              },
              icon: Icon(Icons.download_outlined),
            ),
          ],
        ),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  widget.imageName,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadImage(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        final fileName =
            widget.userName; // Kullanıcı adını dosya adı olarak kullan

        // Dosyayı galeriye kaydetmek için image_gallery_saver kullanın
        final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.data),
            name: fileName);
        if (result != null && result.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image saved to gallery!'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save image to gallery'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download image'),
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An Error ${e}!'),
        ),
      );
    }
  }
}
