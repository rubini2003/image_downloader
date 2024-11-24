// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_downloader/image_downloader.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: const ImageDownloaderScreen(),
//     );
//   }
// }
//
// class ImageDownloaderScreen extends StatefulWidget {
//   const ImageDownloaderScreen({super.key});
//
//   @override
//   State<ImageDownloaderScreen> createState() => _ImageDownloaderScreenState();
// }
//
// class _ImageDownloaderScreenState extends State<ImageDownloaderScreen> {
//   bool isDownloading = false;
//   double downloadProgress = 0.0;
//   String imageUrl =
//       "https://via.placeholder.com/300"; // Replace with your image URL
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Image Downloader')),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.all(10),
//               width: double.infinity,
//               height: 300,
//               decoration: BoxDecoration(
//                 image: imageUrl.isNotEmpty
//                     ? DecorationImage(
//                         fit: BoxFit.cover,
//                         image: NetworkImage(imageUrl),
//                       )
//                     : null,
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: imageUrl.isEmpty
//                   ? const Center(child: Text("No Image URL Provided"))
//                   : null,
//             ),
//             isDownloading
//                 ? Column(
//                     children: [
//                       Text(
//                           "Downloading: ${downloadProgress.toStringAsFixed(0)}%"),
//                       GestureDetector(
//                         onTap: () {
//                           // Cancel functionality not available; toggle UI.
//                           setState(() {
//                             isDownloading = false;
//                           });
//                         },
//                         child: Container(
//                           alignment: Alignment.center,
//                           width: 200,
//                           margin: const EdgeInsets.only(top: 10),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 5),
//                           height: 50,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.red,
//                           ),
//                           child: const Text(
//                             "Cancel Download",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 : GestureDetector(
//                     onTap: () {
//                       downloadImage(imageUrl);
//                     },
//                     child: Container(
//                       alignment: Alignment.center,
//                       width: 200,
//                       margin: const EdgeInsets.only(top: 10),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       height: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.green,
//                       ),
//                       child: const Text(
//                         "Download Image",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> downloadImage(String imageUrl) async {
//     try {
//       setState(() {
//         isDownloading = true;
//         downloadProgress = 0.0;
//       });
//
//       var imageId = await ImageDownloader.downloadImage(imageUrl);
//       if (imageId == null) {
//         setState(() {
//           isDownloading = false;
//         });
//         return;
//       }
//
//       // Get image path
//       var imagePath = await ImageDownloader.findPath(imageId);
//
//       setState(() {
//         isDownloading = false;
//       });
//
//       // Show a SnackBar after download
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("Image downloaded successfully!"),
//           duration: const Duration(seconds: 5),
//           action: SnackBarAction(
//             label: "Open",
//             onPressed: () async {
//               if (imagePath != null) {
//                 await ImageDownloader.open(imagePath);
//               }
//             },
//           ),
//         ),
//       );
//     } on PlatformException catch (error) {
//       setState(() {
//         isDownloading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error: ${error.message}"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart'; // For opening files

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dio Image Downloader',
      home: const ImageDownloaderScreen(),
    );
  }
}

class ImageDownloaderScreen extends StatefulWidget {
  const ImageDownloaderScreen({super.key});

  @override
  State<ImageDownloaderScreen> createState() => _ImageDownloaderScreenState();
}

class _ImageDownloaderScreenState extends State<ImageDownloaderScreen> {
  bool isDownloading = false;
  double progress = 0.0;
  String imageUrl =
      "https://evms.greendrivemobility.com/public/EV/images/photos/0029a6fd-715c-449b-8000-c1c84153d065.png";
  String? downloadedFilePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dio Image Downloader"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                border: Border.all(color: Colors.grey),
              ),
              child: imageUrl.isEmpty
                  ? const Center(child: Text("No Image URL Provided"))
                  : null,
            ),
            const SizedBox(height: 20),
            isDownloading
                ? Column(
                    children: [
                      Text("Downloading: ${progress.toStringAsFixed(0)}%"),
                      const SizedBox(height: 10),
                      CircularProgressIndicator(value: progress / 100),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () {
                      downloadImage(imageUrl);
                    },
                    child: const Text("Download Image"),
                  ),
            const SizedBox(height: 10),
            downloadedFilePath != null
                ? ElevatedButton(
                    onPressed: () {
                      openDownloadedFile();
                    },
                    child: const Text("Open Downloaded Image"),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Future<void> downloadImage(String url) async {
    try {
      if (await _requestStoragePermission()) {
        setState(() {
          isDownloading = true;
          progress = 0.0;
        });

        // Let the user choose a save path
        String? selectedPath = await FilePicker.platform.getDirectoryPath();

        if (selectedPath == null) {
          setState(() {
            isDownloading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No directory selected")),
          );
          return;
        }

        String savePath = "$selectedPath/downloaded_image.jpg";

        // Download the image
        Dio dio = Dio();
        await dio.download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                progress = (received / total) * 100;
              });
            }
          },
        );

        setState(() {
          isDownloading = false;
          downloadedFilePath = savePath;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Download completed"),
            action: SnackBarAction(
              label: "Open",
              onPressed: () {
                openDownloadedFile();
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied.")),
        );
      }
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> openDownloadedFile() async {
    if (downloadedFilePath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image saved at: $downloadedFilePath")),
      );
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        openAppSettings();
        return false;
      }
    }
    return true;
  }
}
