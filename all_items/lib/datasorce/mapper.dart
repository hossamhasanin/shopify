abstract class Mapper<D, Model> {
  Model toModel(D data);
  D toDataClass(Model model);
}
