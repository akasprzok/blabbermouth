defmodule Blabbermouth.Blabber do
  @type opts :: Keyword.t()

  @callback blab(opts()) :: :ok
end
