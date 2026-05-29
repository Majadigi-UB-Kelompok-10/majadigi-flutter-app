# Available Endpoints

### [GET] Kota List

Endpoint: /sinaker/public/kota

Response:
```json
{
  "pesan": "Berhasil mengambil data kota",
  "data": [
    "Kabupaten Jember",
    "Kabupaten Malang",
    "Kota Kediri",
    "Surabaya"
  ]
}
```

### [GET] BLK List

Endpoint: /sinaker/public/blk

Optional Query Parameters:
- kota: {kota}

Query parameter is case sensitive and taken from kota list endpoint

Response (w/o query parameters):
```json
{
  "pesan": "Berhasil mengambil data BLK",
  "data": [
    {
      "id": 4,
      "nama": "UPT BLK Jember",
      "alamat": "Jl. Basuki Rahmat No.202",
      "kab_kota": "Kabupaten Jember",
      "kecamatan": "Kaliwates",
      "slug": "upt-blk-jember",
      "lat": -8.182412,
      "lng": 113.678121
    },
    {
      "id": 2,
      "nama": "UPT BLK Singosari",
      "alamat": "Jl. Raya Singosari No.1",
      "kab_kota": "Kabupaten Malang",
      "kecamatan": "Singosari",
      "slug": "upt-blk-singosari",
      "lat": -7.881729,
      "lng": 112.66311
    },
    (and more...)
  ]
}
```

### [GET] Kejuruan List

Endpoint: /sinaker/public/blk/{id_blk}/kejuruan

Response for "/sinaker/public/blk/1/kejuruan":
```json
{
  "pesan": "Berhasil mengambil data kejuruan",
  "data": [
    {
      "id": 3,
      "nama": "Desain Grafis"
    },
    {
      "id": 2,
      "nama": "Teknik Otomotif"
    },
    {
      "id": 1,
      "nama": "Teknologi Informasi dan Komunikasi (TIK)"
    }
  ]
}
```

### [POST] Pendaftaran

Endpoint: /sinaker/public/pendaftaran

Mandatory Body (Multipart Form):
- blk_id: {blk_id}
- kejuruan_id: {kejuruan_id}
- nik: {16 digit number}
- nama_lengkap: {String}
- tempat_lahir: {String}
- tanggal_lahir: {YYYY-MM-DD}
- email: {Must be a valid email with regex}
- jenis_kelamin: {laki_laki, perempuan}
- provinsi: {take from get provinsi endpoint}
- kab_kota: {take from get kab_kota endpoint}
- kecamatan: {take from get kecamatan endpoint}
- rt: {number}
- rw: {number}
- alamat_lengkap: {String}
- no_wa: {phone_number}
- no_wa_darurat: {phone_number}
- pendidikan_terakhir: {tidak_sekolah, sd, smp, sma_smk, d3, s1, s2, s3}
- pendidikan_sekarang: {tidak_sekolah, sd, smp, sma_smk, d3, s1, s2, s3}
- penyandang_disabilitas: {boolean}
- foto: {File, mimetype should be .png, .jpg, or jpeg only. Max file size is 2MB}

Example Body:
- blk_id: 1
- kejuruan_id: 1
- nik: 3578071204050003
- nama_lengkap: Alfaril Dzaky Praptana
- tempat_lahir: Madiun
- tanggal_lahir: 2005-05-12
- email: alfarildzaky@gmail.com
- jenis_kelamin: laki_laki
- pendidikan_terakhir: s1
- pendidikan_sekarang: s2
- penyandang_disabilitas: false
- foto: some_photo.png

Response for Example Body:
```json
{
  "pesan": "Pendaftaran berhasil dikirim. Silakan cek status secara berkala.",
  "data": {
    "created_at": "2026-05-26T20:35:30.849819+07:00",
    "id": 1,
    "status": "pending"
  }
}
```

### [POST] Check Pendaftaran Status

Endpoint: /sinaker/public/cek-status

Mandatory Body:
- nik: {16 digit number nik}
- no_wa: {phone number}

Example Body:
{
  "nik": "3578071204050003",
  "no_wa": "08113141204"
}

Response for Example Body:
```json
{
  "pesan": "Berhasil mengambil riwayat pendaftaran",
  "data": [
    {
      "id": 1,
      "blk_nama": "UPT BLK Surabaya",
      "blk_slug": "upt-blk-surabaya",
      "kejuruan_nama": "Teknologi Informasi dan Komunikasi (TIK)",
      "status": "pending",
      "tanggal_daftar": "2026-05-26 20:35"
    }
  ]
}
```

### [GET] Wilayah Provinsi List

Endpoint: /sinaker/public/wilayah/provinsi

Response:
```json
{
  "pesan": "Data Wilayah",
  "data": [
    {
      "id": "11",
      "nama": "Aceh",
      "latitude": 0,
      "longitude": 0
    },
    {
      "id": "12",
      "nama": "Sumatera Utara",
      "latitude": 0,
      "longitude": 0
    },
    (and more...)
  ]
}
```

### [GET] Wilayah Kab/Kota List

Endpoint: /sinaker/public/wilayah/kab-kota/{id_provinsi}

Response for "/sinaker/public/wilayah/kab-kota/11":
```json
{
  "pesan": "Data Wilayah",
  "data": [
    {
      "id": "1101",
      "nama": "Kabupaten Aceh Selatan",
      "latitude": 0,
      "longitude": 0
    },
    {
      "id": "1102",
      "nama": "Kabupaten Aceh Tenggara",
      "latitude": 0,
      "longitude": 0
    },
    (and more...)
  ]
}
```

### [GET] Wilayah Kecamatan List

Endpoint: /sinaker/public/wilayah/kecamatan/{id_kab_kota}

Response for "/sinaker/public/wilayah/kecamatan/1101":
```json
{
  "pesan": "Data Wilayah",
  "data": [
    {
      "id": "110101",
      "nama": "Bakongan",
      "latitude": 0,
      "longitude": 0
    },
    {
      "id": "110102",
      "nama": "Kluet Utara",
      "latitude": 0,
      "longitude": 0
    },
    (and more...)
  ]
}
```

### [GET] Wilayah Kelurahan List

Endpoint: /sinaker/public/wilayah/desa/{id_kecamatan}

Response for "/sinaker/public/wilayah/desa/110101":
```json
{
  "pesan": "Data Wilayah",
  "data": [
    {
      "id": "1101012001",
      "nama": "Keude Bakongan",
      "latitude": 2.9310948032,
      "longitude": 97.4845840426
    },
    {
      "id": "1101012002",
      "nama": "Ujong Mangki",
      "latitude": 2.9527245336,
      "longitude": 97.4376186774
    },
    (and more...)
  ]
}
```
