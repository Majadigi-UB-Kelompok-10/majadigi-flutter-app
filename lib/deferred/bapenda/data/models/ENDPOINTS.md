# Available Endpoint

### [POST] to Get Pajak Info

Endpoint: /bapenda/pajak/info

Body (Multipart Form):
- plat_nomor: {string}
- nomor_rangka: {string}

plat_nomor require a string without spaces. Any space whether in the beginning, end, or middle must be trimmed before post.

nomor_rangka strictly only accept 5 digit string. If a user attempt to put in a string with less than 5 digit, fail in frontend before even attempting. If string is more than 5 digit, extract the last 5 digit of the string then try.

Example Body:
- plat_nomor: N1234AB
- nomor_rangka: 12345

Response with example body:
```json
{
  "pesan": "Data ditemukan",
  "data": {
    "identitas": {
      "plat_nomor": "N 1234 AB",
      "merk": "HONDA",
      "tipe": "125 CBS",
      "model": "VARIO",
      "warna": "HITAM",
      "tahun_buat": 2022,
      "masa_pajak": "2026-05-10",
      "status_aktif": true
    },
    "rincian_biaya": {
      "pkb_pokok": 225000,
      "opsen_pkb": 150000,
      "swdkllj": 35000,
      "parkir_berlangganan": 20000,
      "total_pajak": 430000
    },
    "estimasi_5_tahunan": {
      "cetak_stnk": 0,
      "cetak_tnkb": 0
    }
  }
}
```

### [GET] Jenis

Endpoint: /bapenda/njkb/jenis

Response:
```json
{
  "pesan": "Sukses",
  "data": [
    "Mobil",
    "Motor",
    "Truk"
  ]
}
```

### [GET] Merk

Endpoint: /bapenda/njkb/merk

MANDATORY query parameter:
- jenis: {jenis}

If attempting to send without query parameter, will succeed but null data.
Query parameter is CASE SENSITIVE. Take it from Get Jenis Endpoint.

Response for "/bapenda/njkb/merk?jenis=Mobil":
```json
{
  "pesan": "Sukses",
  "data": [
    "HONDA",
    "MITSUBISHI",
    "TOYOTA"
  ]
}
```

### [GET] Model

Endpoint: /bapenda/njkb/model

MANDATORY query parameter:
- jenis: {jenis}
- merk: {merk}

If attempting to send without query parameter, will succeed but null data.
Query parameter is CASE SENSITIVE. Take it from Get Jenis Endpoint and Get Merk Endpoint.

Response for "/bapenda/njkb/model?jenis=Mobil&merk=HONDA":
```json
{
  "pesan": "Sukses",
  "data": [
    "BRIO"
  ]
}
```

### [GET] Tipe

Endpoint: /bapenda/njkb/tipe

MANDATORY query parameter:
- jenis: {jenis}
- merk: {merk}
- model: {model}

If attempting to send without query parameter, will succeed but null data.
Query parameter is CASE SENSITIVE. Take it from Get Jenis Endpoint, Get Merk Endpoint, and Get Model Endpoint.

Response for "/bapenda/njkb/tipe?jenis=Mobil&merk=HONDA&model=BRIO":
```json
{
  "pesan": "Sukses",
  "data": [
    "SATYA E CVT"
  ]
}
```

### [GET] Tahun

Endpoint: /bapenda/njkb/tahun

MANDATORY query parameter:
- jenis: {jenis}
- merk: {merk}
- model: {model}
- tipe: {tipe}

If attempting to send without query parameter, will succeed but null data.
Query parameter is CASE SENSITIVE. Take it from Get Jenis Endpoint, Get Merk Endpoint, Get Model Endpoint, and Get Tipe Endpoint.

Response for "/bapenda/njkb/tahun?jenis=Mobil&merk=HONDA&model=BRIO&tipe=SATYA E CVT":
```json
{
  "pesan": "Sukses",
  "data": [
    2022
  ]
}
```

### [POST] Kalkulasi

Endpoint: /bapenda/njkb/kalkulasi

MANDATORY json body:
```json
{
  "jenis":"<jenis>",
  "merk":"<merk>",
  "model":"<model>",
  "tipe":"<tipe>",
  "tahun":"<tahun -> integer>"
}
```

Example Body:
```json
{
  "jenis":"Motor",
  "merk":"HONDA",
  "model":"BEAT",
  "tipe":"CBS ISS",
  "tahun":2021
}
```

Response with Example Body:
```json
{
  "pesan": "Sukses",
  "data": {
    "njkb": 12000000,
    "estimasi": [
      {
        "jenis_plat": "hitam",
        "label": "Umum/Pribadi",
        "pkb": 180000,
        "opsen": 118800
      },
      {
        "jenis_plat": "kuning",
        "label": "Angkutan Umum",
        "pkb": 90000,
        "opsen": 59400
      },
      {
        "jenis_plat": "merah",
        "label": "Pemerintah",
        "pkb": 90000,
        "opsen": 59400
      }
    ],
    "bea_balik_nama": {
      "bbn1": 1440000,
      "opsen_bbn1": 950400,
      "bbn2": 120000
    }
  }
}
```