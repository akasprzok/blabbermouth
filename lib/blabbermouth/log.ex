defmodule Blabbermouth.Log do
  @behaviour Blabbermouth.Blabber

  require Logger

  @type log_level :: :debug | :info | :warn | :error | :random

  @log_levels [
    :debug,
    :info,
    :warn,
    :error
  ]

  @default_level :random

  @impl Blabbermouth.Blabber
  def blab(opts) do
    level = opts |> Keyword.get(:level, @default_level) |> level()

    Logger.log(level, "message")
  end

  defp level(:random) do
    @log_levels |> Enum.random()
  end
  defp level(level), do: level

end
