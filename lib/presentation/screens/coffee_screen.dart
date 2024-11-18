import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/coffee_bloc.dart';
import '../../injection_container.dart';

class CoffeeScreen extends StatelessWidget {
  const CoffeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coffee List')),
      body: BlocProvider(
        create: (_) => sl<CoffeeBloc>()..add(GetAllCoffeeEvent()),
        child: const CoffeeList(),
      ),
    );
  }
}

class CoffeeList extends StatelessWidget {
  const CoffeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoffeeBloc, CoffeeState>(
      builder: (context, state) {
        if (state is CoffeeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CoffeeLoaded) {
          return ListView.builder(
            itemCount: state.coffees.length,
            itemBuilder: (context, index) {
              final coffee = state.coffees[index];
              return ListTile(
                title: Text(coffee.title),
              );
            },
          );
        } else if (state is CoffeeError) {
          return Center(child: Text(state.error));
        } else {
          return Container();
        }
      },
    );
  }
}
