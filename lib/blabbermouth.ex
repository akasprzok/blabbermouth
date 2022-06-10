defmodule Blabbermouth do
  @moduledoc """
  Documentation for `Blabbermouth`.
  """

  use GenServer

  @typedoc """
  The interval in which Blabbermouth is to emit logs, in milliseconds.
  Can be expressed as an integer representing milliiseconds,
  or a function to call that will return an integer representing milliseconds.
  Examples:
    :timer.seconds(1)
    {Enum, :random, [100..10000]}
  """
  @type interval :: integer() | {term(), term(), term()}

  # 1 second
  @default_interval 1_000

  @typedoc """
  Represents Blabbermouth's internal state.
  """
  @type t :: %__MODULE__{
    interval: interval(),
    blabber: module(),
    opts: Keyword.t()
  }

  @default_blabber Blabbermouth.Log

  defstruct [:interval, :blabber, :opts]

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    interval = opts |> Keyword.get(:interval, @default_interval)
    blabber = opts |> Keyword.get(:blabber, @default_blabber)
    blabber_opts = opts |> Keyword.get(:opts, [])

    state = %__MODULE__{
      interval: interval,
      blabber: blabber,
      opts: blabber_opts
    }

    schedule(state.interval)

    {:ok, state}
  end

  @impl true
  def handle_info(:blab, state) do
    state.blabber.blab(state.opts)

    schedule(state.interval)

    {:noreply, state}
  end

  defp schedule({module, function_name, args}) do
    module |> apply(function_name, args) |> schedule()
  end

  defp schedule(interval) when is_integer(interval) do
    Process.send_after(self(), :blab, interval)
  end
end
