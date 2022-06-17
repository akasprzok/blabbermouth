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
  @default_messages [
    "I am a message",
    "Negative ghost rider, the pattern is full!",
    "I thought we'd be safe here",
    "Uh oh",
    "Error blabbing the blob"
  ]

  @default_metadata [
    integer: 1,
    float: 1.345,
    string: "string",
    atom: :atom,
    list: ["one", "two"],
    tuple: {"a", "b"}
  ]

  defp default_metadata do
    [pid: self(), ref: make_ref()] ++ @default_metadata
  end

  @impl Blabbermouth.Blabber
  def blab(opts \\ []) do
    level = opts |> Keyword.get(:level, @default_level) |> level()
    message = opts |> Keyword.get(:messages, @default_messages) |> message()
    metadata = opts |> Keyword.get(:metadata, default_metadata()) |> metadata()

    Logger.log(level, message, metadata)
  end

  defp level(:random) do
    @log_levels |> Enum.random()
  end

  defp level(level), do: level

  defp message(messages) when is_list(messages) do
    Enum.random(messages)
  end

  defp metadata(metadata) when is_list(metadata) do
    metadata
  end
end
