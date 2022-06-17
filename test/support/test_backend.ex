defmodule Blabbermouth.TestBackend do
  @moduledoc """
  A module that implements a custom `Logger` backend for use in testing.
  This module can be used to verify events sent to `Logger`.
  """

  @behaviour :gen_event

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:configure, opts}, state) do
    callback_pid = Keyword.get(opts, :callback_pid)
    {:ok, :ok, Map.put(state, :callback_pid, callback_pid)}
  end

  def handle_event(
        {_level, _gl, {Logger, _msg, _ts, _md}} = event,
        %{callback_pid: pid} = state
      ) do
    IO.inspect(event, label: "event")
    send(pid, event)
    {:ok, state}
  end

  def handle_event(_, state) do
    {:ok, state}
  end

  def handle_info(_, state) do
    {:ok, state}
  end

  def code_change(_old, state, _extra) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    :ok
  end
end
