import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/model/host_model.dart';
import 'package:shoes_app/providers/host_provider.dart';
import 'package:shoes_app/theme/const.dart';
import 'package:shoes_app/widgets/host_tile.dart';

class HostPage extends StatefulWidget {
  const HostPage({super.key});

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  static TextEditingController ipAddressController =
      TextEditingController(text: '');
  static TextEditingController portController = TextEditingController(text: '');
  static TextEditingController usernameController =
      TextEditingController(text: '');
  static TextEditingController passwordController =
      TextEditingController(text: '');

  bool isLoading = false;

  late String ipAddress;
  late String port;
  late String username;
  late String password;

  HostModel? selectedHost;

  @override
  void initState() {
    super.initState();
    Provider.of<HostProvider>(context, listen: false).getHosts();
  }

  @override
  Widget build(BuildContext context) {
    HostProvider hostProvider = Provider.of<HostProvider>(context);

    bool showFAB = hostProvider.hostList.isNotEmpty;

    handleRegister() async {
      setState(() {
        isLoading = true;
      });

      if (await hostProvider.registerHosts(
        ipAddress: ipAddressController.text,
        port: portController.text,
        username: usernameController.text,
        password: passwordController.text,
      )) {
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/host-info');
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: alertColor,
            content: Text(
              'Register Failed',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }

    handleUpdate(int id, String ipAddress, String port, String username, String password) async {
      setState(() {
        isLoading = true;  // Menunjukkan bahwa proses sedang berlangsung
      });

      // Panggil fungsi update pada provider
      if (await hostProvider.updateHost(
        hostId: id,  // Mengirim id host untuk update
        ipAddress: ipAddress,
        port: port,
        username: username,
        password: password,
      )) {
        // Jika update berhasil, navigasi ke halaman informasi host
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/host-info');
      } else {
        // Jika update gagal, tampilkan snackbar error
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: alertColor,
            content: Text(
              'Update Failed',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }


    void handleLogin(
      String ipAddress,
      String port,
      String username,
      String password,
    ) async {
      if (selectedHost == null) {
        return;
      }

      setState(() {
        isLoading = true;
      });

      bool loginSuccessful =
          await Provider.of<HostProvider>(context, listen: false).loginHosts(
        ipAddress: selectedHost!.ipAddress!,
        port: selectedHost!.port!,
        username: username,
        password: password,
      );

      if (loginSuccessful) {
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/host-info');
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: alertColor,
            content: Text(
              'Login Failed',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }

    Widget ipAddressInput({TextEditingController? controller}) {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'IP Address',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: bg2Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/IP Icon.png',
                      width: 17,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            ipAddress = value;
                          });
                        },
                        style: primaryTextStyle,
                        controller: ipAddressController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your IP Address',
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget portInput({TextEditingController? controller}) {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Port',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: bg2Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/IP Icon.png',
                      width: 17,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            port = value;
                          });
                        },
                        style: primaryTextStyle,
                        controller: portController,
                        decoration: InputDecoration.collapsed(
                          hintText: '8006',
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Default port: 8006',
              style: primaryTextStyle.copyWith(
                fontSize: 10,
                fontWeight: medium,
                color: alertColor,
              ),
            ),
          ],
        ),
      );
    }

    Widget usernameInput({TextEditingController? controller}) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: bg2Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/Username_Icon.png',
                      width: 17,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                        style: primaryTextStyle,
                        controller: usernameController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Username',
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget passwordInput({TextEditingController? controller}) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: bg2Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/Password_Icon.png',
                      width: 17,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        style: primaryTextStyle,
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Password',
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Future<void> registerDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
          width: 320,
          child: AlertDialog(
            backgroundColor: bg3Color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  ipAddressInput(),
                  portInput(),
                  usernameInput(),
                  passwordInput(),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 320,
                    height: 44,
                    child: TextButton(
                      onPressed: handleRegister,
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    void updateDialog(int id) async {
      // Mengambil data host berdasarkan id melalui provider
      await Provider.of<HostProvider>(context, listen: false).getHostById(id);
      
      // Mendapatkan host yang telah diambil dari provider
      HostModel? host = Provider.of<HostProvider>(context, listen: false).host;

      // Jika host tidak ditemukan atau data belum tersedia, tampilkan pesan error atau keluar
      if (host == null) {
        print("Host not found or data is still loading");
        return;
      }

      // Inisialisasi controller dengan nilai dari host yang akan diupdate
      final TextEditingController ipController = TextEditingController(text: host.ipAddress);
      final TextEditingController portController = TextEditingController(text: host.port);
      final TextEditingController usernameController = TextEditingController(text: host.username);
      final TextEditingController passwordController = TextEditingController(text: host.password);
      
      // Menampilkan dialog setelah data host tersedia
      showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
          width: 320,
          child: AlertDialog(
            backgroundColor: bg3Color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  ipAddressInput(controller: ipController),
                  portInput(controller: portController),
                  usernameInput(controller: usernameController),
                  passwordInput(controller: passwordController),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 320,
                    height: 44,
                    child: TextButton(
                      onPressed: () => handleUpdate(
                        id, // Mengirimkan id host untuk update
                        ipController.text,
                        portController.text,
                        usernameController.text,
                        passwordController.text,
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Update',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }


    void deleteDialog(HostModel host) {
      // Tampilkan dialog konfirmasi delete
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Delete Host: ${host.ipAddress}'),
          content: Text('Are you sure you want to delete this host?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Logic delete
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        ),
      );
    }

    Future<void> loginDialog(String ipAddress, String port) async {
      print('Login Dialog called for host: ${selectedHost!.ipAddress}');
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: bg3Color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                // Display selected host information here
                Text(
                  '${selectedHost!.ipAddress}:${selectedHost!.port}',
                  style: primaryTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: regular,
                  ),
                ),
                usernameInput(),
                passwordInput(),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 320,
                  height: 44,
                  child: TextButton(
                    onPressed: () {
                      handleLogin(
                        ipAddress,
                        port,
                        usernameController.text,
                        passwordController.text,
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: primaryTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: bg1Color,
        centerTitle: true,
        title: Text(
          'Host',
          style: primaryTextStyle,
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      );
    }

    Widget content(List<HostModel> hostList) {
      print('Host List Length: ${hostList.length}');

      return ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        itemCount: hostList.length,
        itemBuilder: (context, index) {
          final host = hostList[index];

          // Print the type of data for each attribute of the host
          print('Type of host.ipAddress: ${host.ipAddress.runtimeType}');
          print('Type of host.port: ${host.port.runtimeType}');
          print('Type of host.usernameFromProxmox: ${host.usernameFromProxmox.runtimeType}');

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedHost = host;
              });
              print('Host tapped: ${host.ipAddress}');
              loginDialog(host.ipAddress!, host.port!);
            },
            child: HostTile(
              host,
              onEdit: () => updateDialog(host.id!),
              onDelete: () => deleteDialog(host),
            ),
          );
        },
      );
    }

    Widget emptyCart() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Host.png',
              width: 80,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Belum ada Host',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Mari masukkkan host yang\ningin di pantau',
              style: secondaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              width: 154,
              height: 44,
              margin: const EdgeInsets.only(
                top: 20,
              ),
              child: TextButton(
                onPressed: () {
                  registerDialog();
                },
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Register Host',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg3Color,
      appBar: header(),
      body: hostProvider.hostList.isEmpty
          ? emptyCart()
          : content(hostProvider.hostList),
      floatingActionButton: showFAB
          ? FloatingActionButton(
              onPressed: () {
                registerDialog();
              },
              backgroundColor: primaryColor,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white,),
            )
          : null,
    );
  }
}
