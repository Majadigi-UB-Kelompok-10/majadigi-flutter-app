# JSON Structure for Page/Services List (Homepage) Taken from Supabase
- Array JSON starts with "[" (Square Bracket)
  - In dart, use List<dynamic>
- Object List starts with "{" (Curly Bracket)
  - In dart, use Map<String, dynamic>

Specifically for additional_data, there is a fixed structure
which is "policies", "services", and "operationals" with each
resolve to a Map<String, dynamic> and having a tab of their own

```
[
    {
        "id": "<id>",
        "icon": "<icon>",
        "title": "<title>",
        "description": "<description>",
        "additional_data": {
            "images": [...],
            "policies": {...},
            "services": {...},
            "operationals": {...},
        },
    }
]
```