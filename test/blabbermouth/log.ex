defmodule Blabbermouth.LogTest do
  use ExUnit.Case
  doctest Blabbermouth.Log

  setup_all do
    Logger.configure_backend(Logger.TestBackend, callback_pid: self())
    :ok
  end

  describe "blab/1" do
    test "logs hard-coded values" do
      message = "message"
      metadata = [user_id: 123]
      level = :info
      assert_receive {^level, _gl, {Logger, ^message, _timestamp, ^metadata}}
    end
  end
end
