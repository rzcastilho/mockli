defmodule Mockatron.Plug.ProcessHeaders do
  import Plug.Conn

  @mockatron_target_protocol "mockatron-target-protocol"
  @mockatron_target_hostname "mockatron-target-hostname"
  @mockatron_target_port "mockatron-target-port"
  @host "host"

  def init(options), do: options

  def call(%{scheme: protocol, host: hostname, port: port} = conn, _opts) do
    conn
    |> put_req_header(@mockatron_target_protocol, Atom.to_string(protocol))
    |> put_req_header(@mockatron_target_hostname, hostname)
    |> put_req_header(@mockatron_target_port, Integer.to_string(port))
    |> put_req_header(@host, Helper.get_server["hostname"])
  end
end
