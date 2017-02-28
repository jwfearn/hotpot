defmodule Hotpot do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = children_workers(Application.get_env(:hotpot, :role))

    opts = [strategy: :one_for_one, name: Hotpot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp children_workers(:leader) do
    [
      worker(Hotpot.Leader, [])
    ]
  end

  defp children_workers(:follower) do
    [
      worker(Hotpot.Slave, [Application.get_env(:hotpot, :leader)])
    ]
  end

end
