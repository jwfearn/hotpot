defmodule Hotpot.LiveStart do # loads and saves binary files
  @save_folder "bin_cache/"

  def load_module({mod, bin, path}) do
    :code.load_binary(mod, path, bin)
  end

  def load_modules do
    bin_dir
    |> File.ls!
    |> Enum.each(&load_bin/1)
  end

  def save_module(module_code) do
    binary = :erlang.term_to_binary(module_code)
    {module, _, _} = module_code
    module
    |> bin_path
    |> File.write(binary)
  end

  defp bin_dir do
    File.mkdir_p(@save_folder)
    @save_folder
  end

  defp bin_path(module) do
    "#{bin_dir()}#{Macro.underscore(module)}.bin"
  end

  defp load_bin(filename) do
    IO.inspect("loading: #{filename}")
    {:ok, new_bin} = File.read(@save_folder <> filename)
    term = :erlang.binary_to_term(new_bin)
    load_module(term)
  end
end
