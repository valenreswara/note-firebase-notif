# Laporan

Penggunaan Firebase dan Awesome Notification

|Nama Service|Kegunaan|
|------------|---------|
|Firebase Auth|Untuk fitur autentikasi login|
|Firestore|Untuk menyimpan notes yang dibuat|
|Awesome Notifications|Untuk menampilkan notifikasi|

## Register Screen
![RegisterScreen](https://github.com/user-attachments/assets/7c0ca42c-e0bb-4fd7-8684-4a519d2be71a)
- Menggunakan 2 buah TextController untuk input email dan password yang akan didaftarkan
- Melakukan register menggunakan Firebase Auth melalui fungsi `FirebaseAuth.instance.createUserWithEmailAndPassword()`
- Jika sudah mempunyai akun, bisa menekan tombol "Login" untuk dipindah ke Login Screen

## Login Screen
![LoginScreen](https://github.com/user-attachments/assets/65be09d5-a37d-47fa-985a-c1a539d09da6)
- Menggunakan 2 buah TextController untuk input email dan password untuk login
- Melakukan login menggunakan Firebase Auth melalui fungsi `FirebaseAuth.instance.signInWithEmailAndPassword()`
- Jika belum mempunyai akun, bisa menekan tombol "Register" untuk dipindah ke Login Screen

## Note Screen
![Notes](https://github.com/user-attachments/assets/e77819f8-444b-412b-aa7e-a8352cd7ac26)

## Notification Screen
![Notification](https://github.com/user-attachments/assets/745c15c0-92ae-418a-81bf-4d2de700a7a7)

