# Aplikasi Monitoring Sumber Daya Virtual Server Berbasis Android

Project ini dibangun dengan basis flutter pada mobile apps nya. Adapun untuk API yang digunakan adalah Python dengan framework Flask. Data yang dimonitoring adalah virtual server yang dibuat didalam proxmox yang mana proxmox juga menyediakan Endpoint. Dari Endpoint tersebut API mengambil data lalu melemparnya sebagai response yang kemudian di tangkap oleh aplikasi mobile untuk di atur penggunaan datanya.

## Getting Started

Project ini memiliki 1 server utama yang harus berjalan. Didalam server tersebut terdapat UWSGI-Emperor yang berguna untuk menjalankan API dari flask sebagai service. Servernya menggunakan Nginx sebagai webserver
Kemudian terdapat 1 atau lebih server yang harus menyala juga (terinstall proxmox dan punya VM dan container didalamnya) sebagai uji coba untuk aplikasinya
Selanjutnya barulah aplikasi dapat dijalankan dengan mengambil BASE_URL dari server yang bertindak sebagai API tadi.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [UWSGI-Emperor: To understand what UWSGI-Emperor is](https://chriswarrick.com/blog/2016/02/10/deploying-python-web-apps-with-nginx-and-uwsgi-emperor/)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
