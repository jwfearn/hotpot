defmodule HotPot.Slave do
  use GenServer
  
  alias HotPot.LiveStart

  def start_link do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    leader_pid = :global.whereis_name(:hotpot_leader)
    GenServer.cast(leader_pid, {:register, pid})

    Task.start_link(fn() ->
      ping_leader(leader_pid)
    end)

    {:ok, pid}
  end

  def ping_leader(leader_pid) do
    GenServer.call(leader_pid, :ping)
    :timer.sleep(5000)
    ping_leader(leader_pid)
  end

  def handle_cast({:load, module}, _state) do
    Task.start_link(fn() -> load_and_save_module(module) end)
    {:noreply, nil}
  end

  def load_and_save_module(module) do
    LiveStart.load_module(module)
    LiveStart.save_module(module)
  end
end
