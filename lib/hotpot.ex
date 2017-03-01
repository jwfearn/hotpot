defmodule Hotpot do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = children_workers(Application.get_env(:hotpot, :role))

    opts = [strategy: :one_for_all, name: Hotpot.Supervisor, max_restarts: 999_999_999_999, max_seconds: 999_999_999_999]
    Supervisor.start_link(children, opts)
  end

  defp children_workers(:leader) do
    [
      worker(Hotpot.Leader, [], restart: :permanent)
    ]
  end

  defp children_workers(:follower) do
    [
      worker(Hotpot.Follower, [Application.get_env(:hotpot, :leader)], restart: :permanent)
    ]
  end

end
