defmodule Mockatron.Pipeline do
  use Plug.Builder

  plug(Plug.Logger, log: :info)
  plug(Mockatron.Plug.ProcessHeaders)
  plug(Mockatron.Plug.BuildRequest)
  plug(Mockatron.Plug.InvokeMock)
end
