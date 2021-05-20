defmodule Mockli.Command.Config do
  @moduledoc """
  defmodule Mockli.Config do
    @moduledoc false

    def protocol do
      "http"
    end

    def host do
      "localhost"
    end

    def port do
      4000
    end

    def server do
      "\#{protocol()}://\#{host()}:\#{port()}"
    end

    def token do
      "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJtb2NrYXRyb24iLCJleHAiOjE2MDIyOTI1ODEsImlhdCI6MTU5OTg3MzM4MSwiaXNzIjoibW9ja2F0cm9uIiwianRpIjoiODk1YWFmYmMtMmQ2Ny00NDM0LTlhZDEtMThhZjdkZmFkYjAwIiwibmJmIjoxNTk5ODczMzgwLCJzdWIiOiIxIiwidHlwIjoiYWNjZXNzIn0.5klhftWTIrshixYtJOnY2SThHg4O25SRWbl0jZRgTfItMTGfkQs-wQYCxtoL72nTQHc5FkumcnO47570MEjKXg"
    end

    def certificate do
      [
        password: "SECRET",
        certfile: "/Users/castilho/elixir/src/github.com/rzcastilho/mockli/priv/cert/selfsigned.pem",
        keyfile: "/Users/castilho/elixir/src/github.com/rzcastilho/mockli/priv/cert/selfsigned_key.pem"
      ]
    end

  end
  """

  use DoIt.Command,
    description: "Modify mockli config file"

  option(:protocol, :string, "Modify mockatron server protocol",
    allowed_values: ["http", "https"],
    default: "https"
  )

  option(:hostname, :string, "Modify mockatron server hostname", default: "www.mockatron.io")

  option(:port, :integer, "Modify mockatron server port", default: 443)

  def run(_, %{protocol: protocol, hostname: hostname, port: port}, _) do
    Helper.set_server(%{"protocol" => protocol, "hostname" => hostname, "port" => port})
  end
end
