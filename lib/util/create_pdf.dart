import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class PdfUtils {
  static Future<void> createPdf(BuildContext context, Note note) async {
    final document = PdfDocument();
    try {
      final finalPath = await filePath(context);

      final headerTemplate =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 700, 70));
      headerTemplate.graphics.drawString(
          note.title,
          PdfStandardFont(PdfFontFamily.helvetica, 16,
              multiStyle: [PdfFontStyle.italic, PdfFontStyle.underline]),
          brush: PdfBrushes.black,
          pen: PdfPen(PdfColor(0, 0, 0)),
          bounds: const Rect.fromLTWH(0, 16, 200, 20));

      document.template.top = headerTemplate;
      final page = document.pages.add();
      PdfTextElement(
        text: note.content,
        font: PdfStandardFont(PdfFontFamily.helvetica, 14),
        brush: PdfSolidBrush(
          PdfColor(0, 0, 0),
        ),
      ).draw(
          page: page,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
      final file = File(finalPath);
      await file.writeAsBytes(document.save());
    } on Exception catch (_) {
      Utilities.getSnackBar(context, Language.of(context).error);
    } finally {
      document.dispose();
    }
  }

  static Future<String> filePath(BuildContext context) async {
    final str = DateFormat('yyyyMMdd_HHmmss').format(
      DateTime.now(),
    );
    final fileName = 'NotePdf_$str.pdf';
    const folderName = '/${Utilities.appName}/';
    final path = Provider.of<LockChecker>(context, listen: false).exportPath;
    final finalPath = path + folderName + fileName;
    try {
      await File(finalPath).create(recursive: true);
    } on Exception catch (_) {
      return '';
    }
    return finalPath;
  }
}
