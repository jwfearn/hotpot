defmodule Hotpot.Leader do
  use GenServer

  def start_link do
    {:ok, pid} = GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
    :global.register_name(:hotpot_leader, pid)
    {:ok, pid}
  end

  def fetch_all do
    GenServer.call(__MODULE__, :fetch_all)
  end

  def handle_cast({:register, {node, pid}}, state) do
    state = Map.put(state, node, pid)
    {:noreply, state}
  end

  def handle_call(:fetch_all, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:ping, _from, state) do
    {:reply, :pong, state}
  end

  def distribute(module) do
    pids = GenServer.call(__MODULE__, :fetch_all)
    code = :code.get_object_code(module)
    Enum.each(pids, fn({_, pid}) ->
      GenServer.cast(pid, {:load, code})
    end)
  end
end
