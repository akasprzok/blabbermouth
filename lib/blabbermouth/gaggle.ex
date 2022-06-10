defmodule Blabbermouth.Gaggle do
  @moduledoc """
  A group of Blabbers.

  Initialize it like this:

  def start(_type, _args) do
    children =
    [
      {Blabbermouth.Gaggle, [
        {Blabbermouth.Log, 5_000, log_level: :error},
        {Blabbermouth.Log, 1_000, log_level: :info}
      ]}
    ]

  """

  use Supervisor

  @type blabbers :: list()

  def start_link(blabbers) do
    Supervisor.start_link(__MODULE__, blabbers)
  end

  @impl Supervisor
  def init(blabbers) do
    children =
      blabbers
      |> Enum.map(fn {blabber, interval, opts} -> {Blabbermouth, [blabber: blabber, interval: interval, opts: opts]} end)

      Supervisor.init(children, strategy: :one_for_one)
  end
end
