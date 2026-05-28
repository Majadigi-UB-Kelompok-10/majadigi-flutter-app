# Available Endpoints

### [GET] Pengumuman

Endpoint: /jdih/public/pengumuman

Response:
```json
{
  "pesan": "Berhasil mengambil pengumuman terbaru",
  "data": [
    {
      "id": 1,
      "judul": "Layanan Digital Baru Kini Tersedia Untuk Publik",
      "isi": "Kini masyarakat dapat mengakses seluruh dokumen hukum Provinsi Jawa Timur dengan lebih mudah, cepat, dan transparan melalui portal JDIH versi terbaru.",
      "tanggal": "24 May 2026"
    },
    {
      "id": 2,
      "judul": "Sosialisasi Peraturan Daerah Terbaru Tahun 2026",
      "isi": "Pemerintah Provinsi Jawa Timur akan mengadakan sosialisasi terkait Peraturan Daerah terbaru tentang Rencana Tata Ruang Wilayah pada akhir bulan ini di Gedung Negara Grahadi.",
      "tanggal": "24 May 2026"
    }
  ]
}
```

### [GET] Search

Endpoint: /jdih/public/search

Optional Query Parameters:
- keyword
- nomor
- tahun
- jenis
- sort
- page
- limit

Both page and limit is for pagination

Response (No Query Param):
```json
{
  "pesan": "Hasil Pencarian",
  "data": [
    {
      "id": 4,
      "jenis": "se",
      "judul": "Pengibaran Bendera Merah Putih Setengah Tiang",
      "ringkasan": "Instruksi kepada seluruh instansi pemerintah untuk mengibarkan bendera setengah tiang sebagai tanda hari berkabung nasional.",
      "tanggal": "01 Jan 2026",
      "status": "berlaku",
      "jumlah_view": 1500
    },
    (and more...)
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 4
  }
}
```

### [GET] Dokumen by Jenis

Endpoint: /jdih/public/dokumen/{jenis}

Optional Query Parameters:
- keyword
- tahun
- page
- limit

Both page and limit is for pagination

Response for "/jdih/public/dokumen/se":
```json
{
  "pesan": "Daftar SE",
  "data": [
    {
      "id": 4,
      "jenis": "SE",
      "judul": "Pengibaran Bendera Merah Putih Setengah Tiang",
      "tanggal": "01 Jan 2026",
      "status": "berlaku",
      "pdf_url": "https://res.cloudinary.com/demo/raw/upload/v1/jdih/dummy_se_bendera_2026.pdf"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 1
  }
}
```

### [GET] Tahun by Jenis

Endpoint: /jdih/public/dokumen/{jenis}/tahun

Response for "/jdih/public/dokumen/se/tahun":
```json
{
  "pesan": "Filter Tahun",
  "data": [
    2026
  ]
}
```

### [GET] Detail Dokumen

Endpoint: /jdih/public/dokumen/detail/{id}

Response for "/jdih/public/dokumen/detail/1":
```json
{
  "pesan": "Detail Dokumen",
  "data": {
    "id": 1,
    "jenis": "perda",
    "nomor": "1",
    "tahun": 2023,
    "judul": "Peraturan Daerah tentang Pengelolaan Keuangan Daerah Provinsi Jawa Timur Tahun 2023",
    "ringkasan": "Mengatur pedoman pengelolaan keuangan daerah yang transparan dan akuntabel sesuai dengan standar akuntansi pemerintahan.",
    "tanggal_penetapan": "15 Jan 2023",
    "status": "berlaku",
    "pdf_url": "https://res.cloudinary.com/demo/raw/upload/v1/jdih/dummy_perda_1_2023.pdf",
    "pdf_size_kb": 1250,
    "urusan_pemerintahan": "Keuangan Daerah",
    "jumlah_view": 1201,
    "subjek": [
      {
        "id": 1,
        "nama": "Keuangan Daerah"
      }
    ]
  }
}
```