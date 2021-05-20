defmodule Mockli.Command.Login do
  use DoIt.Command,
    description: "Log in to a Mockatron server"

  alias Mockatron.API

  option(:username, :string, "Mockatron server username", alias: :u)
  option(:password, :string, "Mockatron server password", alias: :p)

  def run(_, %{username: username, password: password}, _) do
    login(username, password)
  end

  def run(_, %{username: username}, _) do
    password = ExPrompt.password("Password: ")
    login(username, password)
  end

  def run(_, %{password: password}, _) do
    username = ExPrompt.get("Username: ")
    login(username, password)
  end

  def run(_, _, _) do
    username = ExPrompt.get("Username: ")
    password = ExPrompt.password("Password: ")
    login(username, password)
  end

  defp login(username, password) do
    case API.sign_in(username, password) do
      {:ok, jwt} ->
        Helper.set_token(jwt)
        IO.puts("Login Succeeded")
      {:error, %{code: code, error: error, message: message}} ->
        IO.puts("Error response from API.\n  * Code: #{code} - Error: #{error} - Message: #{message}")
    end
  end

end
