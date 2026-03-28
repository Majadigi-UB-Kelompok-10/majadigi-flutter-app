import 'package:majadigi_mobile/domain/stac_build_runner/stac_cached_image/stac_cached_image.dart';
import 'package:majadigi_mobile/domain/stac_build_runner/stac_form_builder/stac_form_modal_builder.dart';
import 'package:stac/stac_core.dart';

@StacScreen(screenName: 'siskaperbapo_offline')
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
     body: StacSingleChildScrollView(
       scrollDirection: StacAxis.vertical,
       padding: StacEdgeInsets.all(16.0),
       child: StacColumn(
         spacing: 8.0,
         children: [
           // ? Title
           _header(),

           // ? Description
           _description(),

           // ? Form
           _form(),
         ]
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
              data: 'This is dataUrl: \$dataUrl',
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
    child: StacFormModalBuilder(data: '\$formModalData'),
  );
}