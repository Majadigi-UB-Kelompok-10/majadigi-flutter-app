# Available Endpoints

### [GET] Areas

Endpoints: /sidita/public/areas

Response:
```json
{
  "pesan": "Daftar Area",
  "data": [
      "id": 1,
      "nama": "Kota Malang",
      "slug": "kota-malang",
      "lat": -7.9666200,
      "lng": 112.6326400
    }
    (and more...)
  ]
}
```

## Part of Destination Endpoints

From this point forward, there will be optional query parameters that make use of paginations. Paginations uses "page" and "limit"

### [GET] Destination

Endpoint: /sidita/public/destinasi

Optional Query Parameter:
- search: {String}
- area: {taken from get areas endpoint, String}
- page: {Number}
- limit: {Number}

Response (No Query Param):
```json
{
  "pesan": "Daftar Destinasi",
  "data": [
    {
      "id": 3,
      "nama": "Kampung Warna-Warni Jodipan",
      "slug": "kampung-jodipan-5e9a4b2d",
      "kategori": "Wisata Budaya",
      "alamat": "Jodipan, Blimbing, Kota Malang",
      "highlight_text": "Spot foto Instagramable",
      "gambar_url_thumbnail": "https://res.cloudinary.com/sample/image/upload/w_400/jodipan_thumb.jpg",
      "lat": -7.9854100,
      "lng": 112.6427800,
      "area_nama": "Kota Malang",
      "area_slug": "kota-malang"
    },
    (and more...)
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total_data": 5,
    "total_pages": 1
  }
}
```

### [GET] Destination Map

Endpoint: /sidita/public/destinasi/maps

Optional Query Parameters:
- search: {String}
- area: {taken from get areas endpoint, String}

Response (No Query Param):
```json
{
  "pesan": "Peta Destinasi",
  "data": {
    "center": {
      "lat": "-7.697739",
      "lng": "112.493863",
      "zoom": 8
    },
    "points": [
      {
        "id": 1,
        "nama": "Jatim Park 1",
        "slug": "jatim-park-1-a3f2b1c4",
        "kategori": "Taman Hiburan",
        "gambar_url_thumbnail": "https://res.cloudinary.com/sample/image/upload/w_400/jatim_park_1_thumb.jpg",
        "lat": -7.8856700,
        "lng": 112.5283400
      },
      (and more...)
    ]
  }
}
```

### [GET] Destination Recommendation

Endpoint: /sidita/public/destinasi/recommendation

Response:
```json
{
  "pesan": "Rekomendasi Destinasi",
  "data": {
    "items": [
      {
        "id": 4,
        "nama": "Pantai Balekambang",
        "gambar_url_thumbnail": "https://res.cloudinary.com/sample/image/upload/w_400/balekambang_thumb.jpg",
        "alamat": "Bantur, Kabupaten Malang",
        "area_nama": "Kabupaten Malang"
      },
      (and more...)
    ]
  }
}
```

### [GET] Destination Detail

Endpoint: /sidita/public/destinasi/{id}

Response for (id=1):
```json
{
  "pesan": "Detail Destinasi",
  "data": {
    "id": 1,
    "nama": "Jatim Park 1",
    "slug": "jatim-park-1-a3f2b1c4",
    "kategori": "Taman Hiburan",
    "deskripsi": "Taman hiburan keluarga dengan wahana edukasi dan rekreasi.",
    "alamat": "Jl. Kartika No.2, Kota Batu",
    "highlight_text": "Wahana edukasi terbaik di Malang",
    "gambar_url_hero": "https://res.cloudinary.com/sample/image/upload/w_1600/jatim_park_1_hero.jpg",
    "lat": -7.8856700,
    "lng": 112.5283400,
    "created_at": "2026-05-24T00:31:06.983525+07:00",
    "area_id": 3,
    "area_nama": "Kota Batu",
    "area_slug": "kota-batu"
  }
}
```

## Part of Hotels Endpoint

### [GET] Hotels

Endpoint: /sidita/public/hotel

Optional Query Parameter:
- search: {String}
- area: {taken from get areas endpoint, String}
- page: {Number}
- limit: {Number}

Response (No Query Param):
```json
{
  "pesan": "Daftar Hotel",
  "data": [
    {
      "id": 1,
      "nama": "Hotel Tugu Malang",
      "slug": "hotel-tugu-malang-1a2b3c4d",
      "bintang": 5,
      "harga_mulai": 1500000,
      "alamat": "Jl. Tugu No.3, Klojen, Kota Malang",
      "highlight_text": "Hotel heritage di pusat kota",
      "gambar_url": "https://res.cloudinary.com/sample/image/upload/w_800/hotel_tugu.jpg",
      "lat": -7.9785400,
      "lng": 112.6304700,
      "area_nama": "Kota Malang",
      "area_slug": "kota-malang"
    },
    (and more...)
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total_data": 4,
    "total_pages": 1
  }
}
```

### [GET] Hotel Map

Endpoint: /sidita/public/hotel/maps

Optional Query Parameters:
- search: {String}
- area: {taken from get areas endpoint, String}

