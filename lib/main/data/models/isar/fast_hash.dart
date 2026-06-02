// This was legacy fast hash to turn string into id
// but due to bug in codebase using unique and replace index
// this is not recommended to be used anywhere.

// It is however still used at some part of the codebase
// with a workaround that fast hash is computed during
// data insertion/update instead of through getter in
// deferred modules "Bansos"

/// FNV-1a 64bit hash algorithm to convert UUID to Isar Id
int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash;
}