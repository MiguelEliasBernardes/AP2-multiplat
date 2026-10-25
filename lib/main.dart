import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
  bool _lendo = false;
  final List<String> presentes = [];
  String? resultado;
  String? nomeLido;

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
      body: _lendo ?
          _telaLeitura() :
        SingleChildScrollView(
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Check-in", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                  )
                ),

                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _lendo = true;
                    });
                  },
                  icon: const Icon(Icons.camera_alt_outlined  ),
                  label: Text("Ler ingresso", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.teal.shade700,
                    side: BorderSide(color: Colors.teal.shade700, width: 1.5),
                    elevation: 0,
                    shape: const StadiumBorder(),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),

                const SizedBox(height: 16),
                if (resultado != null) _cardResultado(),

                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Presentes (${presentes.length})",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                for (final nome in presentes)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(nome, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      )
    );
  }

  Widget _telaLeitura() {
    return Stack(
      children: [
        MobileScanner(
          onDetect: (capture) {
            if(!_lendo) return;
            final valor = capture.barcodes.firstOrNull?.rawValue;
            if(valor == null) return;

            setState(() {
              _lendo = false;

              final partes = valor.split("|");

              if(partes.length < 2 || partes[0] != "CHECKIN"){
                resultado = "Inválido";
                nomeLido = null;
              }else{
                nomeLido = partes[1];
                if(presentes.contains(nomeLido)){
                  resultado = "Repetido";
                }else{
                  presentes.add(nomeLido!);
                  resultado = "Ok";
                }
              }

            });
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Aponte para o QR Code do ingresso", style: TextStyle(color: Colors.white, fontSize: 16),),
                  TextButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 5,
                          minimumSize: Size(400,50)),
                      onPressed: () {
                        setState(() {
                          _lendo = false;
                        });
                      },
                      child: const Text("Cancelar", style: TextStyle(color: Colors.black),))
                ],
              ),
          ),
        )
      ],
    );
  }

  Widget _cardResultado() {
    Color cor;
    IconData icone;
    String titulo;

    if(resultado == "Ok") {
      cor = Colors.green;
      icone = Icons.check;
      titulo = "Check-in confirmado";
    }else if(resultado == "Repetido") {
      cor = Colors.orange;
      icone = Icons.warning_amber;
      titulo = "Já fez check-in";
    } else{
      cor = Colors.red;
      icone = Icons.close;
      titulo = "QRcode inválido";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: cor.withOpacity(0.08),
          border: Border.all(color: cor, width: 1.5),
          borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        children: [
          Icon(icone, color: cor, size: 32,),
          const SizedBox(width: 16,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: TextStyle(color: cor, fontSize: 18, fontWeight: FontWeight.bold)),
              if(nomeLido != null) Text(nomeLido!)
            ],
          )
        ],
      ),
    );
  }


}


