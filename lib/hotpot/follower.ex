defmodule Hotpot.Follower do
  use GenServer

  alias Hotpot.LiveStart

  def start_link(leader_node) do
    IO.inspect "starting follower"
    Node.connect(leader_node)
    :timer.sleep(1000) #ensure connection
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_params) do
    leader_pid = :global.whereis_name(:hotpot_leader)
    GenServer.cast(leader_pid, {:register, self})

    {:ok, task} = Task.start_link(fn() ->
      ping_leader(leader_pid)
    end)
    {:ok, nil}   
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
