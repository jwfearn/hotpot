defmodule HotPot.LiveStart do

  @save_folder "loaded"

  def load_modules do
    {:ok, new_bin} = File.read("foo.bin")
    {module, bin, path} = :erlang.binary_to_term(new_bin)
    :code.load_binary(module, path, bin)
  end
  
  def save_module(module_code) do
    binary = :erlang.term_to_binary(module_code)
    File.write("foo.bin", binary)
  end

end
