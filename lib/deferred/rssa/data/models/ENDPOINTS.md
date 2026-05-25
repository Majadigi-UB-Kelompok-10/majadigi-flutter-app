# Available Endpoints

### Get Summary

Endpoint: /rssa/public/summary

Response:
```
{
  "pesan": "Sukses",
  "data": {
    "total_kapasitas": 80,
    "total_tersedia": 29
  }
}
```

### Get Kelas

Endpoint: /rssa/public/kelas

Response:
```
{
  "pesan": "Sukses",
  "data": [
    {
      "id": 1,
      "nama": "VVIP",
      "slug": "vvip"
    },
    {
      "id": 2,
      "nama": "VIP",
      "slug": "vip"
    },
    (and more...)
  ]
}
```

### Get Ruangan

Endpoint: /rssa/public/ruangan

Optional Query Parameters:
- search = {string}
- kelas = {string}

Response (No Query Parameters):
```
{
  "pesan": "Daftar Ruangan RSSA",
  "data": [
    {
      "id": 11,
      "nama": "Bangsal Asoka (Kelas III)",
      "slug": "bangsal-asoka-kelas-3",
      "kelas_nama": "Kelas III",
      "kelas_slug": "kelas-3",
      "kapasitas": 15,
      "terisi": 5,
      "tersedia": 10
    },
    {
      "id": 9,
      "nama": "Bangsal Dahlia (Kelas III)",
      "slug": "bangsal-dahlia-kelas-3",
      "kelas_nama": "Kelas III",
      "kelas_slug": "kelas-3",
      "kapasitas": 12,
      "terisi": 8,
      "tersedia": 4
    },
    (and more...)
  ],
  "pagination": {
    "page": 1,
    "limit": 14,
    "total": 14
  }
}
```