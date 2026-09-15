import 'dart:io';
import '../models/question_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';

class PdfService {

  static Future<void> createResultPdf({
    required String studentName,
    required String userId,
    required String mockTestName,
    required double score,
    required int correct,
    required int wrong,
    required int skipped,

    required List<QuestionModel> questions,
    required List<int?> selectedAnswers,
  }) async {
    pdf = pw.Document();

    final logo = await loadLogo();

    final regularFont = pw.Font.ttf(
      await rootBundle.load(
        'assets/fonts/NotoSans-Regular.ttf',
      ),
    );

    final hindiFont = pw.Font.ttf(
      await rootBundle.load(
        'assets/fonts/NotoSansDevanagari-Regular.ttf',
      ),
    );

    final mathFont = pw.Font.ttf(
      await rootBundle.load(
        'assets/fonts/NotoSansMath-Regular.ttf',
      ),
    );

    final pdfId = generatePdfId();

    pdf.addPage(
      pw.MultiPage(

        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(24),

        ),


        footer: (context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Row(
              mainAxisAlignment:
              pw.MainAxisAlignment.spaceBetween,
              children: [

                pw.Text(
                  "© ARANK INDIA",
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                ),

                pw.Text(
                  "Page ${context.pageNumber} / ${context.pagesCount}",
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                ),

              ],
            ),
          );
        },

        build: (context) {
          return [

            /// Header
            pw.Center(
              child: pw.Column(
                children: [

                  pw.Text(
                    "ARANK INDIA",
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  pw.Image(
                    logo,
                    width: 90,
                    height: 90,
                  ),

                  pw.SizedBox(height: 12),

                  pw.Text(
                    "RESULT ANALYSIS REPORT",
                    style: pw.TextStyle(
                      fontSize: 18,
                      color: PdfColors.blueGrey800,
                    ),
                  ),
                ],
              ),
            ),
            pw.Center(
              child: pw.Opacity(
                opacity: 0.08,
                child: pw.Column(
                  children: [

                    pw.Text(
                      "ARANK INDIA",
                      style: pw.TextStyle(
                        fontSize: 40,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey,
                      ),
                    ),

                    pw.SizedBox(height: 10),

                    pw.Image(
                      logo,
                      width: 120,
                    ),

                  ],
                ),
              ),
            ),

            pw.SizedBox(height: 30),
            pw.Divider(
              thickness: 1,
            ),

            /// Student Details

            pw.Container(
              padding: const pw.EdgeInsets.all(15),

              decoration: pw.BoxDecoration(
                border: pw.Border.all(),
                borderRadius: pw.BorderRadius.circular(8),
              ),

              child: pw.Column(
                children: [

                  _row("Student", studentName),

                  _row("User ID", userId),

                  _row("Mock Test", mockTestName),

                  _row("Generated", currentDateTime()),

                  _row("PDF ID", pdfId),

                ],
              ),
            ),

            pw.SizedBox(height: 25),

            /// Score Summary

            pw.Container(
              padding: const pw.EdgeInsets.all(15),

              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(8),
              ),

              child: pw.Column(
                children: [

                  _row("Score", score.toString()),

                  _row("Correct", correct.toString()),

                  _row("Wrong", wrong.toString()),

                  _row("Skipped", skipped.toString()),

                ],
              ),
            ),
            pw.NewPage(),

            pw.Text(
              "QUESTION REVIEW",
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 20),

            ...List.generate(questions.length, (index) {

              final q = questions[index];

              String userAnswer;

              if (selectedAnswers[index] == null) {
                userAnswer = "Not Attempted";
              } else {
                switch (selectedAnswers[index]) {
                  case 0:
                    userAnswer = "A";
                    break;
                  case 1:
                    userAnswer = "B";
                    break;
                  case 2:
                    userAnswer = "C";
                    break;
                  case 3:
                    userAnswer = "D";
                    break;
                  default:
                    userAnswer = "Not Attempted";
                }
              }

              final bool isCorrect =
                  userAnswer == q.correctAnswer;

              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 15),
                padding: const pw.EdgeInsets.all(12),

                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColors.grey400,
                  ),
                  borderRadius: pw.BorderRadius.circular(8),
                ),

                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [

                    pw.Text(
                      "Q${index + 1}. ${q.question}",
                      style: pw.TextStyle(
                        font: hindiFont,
                        fontFallback: [mathFont],
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),



                    pw.SizedBox(height: 8),

                    pw.Text(
                      "A. ${q.optionA}",
                      style: pw.TextStyle(font: hindiFont),
                    ),

                    pw.Text(
                      "B. ${q.optionB}",
                      style: pw.TextStyle(font: hindiFont),
                    ),

                    pw.Text(
                      "C. ${q.optionC}",
                      style: pw.TextStyle(font: hindiFont),
                    ),

                    pw.Text(
                      "D. ${q.optionD}",
                      style: pw.TextStyle(font: hindiFont),
                    ),

                    pw.Divider(),

                    pw.Text(
                      "Your Answer : $userAnswer",
                      style: pw.TextStyle(font: hindiFont),
                    ),

                    pw.Text(
                      "Correct Answer : ${q.correctAnswer}",
                      style: pw.TextStyle(font: hindiFont),
                    ),

                    pw.Text(
                      isCorrect
                          ? "Status : Correct"
                          : "Status : Wrong",
                      style: pw.TextStyle(
                        font: hindiFont,
                        color: isCorrect
                            ? PdfColors.green
                            : PdfColors.red,
                      ),
                    ),

                    pw.SizedBox(height: 6),

                    pw.Text(
                      "Explanation",
                      style: pw.TextStyle(
                        font: hindiFont,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),

                    pw.Text(
                      q.explanation,
                      style: pw.TextStyle(
                        font: hindiFont,
                      ),
                    ),

                  ],
                ),



              );
            }),


