import 'package:majadigi_mobile/domain/stac_build_runner/stac_cached_image/stac_cached_image.dart';
import 'package:majadigi_mobile/domain/stac_build_runner/stac_custom_date_picker/stac_custom_date_picker.dart';
import 'package:majadigi_mobile/domain/stac_build_runner/stac_custom_form_modal/stac_custom_form_modal.dart';
import 'package:majadigi_mobile/domain/stac_build_runner/stac_custom_form_submit_action/stac_custom_form_submit_action.dart';
import 'package:stac/stac_core.dart';

@StacScreen(screenName: 'siskaperbapo')
StacWidget siskaperbapo() {
   return StacScaffold(
     appBar: StacAppBar(
       backgroundColor: StacColors.white,
       title: StacText(
         data: "Harga Bahan Pokok (SISKAPERBAPO)",
         style: StacTextStyle(
           color: StacColors.black,
           fontWeight: StacFontWeight.w600
         )
       ),
     ),
     body: StacSafeArea(
       child: StacSingleChildScrollView(
           scrollDirection: StacAxis.vertical,
           padding: StacEdgeInsets.all(16.0),
           child: StacColumn(
               spacing: 16.0,
               children: [
                 // ? Title
                 _header(),

                 // ? Description
                 _description(),

                 // ? Form
                 _form(),

                 // ? Cards
                 _cards(),
               ]
           )
       )
     )
   );
}

StacWidget _header() {
  return StacRow(
    mainAxisAlignment: StacMainAxisAlignment.start,
    children: [
      // Image
      StacExpanded(
        flex: 3,
        child: StacCachedImage(
          imageUrl: '\$baseURL\${imageURL}siskaperbapo/logo-provinsi-jawa-timur.webp',
          height: 75,
        ),
      ),

      // Title and Subtitle
      StacExpanded(
        flex: 9,
        child: StacColumn(
          mainAxisAlignment: StacMainAxisAlignment.center,
          crossAxisAlignment: StacCrossAxisAlignment.start,
          children: [
            // Title
            StacText(
              data: 'SISKAPERBAPO',
              style: StacTextStyle(
                fontSize: 18,
                fontWeight: StacFontWeight.bold,
              ),
            ),

            // Subtitle
            StacText(
              data: 'Sistem Informasi Ketersediaan dan Perkembangan Harga Bahan Pokok',
              style: StacTextStyle(
                fontSize: 12,
                color: StacColors.grey,
              ),
            ),
          ]
        )
      )
    ]
  );
}

StacWidget _description() {
  return StacContainer(
    padding: StacEdgeInsets.all(16.0),
    decoration: StacBoxDecoration(
      borderRadius: StacBorderRadius.circular(16.0),
      color: '#0047B3', // Can accept hex in (stac | color)[https://docs.stac.dev/styles/colors]
    ),
    child: StacText(
      data: "SISKAPERBAPO, singkatan dari Sistem Informasi Ketersediaan dan Perkembangan Harga Bahan Pokok. Merupakan portal berbasis online yang menyajikan info tren harga dan ketersediaan bahan pokok harian dari seluruh area di Jawa Timur.",
      style: StacTextStyle(
        fontSize: 14,
        fontWeight: StacFontWeight.normal,
        color: StacColors.white,
      ),
      textAlign: StacTextAlign.justify,
    ),
  );
}

