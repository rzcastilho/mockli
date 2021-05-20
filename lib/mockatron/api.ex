defmodule Mockatron.API do
  use HTTPoison.Base

  def process_request_body(body) do
    body
    |> Jason.encode!()
  end

  def process_request_headers(headers) do
    [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{Helper.get_token()}"} | headers
    ]
  end

  def process_request_url(url) do
    Helper.get_server_string() <> url
  end

  def process_response_body(body) do
    body
    |> Jason.decode!()
  end

  def sign_in(email, password) do
    case post!("/v1/mockatron/auth/sign_in", %{email: email, password: password}) do
      %HTTPoison.Response{body: %{"jwt" => jwt}} ->
        {:ok, jwt}

      %HTTPoison.Response{body: %{"code" => code, "error" => error, "message" => message}} ->
        {:error, %{code: code, error: error, message: message}}
    end
  end

  def get_agents() do
    case get!("/v1/mockatron/api/agents") do
      %HTTPoison.Response{body: %{"data" => agents}} ->
        agents

      _ ->
        []
    end
  end

  def get_listeners do
    get_agents()
    |> Enum.map(fn %{"port" => port, "protocol" => protocol} ->
      {String.to_atom(protocol), port}
    end)
    |> Enum.uniq()
  end

  def get_hosts do
    get_agents()
    |> Enum.map(fn %{"host" => host} -> host end)
    |> Enum.uniq()
  end
end
