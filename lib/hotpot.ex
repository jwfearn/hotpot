defmodule Hotpot do
  use Application
  import Supervisor.Spec, warn: false

  @infinity 999_999_999_999

  def start(_type, _args) do
    children_workers(Application.get_env(:hotpot, :role))
    |> Supervisor.start_link(
        strategy: :one_for_all,
        name: Hotpot.Supervisor,
        max_restarts: @infinity,
        max_seconds: @infinity
      )
  end

  defp children_workers(:leader) do
    [
      worker(Hotpot.Leader, [], restart: :permanent)
    ]
  end

  defp children_workers(:follower) do
    leader = Application.get_env(:hotpot, :leader)
    [
      worker(Hotpot.Follower, [leader], restart: :permanent)
    ]
  end
end
