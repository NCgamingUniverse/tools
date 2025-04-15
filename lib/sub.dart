import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' as syncfusion;
import 'package:syncfusion_flutter_pdf/pdf.dart'
    as pdf; // Added alias for Syncfusion
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:typed_data';

class NewScreen extends StatefulWidget {
  final String title;

  const NewScreen({Key? key, required this.title}) : super(key: key);

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  List<Uint8List> selectedFiles = [];
  List<String> fileNames = [];
  int currentIndex = 0;
  bool isLoading = false;
  final syncfusion.PdfViewerController _pdfViewerController =
      syncfusion.PdfViewerController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFF8EE4AF),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: height * 0.03),
              Center(
                child: Text(
                  "${widget.title} files",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24), // Reduced font size
                ),
              ),
              SizedBox(height: height * 0.03),

              // PDF Viewer Section
              if (selectedFiles.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedFiles.length,
                    itemBuilder: (context, index) {
                      // Extract file name (you might want to store names separately when picking files)
                      //String fileName =
                      //    'Document ${index + 1}.pdf'; // Default name

                      // If you have the original file names, use them instead:
                      String fileName = fileNames[index];

                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.picture_as_pdf,
                              color: Colors.red, size: 40),
                          title: Text(fileName),
                          subtitle: Text(
                              '${(selectedFiles[index].lengthInBytes / 1024).toStringAsFixed(2)} KB'),
                          trailing: IconButton(
                            icon: Icon(Icons.visibility),
                            onPressed: () {
                              // Show PDF preview when eye icon is clicked
                              _showPdfPreview(context, selectedFiles[index]);
                            },
                          ),
                          onTap: () {
                            setState(() => currentIndex = index);
                          },
                        ),
                      );
                    },
                  ),
                )
              else
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: pickPdfForWeb,
                        child: Container(
                          height: height * 0.1,
                          width: width * 0.6,
                          decoration: BoxDecoration(
                            color: Color(0xFF8EE4AF),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Select PDF File",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF2C2C2C),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("or Drop PDF File"),
                      SizedBox(height: 20),
                      IconButton(
                        icon: Icon(Icons.add_to_drive,
                            size: 50, color: Colors.blue),
                        onPressed: pickPdfForWeb,
                      ),
                    ],
                  ),
                ),

              // Action Button
              if (selectedFiles.isNotEmpty)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedFiles.isEmpty) return;
                      setState(() => isLoading = true);
                      await handlePDFOperation(context, widget.title);
                      setState(() => isLoading = false);
                    },
                    child: Container(
                      height: height * 0.08,
                      width: width * 0.6,
                      decoration: BoxDecoration(
                        color: Color(0xFF8EE4AF),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF2C2C2C),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  void _showPdfPreview(BuildContext context, Uint8List pdfBytes) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('PDF Preview'),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: syncfusion.SfPdfViewer.memory(
            pdfBytes,
            controller: syncfusion.PdfViewerController(),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> pickPdfForWeb() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFiles = result.files
              .where((file) => file.bytes != null)
              .map((file) => file.bytes!)
              .toList();
          fileNames = result.files
              .where((file) => file.bytes != null)
              .map((file) => file.name)
              .toList();
          currentIndex = 0;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick file: $e')),
      );
    }
  }

  // ... [Keep all your existing PDF operation methods] ...

  Future<void> showResultDialog(BuildContext context, Uint8List resultBytes,
      {String initialName = 'result'}) async {
    final TextEditingController _fileNameController =
        TextEditingController(text: initialName);
    final _formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Save Your File'),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // PDF Preview (smaller size)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: syncfusion.SfPdfViewer.memory(
                          resultBytes,
                          controller: syncfusion.PdfViewerController(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Filename input
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _fileNameController,
                        decoration: InputDecoration(
                          labelText: 'File name',
                          border: OutlineInputBorder(),
                          suffixText: '.pdf',
                          suffixStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a file name';
                          }
                          if (value.contains(RegExp(r'[\\/:*?"<>|]'))) {
                            return 'Invalid file name characters';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text('Download'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String fileName = _fileNameController.text;
                      if (!fileName.toLowerCase().endsWith('.pdf')) {
                        fileName += '.pdf';
                      }
                      downloadPdf(resultBytes, fileName);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> handlePDFOperation(BuildContext context, String title) async {
    try {
      Uint8List? result;

      switch (title) {
        case "Merge PDF":
          result = await mergePdfFiles();
          break;
        case "Split PDF":
          Text("Split PDF");
          //result = await splitPdfFile();
          break;
        case "Remove pages":
          result = await removePages();
          break;
        case "Extract pages":
          result = await extractPages();
          break;
        case "Organize PDF":
          result = await organizePdf();
          break;
        case "Compress PDF":
          result = await compressPdf();
          break;
        case "Repair PDF":
          result = await repairPdf();
          break;
        case "Rotate PDF":
          result = await rotatePdf();
          break;
        case "Add page numbers":
          result = await addPageNumbers();
          break;
        case "Add watermark":
          result = await addWatermark();
          break;
        case "Unlock PDF":
          result = await unlockPdf();
          break;
        case "Protect PDF":
          Text("Protect PDF");
          //result = await protectPdf();
          break;
        case "Sign PDF":
          result = await signPdf();
          break;
        case "Compare PDF":
          await comparePdfFiles();
          return; // Special case - doesn't return a PDF
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Feature coming soon!')),
          );
          return;
      }

      if (result != null) {
        await showResultDialog(context, result);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<Uint8List?> mergePdfFiles() async {
    if (selectedFiles.length < 2) {
      throw Exception('Please select at least 2 PDF files to merge');
    }

    final pdf.PdfDocument mergedDocument = pdf.PdfDocument();

    for (var fileBytes in selectedFiles) {
      final pdf.PdfDocument document = pdf.PdfDocument(inputBytes: fileBytes);
      for (int i = 0; i < document.pages.count; i++) {
        final template = document.pages[i].createTemplate();
        mergedDocument.pages
            .add()
            .graphics
            .drawPdfTemplate(template, Offset(0, 0));
      }
      document.dispose();
    }

    final List<int> bytes = mergedDocument.saveSync();
    mergedDocument.dispose();
    return Uint8List.fromList(bytes);
  }

  Future<List<Uint8List>> splitPdfFile(int splitPageNumber) async {
    if (selectedFiles.isEmpty) throw Exception('No PDF selected');

    final pdf.PdfDocument document =
        pdf.PdfDocument(inputBytes: selectedFiles[0]);
    if (splitPageNumber >= document.pages.count) {
      document.dispose();
      throw Exception('Split page number exceeds document page count');
    }

    // Create two documents for the split parts
    final pdf.PdfDocument firstPart = pdf.PdfDocument();
    final pdf.PdfDocument secondPart = pdf.PdfDocument();

    // Add pages before split point to first document
    for (int i = 0; i < splitPageNumber; i++) {
      final template = document.pages[i].createTemplate();
      firstPart.pages.add().graphics.drawPdfTemplate(template, Offset(0, 0));
    }

    // Add remaining pages to second document
    for (int i = splitPageNumber; i < document.pages.count; i++) {
      final template = document.pages[i].createTemplate();
      secondPart.pages.add().graphics.drawPdfTemplate(template, Offset(0, 0));
    }

    // Save both documents
    final List<int> firstBytes = firstPart.saveSync();
    final List<int> secondBytes = secondPart.saveSync();

    // Clean up
    firstPart.dispose();
    secondPart.dispose();
    document.dispose();

    return [Uint8List.fromList(firstBytes), Uint8List.fromList(secondBytes)];
  }

  Future<Uint8List?> removePages() async {
    if (selectedFiles.isEmpty) throw Exception('No PDF selected');

    // For simplicity, remove the first page
    final pdf.PdfDocument document =
        pdf.PdfDocument(inputBytes: selectedFiles[0]);
    if (document.pages.count <= 1)
      throw Exception('Cannot remove the only page');

    document.pages.removeAt(0);

    final List<int> bytes = document.saveSync();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

  Future<Uint8List?> extractPages({
    int startPage = 0,
    int? endPage,
  }) async {
    if (selectedFiles.isEmpty) throw Exception('No PDF selected');

    final pdf.PdfDocument document =
        pdf.PdfDocument(inputBytes: selectedFiles[0]);
    final int totalPages = document.pages.count;

    // Validate page range
    if (startPage < 0 || startPage >= totalPages) {
      document.dispose();
      throw Exception('Start page is out of range');
    }

    endPage ??= startPage; // Default to single page if endPage not specified
    if (endPage < startPage || endPage >= totalPages) {
      document.dispose();
      throw Exception('End page is out of range');
    }

    final pdf.PdfDocument extractedDocument = pdf.PdfDocument();

    // Extract the specified page range
    for (int i = startPage; i <= endPage; i++) {
      final pdf.PdfTemplate template = document.pages[i].createTemplate();
      final pdf.PdfPage newPage = extractedDocument.pages.add();
      newPage.graphics.drawPdfTemplate(
        template,
        const Offset(0, 0),
      );
    }

    final List<int> bytes = extractedDocument.saveSync();
    extractedDocument.dispose();
    document.dispose();

    return Uint8List.fromList(bytes);
  }

  Future<Uint8List?> organizePdf({
    List<int>? customOrder,
    bool reverse = false,
    bool evenOddSeparate = false,
  }) async {
    if (selectedFiles.isEmpty) throw Exception('No PDF selected');

    final pdf.PdfDocument document =
        pdf.PdfDocument(inputBytes: selectedFiles[0]);
    final int pageCount = document.pages.count;
    final pdf.PdfDocument organizedDocument = pdf.PdfDocument();

    // Validate custom order if provided
    if (customOrder != null) {
      if (customOrder.length != pageCount) {
        document.dispose();
        throw Exception('Custom order length must match page count');
      }
      if (customOrder.any((page) => page < 0 || page >= pageCount)) {
        document.dispose();
        throw Exception('Custom order contains invalid page numbers');
      }
    }

    // Determine the page order
    List<int> pageOrder = List.generate(pageCount, (i) => i);

    if (customOrder != null) {
      pageOrder = customOrder;
    } else if (reverse) {
      pageOrder = List.generate(pageCount, (i) => pageCount - 1 - i);
    } else if (evenOddSeparate) {
      final evens = List.generate((pageCount + 1) ~/ 2, (i) => i * 2);
      final odds = List.generate(pageCount ~/ 2, (i) => i * 2 + 1);
      pageOrder = [...evens, ...odds];
    }

    // Add pages in the determined order
    for (final pageIndex in pageOrder) {
      final template = document.pages[pageIndex].createTemplate();
      final newPage = organizedDocument.pages.add();
      newPage.graphics.drawPdfTemplate(
        template,
        const Offset(0, 0),
      );
    }

    final List<int> bytes = organizedDocument.saveSync();
    organizedDocument.dispose();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

  Future<Uint8List?> compressPdf() async {
    if (selectedFiles.isEmpty) throw Exception('No PDF selected');

    // Note: Real compression would require more sophisticated algorithms
    // This is just a placeholder implementation
    return selectedFiles[0];
  }

  Future<Uint8List?> repairPdf() async {
    if (selectedFiles.isEmpty) throw Exception('No PDF selected');

    // Note: Real repair would require detecting and fixing PDF issues
    // This is just a placeholder implementation
    return selectedFiles[0];
  }

  Future<Uint8List?> rotatePdf() async {
    if (selectedFiles.isEmpty) throw Exception('No PDF selected');

    final pdf.PdfDocument document =
        pdf.PdfDocument(inputBytes: selectedFiles[0]);
    for (int i = 0; i < document.pages.count; i++) {
      document.pages[i].rotation = pdf.PdfPageRotateAngle.rotateAngle90;
    }

    final List<int> bytes = document.saveSync();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

  Future<Uint8List?> addPageNumbers() async {
    if (selectedFiles.isEmpty) throw Exception('No PDF selected');

    final pdf.PdfDocument document =
        pdf.PdfDocument(inputBytes: selectedFiles[0]);
    for (int i = 0; i < document.pages.count; i++) {
      final page = document.pages[i];
      final graphics = page.graphics;

      final font = pdf.PdfStandardFont(pdf.PdfFontFamily.helvetica, 12);
      final format = pdf.PdfStringFormat(
        alignment: pdf.PdfTextAlignment.center,
        lineAlignment: pdf.PdfVerticalAlignment.bottom,
      );

      graphics.drawString(
        'Page ${i + 1} of ${document.pages.count}',
        font,
        brush: pdf.PdfBrushes.black,
        bounds: Rect.fromLTWH(0, page.size.height - 40, page.size.width, 30),
        format: format,
      );
    }

    final List<int> bytes = document.saveSync();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

  Future<Uint8List?> addWatermark() async {
    if (selectedFiles.isEmpty) throw Exception('No PDF selected');

    final pdf.PdfDocument document =
        pdf.PdfDocument(inputBytes: selectedFiles[0]);
    for (int i = 0; i < document.pages.count; i++) {
      final page = document.pages[i];
      final graphics = page.graphics;

      final font = pdf.PdfStandardFont(pdf.PdfFontFamily.helvetica, 72);
      final state = graphics.save();

      graphics.setTransparency(0.5);
      graphics.translateTransform(page.size.width / 2, page.size.height / 2);
      graphics.rotateTransform(-45);

      graphics.drawString(
        'DRAFT',
        font,
        brush: pdf.PdfBrushes.lightGray,
        bounds: Rect.fromLTWH(-150, -50, 300, 100),
        format: pdf.PdfStringFormat(
          alignment: pdf.PdfTextAlignment.center,
          lineAlignment: pdf.PdfVerticalAlignment.middle,
        ),
      );

      graphics.restore(state);
    }

    final List<int> bytes = document.saveSync();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

  Future<Uint8List?> unlockPdf() async {
    if (selectedFiles.isEmpty) throw Exception('No PDF selected');

    // Note: Real unlocking would require password handling
    // This is just a placeholder implementation
    return selectedFiles[0];
  }

//   Future<Uint8List?> protectPdf({
//   String userPassword = 'user',
//   String ownerPassword = 'owner',
//   pdf.PdfPermissionsFlags permissions = pdf.PdfPermissionsFlags.none,
// }) async {
//   if (selectedFiles.isEmpty) throw Exception('No PDF selected');

//   final pdf.PdfDocument document = pdf.PdfDocument(inputBytes: selectedFiles[0]);

//   // Create security settings with constructor parameters
//   final security = pdf.PdfSecurity(
//     userPassword: userPassword,
//     ownerPassword: ownerPassword,
//     permissions: permissions,
//   );

//   document.security = security;

//   final List<int> bytes = document.saveSync();
//   document.dispose();
//   return Uint8List.fromList(bytes);
// }

  Future<Uint8List?> signPdf() async {
    if (selectedFiles.isEmpty) throw Exception('No PDF selected');

    // Note: Real signing would require digital certificate handling
    // This is just a placeholder implementation that adds a signature graphic
    final pdf.PdfDocument document =
        pdf.PdfDocument(inputBytes: selectedFiles[0]);
    final page = document.pages[0];
    final graphics = page.graphics;

    graphics.drawRectangle(
      brush: pdf.PdfBrushes.white,
      pen: pdf.PdfPens.black,
      bounds: Rect.fromLTWH(
        page.size.width - 150,
        page.size.height - 100,
        120,
        50,
      ),
    );

    graphics.drawString(
      'Signature',
      pdf.PdfStandardFont(pdf.PdfFontFamily.helvetica, 12),
      brush: pdf.PdfBrushes.black,
      bounds: Rect.fromLTWH(
        page.size.width - 140,
        page.size.height - 80,
        100,
        30,
      ),
    );

    final List<int> bytes = document.saveSync();
    document.dispose();
    return Uint8List.fromList(bytes);
  }

  Future<void> comparePdfFiles() async {
    if (selectedFiles.length < 2) {
      throw Exception('Please select 2 PDF files to compare');
    }

    // Note: Real comparison would require more sophisticated analysis
    // This is just a simple placeholder implementation
    final doc1 = pdf.PdfDocument(inputBytes: selectedFiles[0]);
    final doc2 = pdf.PdfDocument(inputBytes: selectedFiles[1]);

    bool identical = true;
    String message = '';

    if (doc1.pages.count != doc2.pages.count) {
      identical = false;
      message =
          'Page count differs: ${doc1.pages.count} vs ${doc2.pages.count}';
    } else {
      message = 'PDFs have the same page count (${doc1.pages.count} pages)';
      // Could add more detailed comparison here
    }

    doc1.dispose();
    doc2.dispose();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Future<void> showResultDialog(
  //     BuildContext context, Uint8List resultBytes) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Operation Completed'),
  //         content: Container(
  //           width: double.maxFinite,
  //           height: 300,
  //           child: SfPdfViewer.memory(resultBytes),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Download'),
  //             onPressed: () {
  //               downloadPdf(resultBytes, 'result.pdf');
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text('Close'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void downloadPdf(Uint8List bytes, String fileName) {
    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = fileName;

      html.document.body?.children.add(anchor);
      anchor.click();

      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      // Handle mobile download
      // You would need to implement platform-specific code here
    }
  }
}
