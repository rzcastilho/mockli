defmodule Mockatron.Plug.BuildRequest do
  import Plug.Conn

  def init(options), do: options

  def call(
        %{
          method: method,
          request_path: request_path,
          req_headers: req_headers,
          query_string: query_string
        } = conn,
        _opts
      ) do
    case read_body(conn) do
      {:ok, body, _} ->
        conn
        |> assign(
          :request,
          %HTTPoison.Request{
            method: method |> String.downcase() |> String.to_atom(),
            headers: req_headers,
            url: request_path,
            body: body
          }
        )

      _ ->
        conn
        |> assign(
          :request,
          %HTTPoison.Request{
            method: method |> String.downcase() |> String.to_atom(),
            headers: req_headers,
            url: request_path
          }
        )
    end
  end
end
