
# Flutter x Laravel Todo App(Flutodo)

## Deskripsi Aplikasi

Aplikasi ini adalah sistem manajemen tugas (Todo List) yang menggunakan Flutter untuk frontend dan Laravel sebagai backend API.  
Fitur utama meliputi:  
- Halaman Login dan Registrasi  
- Halaman Dashboard menampilkan daftar tugas  
- CRUD tugas (Create, Read, Update, Delete) via API Laravel  
- Sinkronisasi data dengan database MySQL di backend  

Database yang digunakan adalah MySQL, dengan API RESTful yang dibuat menggunakan Laravel.

---

## Software yang Digunakan

- Laravel 11
- PHP 8.2 
- MySQL  
- Flutter   
- Dart  
- Composer  
- Visual Studio Code 

---

## Cara Instalasi

1. Clone repositori  
   ```bash
   git clone https://github.com/helios-byte/fluter-x-laravel.git
   ```  
2. Setup Backend Laravel  
   ```bash
   cd fluter-x-laravel/backend
   composer install
   cp .env.example .env
   php artisan key:generate
   ```
3. Konfigurasi file `.env` untuk koneksi database MySQL kamu  
4. Jalankan migrasi database  
   ```bash
   php artisan migrate
   ```
5. Jalankan server Laravel  
   ```bash
   php artisan serve
   ```
6. Setup Frontend Flutter  
   ```bash
   cd ../frontend
   flutter pub get
   flutter run -d chrome --web-port=59106
   ```

---

## Cara Menjalankan

- Jalankan backend Laravel dengan:  
  ```bash
  php artisan serve
  ```
- Jalankan aplikasi Flutter dengan:  
  ```bash
  flutter run
  ```
- Pastikan backend sudah berjalan sebelum menjalankan Flutter agar API dapat diakses.

---

## Demo

Berikut adalah demo singkat penggunaan aplikasi:  




https://github.com/user-attachments/assets/bfebcdd0-636b-48da-88a1-4ec5a9037a99




---

## Identitas Pembuat

Nama: Bambang Hokito
Kelas: XI RPL 2
Absen: 06

---
