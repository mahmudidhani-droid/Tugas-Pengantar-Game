# Panduan Bermain: Dungeon of Logic

## Tujuan

Jelajahi dungeon, pecahkan gerbang logika, kalahkan penjaga untuk memperoleh perlengkapan, lalu gunakan perlengkapan itu untuk membuka portal dan mengalahkan Core Guardian.

## Kontrol

| Aksi | Tombol |
|---|---|
| Bergerak | W, A, S, D atau tombol panah |
| Berinteraksi dengan saklar, NPC, atau portal terdekat | E atau Space |
| Menyerang | J atau klik kiri |

## Urutan permainan

1. **Buka gerbang AND.** Di ruang pertama, nyalakan Saklar A dan Saklar B. Gerbang AND terbuka hanya ketika keduanya ON (`1 AND 1 = 1`). Tekan tombol interaksi di dekat saklar.
2. **Kalahkan monster penjaga.** Di ruang atas, atur dua saklar penjaga sehingga tepat satu ON dan satu OFF. Ini membuat output XOR bernilai `1` dan mematikan perisai. Serang dengan J atau klik kiri hingga HP penjaga habis.
3. **Ambil perlengkapan.** Dekati loot yang dijatuhkan penjaga; perlengkapan akan terambil otomatis. Item ini menambah ATK dan memulihkan sebagian HP.
4. **Lewati jebakan NOT dan masuk portal.** Saklar NOT harus ON (`1`), sehingga output NOT menjadi `0` dan jebakan aman. Setelah memiliki perlengkapan, dekati portal dan tekan E atau Space.
5. **Kalahkan Core Guardian.** Perisai boss mengikuti rumus `(A AND B) XOR C`. Serang hanya saat output rumus `1`. Kombinasi termudah adalah A OFF, B OFF, C ON (`(0 AND 0) XOR 1 = 1`). Boss memiliki 150 HP; jika output kembali `0`, perisainya aktif lagi.

## Tips

- Berinteraksi hanya memengaruhi objek terdekat dalam jangkauan.
- Perhatikan status perisai dan nilai saklar yang ditampilkan di atas musuh/boss.
- Jika HP habis, kamu kembali ke titik awal ruangan dengan HP penuh. Kemajuan saklar dan perlengkapan tetap ada selama sesi permainan.
- Bicaralah dengan Profesor Logic untuk mendapatkan petunjuk puzzle.
