# Available Endpoints

### [GET] Bahan Pokok

Endpoint: /siskaperbapo/public/bahan-pokok

Optional Query Params:
- tanggal: {yyyy-MM-dd}
- bahan_pokok: {string}
- area: {string}
- page: {string}
- limit: {string}

Both page and limit is for pagination. Limit default to 10

Response (No Query Params):
```
{
  "pesan": "Daftar Komoditas (Warmup)",
  "data": [
    {
      "tren": "TURUN",
      "id": 1,
      "komoditas": "Bawang Merah / Kg",
      "slug": "bawang-merah",
      "satuan": "kg",
      "gambar_url": "https://nhsdrdhzkogczngslvvh.supabase.co/storage/v1/object/public/image-asset/siskaperbapo/bawang-merah.webp",
      "harga_sekarang": 19000
    },
    (and more...)
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 6
  }
}
```

### [GET] Detail Bahan Pokok

Endpoint: /siskaperbapo/public/bahan-pokok/{slug}

Optional Query Params:
- tanggal: {yyyy-MM-dd}
- area: {string}

Example Input: /siskaperbapo/public/bahan-pokok/bawang-merah

Response:
```
{
  "pesan": "Detail Komoditas",
  "data": {
    "id": 1,
    "komoditas": "Bawang Merah / Kg",
    "slug": "bawang-merah",
    "satuan": "kg",
    "gambar_url": "https://nhsdrdhzkogczngslvvh.supabase.co/storage/v1/object/public/image-asset/siskaperbapo/bawang-merah.webp",
    "tanggal": "2026-05-25",
    "tanggal_data_aktual": "2026-03-29",
    "area_pilihan": "",
    "harga_utama": 19000,
    "tren": "TURUN",
    "grafik_riwayat": [
      {
        "tanggal": "2026-03-25",
        "rata_rata_harga": 21000
      },
      {
        "tanggal": "2026-03-26",
        "rata_rata_harga": 15000
      },
      (and more..)
    ],
    "list_kab_kota": [
      {
        "area": "Surabaya",
        "area_slug": "surabaya",
        "harga": 19000
      }
    ],
    "statistik_15_hari": {
      "tertinggi": {
        "area": "Surabaya",
        "area_slug": "surabaya",
        "harga": 18600
      },
      "terendah": {
        "area": "Jombang",
        "area_slug": "jombang",
        "harga": 15000
      }
    }
  }
}
```

### [GET] Area List

Endpoint: /siskaperbapo/public/areas

Response:
```
{
  "pesan": "Daftar Area",
  "data": [
    {
      "id": 1,
      "nama": "Bangkalan",
      "slug": "bangkalan"
    },
    {
      "id": 2,
      "nama": "Banyuwangi",
      "slug": "banyuwangi"
    },
    (and more...)
  ]
}
```