Response (No Query Param):
```json
{
  "pesan": "Peta Hotel",
  "data": {
    "center": {
      "lat": "-7.697739",
      "lng": "112.493863",
      "zoom": 8
    },
    "points": [
      {
        "id": 1,
        "nama": "Hotel Tugu Malang",
        "slug": "hotel-tugu-malang-1a2b3c4d",
        "bintang": 5,
        "gambar_url": "https://res.cloudinary.com/sample/image/upload/w_800/hotel_tugu.jpg",
        "lat": -7.9785400,
        "lng": 112.6304700
      },
      (and more...)
    ]
  }
}
```

### [GET] Hotel Recommendation

Endpoint: /sidita/public/hotel/recommendation

Response:
```json
{
  "pesan": "Rekomendasi Hotel",
  "data": {
    "items": [
      {
        "id": 2,
        "nama": "Hotel Kartika Wijaya",
        "bintang": 4,
        "alamat": "Jl. Panglima Sudirman No.127, Kota Batu",
        "gambar_url": "https://res.cloudinary.com/sample/image/upload/w_800/kartika_wijaya.jpg",
        "area_nama": "Kota Batu"
      },
      (and more...)
    ]
  }
}
```

### [GET] Hotel Detail

Endpoint: /sidita/public/hotel/{id}

Response (id=1):
```json
{
  "pesan": "Detail Hotel",
  "data": {
    "id": 1,
    "area_id": 1,
    "nama": "Hotel Tugu Malang",
    "slug": "hotel-tugu-malang-1a2b3c4d",
    "bintang": 5,
    "harga_mulai": 1500000,
    "deskripsi": "Hotel butik mewah dengan koleksi seni dan antik.",
    "alamat": "Jl. Tugu No.3, Klojen, Kota Malang",
    "highlight_text": "Hotel heritage di pusat kota",
    "gambar_url": "https://res.cloudinary.com/sample/image/upload/w_800/hotel_tugu.jpg",
    "lat": -7.9785400,
    "lng": 112.6304700,
    "created_at": "2026-05-27T23:13:24.806785+07:00",
    "updated_at": "2026-05-27T23:13:24.806785+07:00"
  }
}
```

## Part of Event Endpoint

### [GET] Event

Endpoint: /sidita/public/event

Optional Query Parameters:
- search: {String}
- area: {taken from get areas endpoint, String}
- page: {Number}
- limit: {Number}
- tahun: {Number}
- bulan: {String}

* Side Note: Apparently "bulan" or month accept String, and during testing does accept month in both number of month or the name of the month itself (eg. 8 would mean August, but if "August", which is also not case sensitive, is given instead, it will also return the same result as the number counterpart). Though, I would prefer using number as the value to avoid confusion.

Response (No Query Param):
```json
{
  "pesan": "Daftar Event",
  "data": [
    {
      "id": 4,
      "nama": "Malang Tempo Doeloe 2026",
      "slug": "malang-tempo-doeloe-2026-6e7a8b9c",
      "alamat": "Jl. Ijen, Kota Malang",
      "tanggal_mulai": "2026-09-05",
      "tanggal_selesai": "2026-09-07",
      "harga_tiket": 0,
      "gambar_url_thumbnail": "https://res.cloudinary.com/sample/image/upload/w_400/mtd_thumb.jpg",
      "tahun": 2026,
      "bulan": 9,
      "area_nama": "Kota Malang",
      "area_slug": "kota-malang"
    },
    (and more...)
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total_data": 4,
    "total_pages": 1
  }
}
```

### [GET] Event Recommendation

Endpoint: /sidita/public/event/recommendation

Response:
```json
{
  "pesan": "Rekomendasi Event",
  "data": {
    "items": [
      {
        "id": 4,
        "nama": "Malang Tempo Doeloe 2026",
        "alamat": "Jl. Ijen, Kota Malang",
        "gambar_url_thumbnail": "https://res.cloudinary.com/sample/image/upload/w_400/mtd_thumb.jpg",
        "tanggal": 5,
        "bulan": 9
      },
      (and more...)
    ]
  }
}
```

### [GET] Year/Tahun Dropdown List

Endpoint: /sidita/public/event/tahun-tersedia

Response:
```json
{
  "pesan": "Tahun Event Tersedia",
  "data": {
    "tahun": [
      2026
    ]
  }
}
```

### [GET] Event Details

Endpoint: /sidita/public/event/{id}

Response (id=1):
```json
{
  "pesan": "Detail Event",
  "data": {
    "event": {
      "id": 1,
      "nama": "Malang Flower Carnival 2026",
      "slug": "malang-flower-carnival-2026-7b2c8d1e",
      "deskripsi": "Karnaval bunga tahunan dengan kostum bertema flora khas Malang.",
      "alamat": "Jl. Ijen, Kota Malang",
      "tanggal_mulai": "2026-05-15",
      "tanggal_selesai": "2026-05-15",
      "info_tiket": "Gratis untuk umum",
      "harga_tiket": 0,
      "gambar_url_hero": "https://res.cloudinary.com/sample/image/upload/w_1600/mfc_hero.jpg",
      "lat": -7.9712300,
      "lng": 112.6234800,
      "created_at": "2026-05-27T23:13:24.823672+07:00",
      "area_id": 1,
      "area_nama": "Kota Malang",
      "area_slug": "kota-malang"
    }
  }
}
```