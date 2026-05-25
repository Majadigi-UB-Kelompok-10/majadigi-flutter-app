# Available Endpoints

### [GET] Terminal List

Endpoint: /transjatim/public/terminals

Response:
```
{
  "pesan": "Sukses",
  "data": [
    {
      "id": 3,
      "nama": "Terminal Batu",
      "kota": "Batu",
      "slug": "terminal-batu",
      "lat": -7.8696,
      "lng": 112.5295,
      "aktif": true
    },
    (and more...)
  ]
}
```

### [GET] Ticket Pricing

Endpoint: /transjatim/public/harga

Response:
```
{
  "pesan": "Informasi Harga Tiket",
  "data": {
    "reguler": [
      {
        "tipe_penumpang": "umum",
        "harga": 5000,
        "keterangan": "Penumpang dewasa / umum."
      },
      (and more...)
    ],
    "luxury": [
      {
        "rute_nama": "Malang - Batu",
        "harga": 20000,
        "fasilitas": "Kursi premium (tanpa berdiri) dan AC ekstra dingin."
      },
      (and more...)
    ]
  }
}
```

### [GET] Search Schedule/Jadwal

Endpoint: /transjatim/public/jadwal/search

Query Parameters:
```
{
    "asal_id": {integer},
    "tujuan_id": {integer},
    "tanggal": {yyyy-MM-dd}
}
```

Example Query Parameter:
```
{
    "asal_id": 1,
    "tujuan_id": 3,
    "tanggal": "2026-05-10"
}
```

Response:
```
{
  "pesan": "Pencarian Jadwal Berhasil",
  "data": [
    {
      "id": 1,
      "bus_kode": "BUS-V01",
      "bus_layanan": "reguler",
      "jam_berangkat": "05:00",
      "jam_tiba": "06:20",
      "durasi_menit": 80,
      "terminal_asal": "Terminal Hamid Rusdi",
      "terminal_tujuan": "Terminal Batu",
      "harga": 5000
    },
    (and more...)
  ]
}
```

### [GET] Schedule/Jadwal Detail

Endpoint: /transjatim/public/jadwal/{id}

Example Input: /transjatim/public/jadwal/1

Response:
```
{
  "pesan": "Detail Jadwal",
  "data": {
    "id": 1,
    "bus_kode": "BUS-V01",
    "bus_layanan": "reguler",
    "jam_berangkat": "05:00",
    "jam_tiba": "06:20",
    "durasi_menit": 80,
    "terminal_asal": "Terminal Hamid Rusdi",
    "terminal_tujuan": "Terminal Batu",
    "rute_id": 1,
    "stops": [
      "Malang - Terminal Hamid Rusdi",
      "Malang - Terminal Arjosari",
      "Batu - Terminal Batu"
    ],
    "semua_harga": [
      {
        "tipe_penumpang": "umum",
        "harga": 5000
      },
      {
        "tipe_penumpang": "pelajar_santri",
        "harga": 2500
      },
      {
        "tipe_penumpang": "mahasiswa",
        "harga": 2500
      }
    ]
  }
}
```