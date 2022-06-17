defmodule Blabbermouth.LogTest do
  use ExUnit.Case
  doctest Blabbermouth.Log

  import Blabbermouth.Log

  require Logger

  setup_all do
    {:ok, _pid} = Logger.add_backend(Blabbermouth.TestBackend)
    :ok
  end

  setup do
    Logger.configure_backend(Blabbermouth.TestBackend, callback_pid: self())
  end

  describe "blab/1" do
    test "logs hard-coded values" do
      message = "message"
      metadata = [user_id: 123]
      level = :info
      Logger.log(level, message, metadata)
      blab(level: level, message: message, metadata: metadata)
      assert_receive {_level, _gl, {Logger, _msg, _ts, _md}}
    end
  end
end
