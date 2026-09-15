import 'package:flutter/material.dart';

void main() {
  runApp(const TarefasDomesticasApp());
}

class TarefasDomesticasApp extends StatelessWidget {
  const TarefasDomesticasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tarefas Domésticas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final List<Tarefa> tarefas = [
    Tarefa(nome: 'Lavar a louça', horario: '08:00', concluida: true),
    Tarefa(nome: 'Varrer a casa', horario: '10:00'),
    Tarefa(nome: 'Lavar roupa', horario: '14:00'),
    Tarefa(nome: 'Organizar o quarto', horario: '17:00'),
  ];

  int get tarefasConcluidas =>
      tarefas.where((tarefa) => tarefa.concluida).length;

  void alternarTarefa(int index) {
    setState(() {
      tarefas[index].concluida = !tarefas[index].concluida;
    });
  }

  void adicionarTarefa() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova tarefa'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nome da tarefa',
              hintText: 'Ex.: Limpar a cozinha',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    tarefas.add(
                      Tarefa(
                        nome: controller.text.trim(),
                        horario: 'A definir',
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tarefas Domésticas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResumo(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tarefas de hoje',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$tarefasConcluidas/${tarefas.length} concluídas',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: tarefas.isEmpty
                  ? _buildEstadoVazio()
                  : ListView.separated(
                      itemCount: tarefas.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _buildTarefa(tarefas[index], index);
                      },
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: adicionarTarefa,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar tarefa'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumo() {
    final percentual =
        tarefas.isEmpty ? 0.0 : tarefasConcluidas / tarefas.length;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.home_outlined,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Organização da casa',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    tarefas.isEmpty
                        ? 'Nenhuma tarefa cadastrada.'
                        : 'Você concluiu ${(percentual * 100).round()}% das tarefas.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarefa(Tarefa tarefa, int index) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: tarefa.concluida,
          onChanged: (_) => alternarTarefa(index),
        ),
        title: Text(
          tarefa.nome,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration:
                tarefa.concluida ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.access_time, size: 16),
            const SizedBox(width: 5),
            Text(tarefa.horario),
          ],
        ),
        trailing: Icon(
          tarefa.concluida ? Icons.check_circle : Icons.radio_button_unchecked,
          color: tarefa.concluida
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildEstadoVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.cleaning_services_outlined, size: 60),
          SizedBox(height: 12),
          Text(
            'Tudo em ordem!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text('Adicione uma tarefa para começar.'),
        ],
      ),
    );
  }
}

class Tarefa {
  Tarefa({
    required this.nome,
    required this.horario,
    this.concluida = false,
  });

  final String nome;
  final String horario;
  bool concluida;
}
