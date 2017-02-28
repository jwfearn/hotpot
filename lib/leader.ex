defmodule HotPot.Leader do
  use GenServer

  def start_link do
    {:ok, pid} = GenServer.start_link(__MODULE__, [])
    :global.register_name(:hotpot_leader, pid)
    {:ok, pid}
  end

  def handle_cast({:register, pid}, state) do
    state = [pid] ++ state
    {:noreply, state}
  end

  def distribute(module) do
    code = :code.get_object_code(module)

  end

end
