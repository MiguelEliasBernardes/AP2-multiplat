import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const MaterialApp(
      home: TelaPrincipal()
  ));
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  String? dadosQrcode;

  @override
  void dispose(){
    nomeController.dispose();
    emailController.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Semana da Computação 2026",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22
            ),
        ),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: nomeController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: "Nome do participante",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(color: Colors.teal.shade700),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(color: Colors.teal.shade700),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: nomeController.text.trim().isNotEmpty
                        ? (){
                          setState(() {
                            dadosQrcode = "CHECKIN|${nomeController.text.trim()}|${emailController.text.trim()}";
                          });
                        }
                        : null,


                    child: Text("Gerar ingresso", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      minimumSize: Size(400,50)
                    ),
                ),
                
                const SizedBox(height: 16),
                if (dadosQrcode != null)
                  Card(
                    elevation: 3,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Image.network(
                          "https://images.pexels.com/photos/13230484/pexels-photo-13230484.jpeg",
                          height: 80,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(nomeController.text,
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,)),
                                Text(emailController.text,
                                    style: const TextStyle(color: Colors.black54)),
                                const SizedBox(height: 8),
                                QrImageView(
                                  data: dadosQrcode!,
                                  version: QrVersions.auto,
                                  size: 200,
                                ),
                              ],
                            ),
                        )
                      ],
                    ),
                  ),

                const SizedBox(height: 16),
                Divider(height: 20,),

                const SizedBox(height: 16),
                Text("Check-in", textAlign: TextAlign.left,)
              ],
            ),
          ),
      )
    );
  }
}
