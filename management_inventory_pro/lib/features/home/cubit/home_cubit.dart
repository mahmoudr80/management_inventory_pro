import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void navigate(int index){
    if(index!=state.currentIndex){
      emit(NavigateState(index));

    }
  }
}
