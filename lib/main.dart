import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

void main() {
  runApp(MaterialApp(
    home: DocToPdfConverter(),
    debugShowCheckedModeBanner: false,
  ));
}

class DocToPdfConverter extends StatefulWidget {
  @override
  _DocToPdfConverterState createState() => _DocToPdfConverterState();
}

class _DocToPdfConverterState extends State<DocToPdfConverter> {
  String? filePath; // To store the path of the selected file
  String? pdfPath; // To store the path of the generated PDF

  // Function to handle file selection
  Future<void> selectDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx', 'txt', 'pdf'], // Add allowed extensions
      );

      if (result != null) {
        setState(() {
          filePath = result.files.single.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File selected: ${result.files.single.name}'),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File selection canceled'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting file: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Function to convert selected document to PDF
  Future<void> convertToPdf() async {
    if (filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a document first!'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      final content = await File(filePath!).readAsString();
      final pdf = pw.Document();
      pdf.addPage(pw.Page(build: (pw.Context context) => pw.Text(content)));

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/output.pdf');
      await file.writeAsBytes(await pdf.save());

      setState(() {
        pdfPath = file.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved at ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error converting to PDF: $e')),
      );
    }
  }

  // Function to download the converted PDF
  Future<void> downloadPdf() async {
    if (pdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No PDF available to download! Convert a file first.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      OpenFile.open(pdfPath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doc to PDF Converter'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Convert Your Documents to PDF',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.deepPurple, width: 2),
              ),
              child: Center(
                child: Icon(
                  Icons.file_present,
                  size: 100,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: selectDocument,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Document'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: convertToPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Convert to PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: downloadPdf,
              icon: const Icon(Icons.download),
              label: const Text('Download PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            if (filePath != null)
              Text(
                'Selected File: ${filePath!.split('/').last}',
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