StacWidget _form() {
  return StacContainer(
      padding: StacEdgeInsets.all(16.0),
      decoration: StacBoxDecoration(
        borderRadius: StacBorderRadius.circular(16.0),
        color: "#E0E0E0",
      ),
      width: double.maxFinite,
      child: StacForm(
          child: StacColumn(
              mainAxisAlignment: StacMainAxisAlignment.center,
              crossAxisAlignment: StacCrossAxisAlignment.start,
              spacing: 8.0,
              children: [
                // Bahan Pokok
                StacText(
                    data: "Jenis Bahan Pokok",
                    style: StacTextStyle(
                      fontSize: 18,
                      fontWeight: StacFontWeight.normal,
                    )
                ),

                // ! Change with String divided with commas (List<String>)
                _customModalHelper("bahan-pokok", "Bahan Pokok", ["\$ListBapok"]),

                // Area
                StacText(
                  data: "Area",
                  style: StacTextStyle(
                    fontSize: 18,
                    fontWeight: StacFontWeight.normal,
                  ),
                ),

                // ! Change with String divided with commas (List<String>)
                _customModalHelper("area", "Area", ["\$ListArea"]),

                // Custom Date Picker
                StacText(
                  data: "Tanggal",
                  style: StacTextStyle(
                    fontSize: 18,
                    fontWeight: StacFontWeight.normal,
                  ),
                ),
                StacCustomDatePicker(
                  id: "date",
                  decoration: StacInputDecoration(
                    hintText: "Pilih Tanggal",
                    suffixIcon: StacIcon(icon: StacIcons.calendar_today),
                    filled: true,
                    fillColor: StacColors.white,
                    enabledBorder: StacInputBorder(
                      borderRadius: StacBorderRadius.circular(16),
                      type: StacInputBorderType.outlineInputBorder,
                      width: 1,
                      color: StacColors.blueAccent,
                    ),
                    focusedBorder: StacInputBorder(
                      borderRadius: StacBorderRadius.circular(16),
                      type: StacInputBorderType.outlineInputBorder,
                      width: 1,
                      color: StacColors.blue
                    ),
                  ),
                ),

                // Form Submit Button
                StacElevatedButton(
                  child: StacText(data: 'Tampilkan', style: StacTextStyle(color: StacColors.white)),
                  style: StacButtonStyle(
                    backgroundColor: StacColors.indigo,
                    padding: StacEdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    shape: StacRoundedRectangleBorder(
                      borderRadius: StacBorderRadius.circular(12),
                    ),
                  ),
                  onPressed: StacCustomFormSubmitAction(
                    // ! Change with a String (String)
                    nextPageUrl: "\$nextPageUrl",
                    formIds: [
                      "bahan-pokok",
                      "area",
                      "date"
                    ]
                  ),
                ),
              ]
          )
      )
  );
}

StacWidget _customModalHelper(String id, String hintText, List<String> items) {
  return StacCustomFormModal(
    id: id,
    hintText: hintText,
    items: items,
    decoration: StacInputDecoration(
      hintText: hintText,
      enabledBorder: StacInputBorder(
        borderRadius: StacBorderRadius.circular(16),
        type: StacInputBorderType.outlineInputBorder,
        width: 1,
        color: StacColors.blueAccent,
      ),
      focusedBorder: StacInputBorder(
        borderRadius: StacBorderRadius.circular(16),
        type: StacInputBorderType.outlineInputBorder,
        width: 1,
        color: StacColors.blue,
      ),
      fillColor: StacColors.white,
      filled: true,
    )
  );
}

StacWidget _cards() {
  return StacDynamicView(
    request: StacNetworkRequest(
      url:
      "\$cardDataUrl",
      // "http://192.168.1.10:8080/api/v1/bahan-pokok",
      // "http://10.0.2.2:8080/api/v1/bahan-pokok",
      method: Method.get,
    ),
    targetPath: 'data',
    loaderWidget: StacCircularProgressIndicator(),
    errorWidget: StacText(data: 'Data Fetch Error'),
    emptyTemplate: StacText(data: 'Empty Data'),
    template: StacWidget.fromJson({
      "type": "gridView",
      "physics": "never",
      "shrinkWrap": true,
      "itemTemplate": StacCard(
        color: StacColors.white,
        shadowColor: StacColors.grey,
        elevation: 5,
        child: StacPadding(
          padding: StacEdgeInsets.all(16.0),
          child: StacColumn(
            crossAxisAlignment: StacCrossAxisAlignment.start,
            children: [
              StacExpanded(
                child: StacContainer(
                  width: double.maxFinite,
                  decoration: StacBoxDecoration(
                    borderRadius: StacBorderRadius.circular(10.0),
                    color: "#E0E0E0",
                  ),
                  child: StacCachedImage(
                    imageUrl: '{{gambar_url}}',
                    useOldImageOnUrlChange: true,
                  )
                )
              ),
              StacText(data: '{{komoditas}}'),
              StacRow(
                spacing: 10.0,
                children: [
                  StacText(data: "Rp {{harga_sekarang}}"),
                  StacConditional(
                    condition: "{{tren}} == TETAP",
                    ifTrue: StacIcon(icon: StacIcons.remove_circle_outline_rounded, size: 16, color: StacColors.orange),
                    ifFalse: StacConditional(
                      condition: "{{tren}} == TURUN",
                      ifTrue: StacIcon(icon: StacIcons.trending_down, size: 16, color: StacColors.red),
                      ifFalse: StacIcon(icon: StacIcons.trending_up, size: 16, color: StacColors.green),
                    ),
                  ),
                ]
              )
            ]
          )
        )
      ).toJson(),
      "crossAxisCount": 2,
      "mainAxisSpacing": 10.0,
      "crossAxisSpacing": 10.0,
    })
  );
}