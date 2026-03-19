import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:majadigi_mobile/http.dart';

class Siskaperbapo extends StatelessWidget {
  const Siskaperbapo({super.key});
  static const Map<String, List<String>> menuItems = {
    "Jenis Bahan Pokok": [
      'Beras Medium / Kg',
      'Bawang Merah / Kg',
      'Bawang Putih / Kg',
      'Cabai Rawit / Kg',
      'Cabai Merah / Kg',
      'Gula Pasir / Kg',
      'Gula Aren / Kg',
    ],
    "Area": [
      'Jawa Timur',
      'Batu',
      'Blitar',
      'Kediri',
      'Madiun',
      'Malang',
      'Mojokerto',
      'Pasuruan',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          "Harga Bahan Pokok (SISKAPERBAPO)",
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              // Title
              SizedBox(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: CachedNetworkImage(
                          imageUrl: '$baseURL${imageURL}siskaperbapo/logo-provinsi-jawa-timur.webp',
                          fit: BoxFit.contain,
                          height: 75,
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SISKAPERBAPO',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Sistem Informasi Ketersediaan dan Perkembangan Harga Bahan Pokok',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ]
                        )
                      ),
                    ]
                ),
              ),

              // Desc
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  color: Color(0xFF0047B3), // 0xFF for hex representation of #
                ),
                child: Text(
                  "SISKAPERBAPO, singkatan dari Sistem Informasi Ketersediaan dan Perkembangan Harga Bahan Pokok. Merupakan portal berbasis online yang menyajikan info tren harga dan ketersediaan bahan pokok harian dari seluruh area di Jawa Timur.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),

              // Form
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  color: Colors.grey.shade300,
                ),
                width: double.infinity,
                child: Form(
                  key: GlobalKey<FormState>(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16.0,
                    children: [
                      for (final entry in menuItems.entries) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 10.0),
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DropdownMenuFormField(
                              decorationBuilder: (BuildContext context, MenuController controller) {
                                return InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue, width: 1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: entry.value.first,
                                  hintStyle: TextStyle(color: Colors.grey.shade500),
                                );
                              },
                              expandedInsets: EdgeInsets.zero,
                              dropdownMenuEntries: entry.value.map((String value) {
                                return DropdownMenuEntry(
                                  value: value,
                                  label: value,
                                  style: ButtonStyle(
                                    foregroundColor: WidgetStateProperty.all<Color>(Colors.grey.shade500),
                                  )
                                );
                              }).toList(),
                              menuStyle: MenuStyle(
                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Date Picker
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(horizontal: 10.0),
                            child: Text(
                              "Tanggal",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          TextField(
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.calendar_today),
                                suffixIconConstraints: BoxConstraints(
                                  minWidth: 60,
                                  minHeight: 20,
                                  maxWidth: 60,
                                  maxHeight: 20,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                hintStyle: TextStyle(color: Colors.grey.shade500),
                                hintText: 'Pilih Tanggal',
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              readOnly: true,
                              onTap: () async {
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                              }
                          ),
                        ],
                      ),

                      ElevatedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.indigo.shade600),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            )
                          ),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: Text(
                          "Tampilkan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ),

              // Cards
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    padding: EdgeInsetsGeometry.zero,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (int i = 0; i < ((menuItems["Jenis Bahan Pokok"]!.length)).floor(); i += 2) ...[
                        Card(
                          color: Colors.white,
                          shadowColor: Colors.grey.shade300,
                          elevation: 5,
                          child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          color: Colors.grey.shade100,
                                        ),
                                      )
                                    ),
                                    Text(menuItems["Jenis Bahan Pokok"]!.elementAt(i)),
                                    Text("Rp ..."),
                                  ]
                              )
                          )
                        ),
                        if (menuItems["Jenis Bahan Pokok"]!.length - 1 > i) ...[
                          Card(
                            color: Colors.white,
                            shadowColor: Colors.grey.shade300,
                            elevation: 5,
                            child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              color: Colors.grey.shade100,
                                            ),
                                          )
                                      ),
                                      Text(menuItems["Jenis Bahan Pokok"]!.elementAt(i+1)),
                                      Text("Rp ..."),
                                    ]
                                )
                            )
                          )
                        ]
                      ],
                    ],
                  ),
                ],
              ),
            ]
          ),
        ),
      ),
    );
  }
}