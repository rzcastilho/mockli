defmodule Mockatron.Mock do
  use HTTPoison.Base

  def process_request_headers(headers) do
    [{"Authorization", "Bearer #{Helper.get_token()}"} | headers]
  end

  def process_request_options(options) do
    [{:timeout, 5_000}, {:recv_timeout, 120_000} | options]
  end

  def process_request_url(url) do
    Helper.get_server_string() <> "/v1/mockatron/mock" <> url
  end

  def process_response_headers(headers) do
    headers
    |> Enum.map(fn {key, value} -> {String.downcase(key), value} end)
  end
end
