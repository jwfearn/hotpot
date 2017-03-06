defmodule Hotpot.LiveStart do

  @save_folder "bin_cache/"

  def load_module({mod, bin, path}) do
    :code.load_binary(mod, path, bin)
  end

  def load_modules do
    File.ls!(@save_folder)
    |> Enum.each(fn(filename) ->
      IO.inspect("loading: " <> filename)
      {:ok, new_bin} = File.read(@save_folder <> filename)
      term = :erlang.binary_to_term(new_bin)
      load_module(term)
    end)
 end
  
  def save_module(module_code) do
    binary = :erlang.term_to_binary(module_code)
    {module, _, _} = module_code
    File.mkdir_p(@save_folder)
    File.write(@save_folder <> (module |> Macro.underscore) <> ".bin", binary)
  end

end