            pw.SizedBox(height: 20),

            pw.Divider(),

            pw.Text(
              "DISCLAIMER",
              style: pw.TextStyle(
                font: regularFont,
                fontWeight: pw.FontWeight.bold,
                fontSize: 16,
              ),
            ),

            pw.SizedBox(height: 8),

            pw.Text(
              "This PDF is system generated. Questions, answers, explanations, translations, spellings or formatting may contain unintentional errors. Users are advised to verify important information from official sources. ARANK INDIA continuously works to improve the quality and accuracy of the content.\n यह रिपोर्ट स्वचालित (System Generated) है। प्रश्न, उत्तर, व्याख्या या अनुवाद में टाइपिंग, वर्तनी (Spelling) अथवा अन्य त्रुटियाँ संभव हैं। यदि किसी प्रकार की त्रुटि दिखाई दे, तो कृपया आधिकारिक स्रोत से सत्यापन करें। ARANK INDIA त्रुटियों की सूचना मिलने पर उन्हें सुधारने का प्रयास करेगा।",
              style: pw.TextStyle(
                font: regularFont,
                fontSize: 11,
              ),
            ),

            pw.SizedBox(height: 10),

            pw.Text(
              "© ARANK INDIA",
              style: pw.TextStyle(
                font: regularFont,
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ];
        },
      ),
    );
  }

  static pw.Widget _row(
      String title,
      String value,
      ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment:
        pw.MainAxisAlignment.spaceBetween,
        children: [

          pw.Text(
            title,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.Text(value),

        ],
      ),
    );
  }
  PdfService._();

  static pw.Document pdf = pw.Document();

  static const Uuid _uuid = Uuid();

  /// Load App Logo
  static Future<pw.MemoryImage> loadLogo() async {
    final data = await rootBundle.load(
      'assets/images/logos/logo.png',
    );

    return pw.MemoryImage(
      data.buffer.asUint8List(),
    );
  }

  /// Generate Unique PDF ID
  static String generatePdfId() {
    return "ARK-${_uuid.v4().substring(0, 8).toUpperCase()}";
  }

  /// Current Date & Time
  static String currentDateTime() {
    final now = DateTime.now();

    return "${now.day}/${now.month}/${now.year} "
        "${now.hour}:${now.minute}";
  }

  /// Save PDF
  static Future<File> savePdf(
      String fileName,
      ) async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(
      "${dir.path}/$fileName.pdf",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    return file;
  }

  /// Print PDF
  static Future<void> printPdf() async {
    await Printing.layoutPdf(
      name: "ARANK INDIA.pdf",
      onLayout: (PdfPageFormat format) async {
        return pdf.save();
      },
    );
  }
}