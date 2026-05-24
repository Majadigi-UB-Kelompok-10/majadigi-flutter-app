The dto is structured that way due to how the data is passed from the backend.

BasePrefix: /bansos
Endpoint: ${BasePrefix}/public/cek-bansos?nik={nik}

Example Response for nik=1234567890123456:
```
{
  "pesan": "Data ditemukan",
  "data": {
    "profil": {
      "nama": "Budi Santoso",
      "alamat": "Kota Malang",
      "nik": "1234567890123456"
    },
    "riwayat": [
      {
        "penyaluran_id": 2,
        "program_nama": "BPNT",
        "periode": "April 2026",
        "nominal": "Rp. 500.000",
        "status": "PROSES"
      },
      {
        "penyaluran_id": 1,
        "program_nama": "Bantuan PKH",
        "periode": "Januari 2026",
        "nominal": "Rp. 750.000",
        "status": "DITERIMA"
      }
    ]
  }
}
```
