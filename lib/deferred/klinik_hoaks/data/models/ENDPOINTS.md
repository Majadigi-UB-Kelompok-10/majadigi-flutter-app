# Available Endpoints

### [GET] Categories

Endpoint: /klinik/public/categories

Response:
```json
{
  "pesan": "Daftar Kategori",
  "data": [
    {
      "id": "11111111-1111-1111-1111-111111111111",
      "name": "Berita Hoaks",
      "slug": "berita-hoaks",
      "icon_url": "https://res.cloudinary.com/demo/image/upload/v1618471325/sample.jpg"
    },
    {
      "id": "22222222-2222-2222-2222-222222222222",
      "name": "Disinformasi",
      "slug": "disinformasi",
      "icon_url": "https://res.cloudinary.com/demo/image/upload/v1618471325/sample.jpg"
    }
  ]
}
```

### [GET] Stats

Endpoint: /klinik/public/stats

Response:
```json
{
  "pesan": "Sukses",
  "data": [
    {
      "category_id": "11111111-1111-1111-1111-111111111111",
      "category_name": "Berita Hoaks",
      "category_slug": "berita-hoaks",
      "icon_url": "https://res.cloudinary.com/demo/image/upload/v1618471325/sample.jpg",
      "total_news": 1
    },
    {
      "category_id": "22222222-2222-2222-2222-222222222222",
      "category_name": "Disinformasi",
      "category_slug": "disinformasi",
      "icon_url": "https://res.cloudinary.com/demo/image/upload/v1618471325/sample.jpg",
      "total_news": 1
    },
    {
      "category_id": "33333333-3333-3333-3333-333333333333",
      "category_name": "Fakta",
      "category_slug": "fakta",
      "icon_url": "https://res.cloudinary.com/demo/image/upload/v1618471325/sample.jpg",
      "total_news": 0
    },
    {
      "category_id": "44444444-4444-4444-4444-444444444444",
      "category_name": "Hate Speech",
      "category_slug": "hate-speech",
      "icon_url": "https://res.cloudinary.com/demo/image/upload/v1618471325/sample.jpg",
      "total_news": 0
    }
  ]
}
```

### [GET] News

Endpoint: /klinik/public/news

Optional Query Parameters:
- Search
- Page
- Limit

page and limits is for pagination

Response (No Query Parameter):
```json
{
  "pesan": "Daftar Berita",
  "data": [
    {
      "id": "ffffffff-ffff-ffff-ffff-ffffffffffff",
      "title": "[DISINFORMASI] Video Gempa Megathrust Hancurkan Balai Kota Hari Ini",
      "slug": "disinformasi-video-gempa-megathrust-balai-kota",
      "image_url": "https://res.cloudinary.com/demo/image/upload/v1618471325/sample.jpg",
      "category_name": "Disinformasi",
      "category_slug": "disinformasi",
      "published_at": "23 May 2026"
    },
    {
      "id": "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee",
      "title": "[HOAKS] Air Rebusan Bawang Putih Sembuhkan Virus dalam 5 Menit",
      "slug": "hoaks-air-rebusan-bawang-putih",
      "image_url": "https://res.cloudinary.com/demo/image/upload/v1618471325/sample.jpg",
      "category_name": "Berita Hoaks",
      "category_slug": "berita-hoaks",
      "published_at": "22 May 2026"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 2
  }
}
```

### [GET] Detail News

Endpoint: /klinik/public/news/{slug}

Response for "/klinik/public/news/disinformasi-video-gempa-megathrust-balai-kota":
```json
{
  "pesan": "Detail Berita",
  "data": {
    "id": "ffffffff-ffff-ffff-ffff-ffffffffffff",
    "title": "[DISINFORMASI] Video Gempa Megathrust Hancurkan Balai Kota Hari Ini",
    "slug": "disinformasi-video-gempa-megathrust-balai-kota",
    "description": "Sebuah video di TikTok memperlihatkan guncangan dahsyat yang diklaim sebagai gempa megathrust terkini di Balai Kota. Setelah dilakukan penelusuran fakta, video tersebut adalah rekaman kejadian gempa di negara lain pada tahun 2018 yang diedit ulang dan disebarkan dengan narasi yang menyesatkan.",
    "reference_link": "https://www.bmkg.go.id/klarifikasi-gempa",
    "image_url": "https://res.cloudinary.com/demo/image/upload/v1618471325/sample.jpg",
    "category_name": "Disinformasi",
    "category_slug": "disinformasi",
    "published_at": "23 May 2026 00:31 WIB"
  }
}
```

### [POST] Reports

Endpoint: /klinik/public/reports

Body (Multipart Form):
```json
{
  "nama": "Judul Laporan",
  "email": "email@email.com",
  "no_hp": "081122223333",
  "isi_laporan": "description here",
  "link_bukti": "link here",
  "gambar_bukti": "(file)"
}
```

only "nama", "email", "no_hp", and "isi_laporan" is mandatory.
Both "link_bukti" and "gambar_bukti" is optional

Response:
```json
{
  "pesan": "Laporan berhasil dikirim",
  "data": {
    "ticket_number": "KH-8E2E0DA5",
    "created_at": "2026-05-26T21:12:16+07:00"
  }
}
```

### [GET] Track Report

Endpoint: /klinik/public/reports/track?no_tiket={ticket_number}

Query Param (Mandatory):
- no_tiket

Response for "/klinik/public/reports/track?no_tiket=KH-C9194AFE":
```json
{
  "pesan": "Data Ditemukan",
  "data": {
    "report_id": "60345686-f677-4067-9c06-ffd33732a2dc",
    "ticket_number": "KH-C9194AFE",
    "reporter_name": "laporan baru",
    "report_status": "PENDING",
    "reported_at": "2026-05-26T21:11:52+07:00"
  }
}
```