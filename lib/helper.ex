defmodule Helper do
  alias DoIt.Commfig
  alias Mix.Tasks.X509.Gen.Selfsigned

  import Mix.Generator

  @token_key "token"
  @server_key "server"
  @certificate_key "certificate"

  @server_default %{
    "protocol" => "https",
    "hostname" => "www.mockatron.io",
    "port" => 443
  }

  #TODO: change to get platform specific hosts location
  @etc_hosts_file "/etc/hosts"
  @etc_hosts_begin "# Added by Mockli (Mockatron Client)"
  @etc_hosts_end "# End of Section"

  @etc_hosts_section_template """

  #{@etc_hosts_begin}
  127.0.0.1\t<%= Enum.join(hosts, " ") %>
  #{@etc_hosts_end}
  """

  def get_token(), do: Commfig.get(@token_key)
  def set_token(token), do: Commfig.set(@token_key, token)

  def get_server(), do: Commfig.get(@server_key) || @server_default
  def set_server(server), do: Commfig.set(@server_key, server)

  def get_certificate() do
    Commfig.get(@certificate_key)
    |> Map.to_list()
    |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
  end

  def set_certificate(hostnames) do
    {certificate, private_key} = Selfsigned.certificate_and_key(2048, "Self-Signed Mockatron Certificate", hostnames)

    keyfile = Path.join(Application.get_env(:do_it, DoIt.Commfig)[:dirname], "selfsigned_key.pem")
    certfile = Path.join(Application.get_env(:do_it, DoIt.Commfig)[:dirname], "selfsigned.pem")

    create_file(keyfile, X509.PrivateKey.to_pem(private_key), force: true)
    create_file(certfile, X509.Certificate.to_pem(certificate), force: true)

    Commfig.set(@certificate_key, %{password: "SECRET", certfile: certfile, keyfile: keyfile})
  end

  def get_server_string() do
    with %{"protocol" => protocol, "hostname" => hostname, "port" => port} <- get_server() do
      "#{protocol}://#{hostname}:#{port}"
    end
  end

  def configure_etc_hosts(hosts) do
    if hosts_section_defined?(), do: exclude_hosts_section()
    hosts
    |> Enum.filter(fn host -> !Enum.any?(["localhost", get_server()["hostname"]], fn h -> h == host end) end)
    |> Enum.filter(fn host -> !Regex.match?(~r/^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])(\.(?!$)|$)){4}$/, host) end)
    |> include_hosts_section()
  end

  def hosts_section_defined?() do
    match_expression = @etc_hosts_begin
    File.read!(@etc_hosts_file)
    |> String.split("\n")
    |> Enum.any?(
      fn
        ^match_expression -> true
        _ -> false
      end)
  end

  def exclude_hosts_section() do
    match_expression_begin = @etc_hosts_begin
    match_expression_end = @etc_hosts_end
    File.read!(@etc_hosts_file)
    |> String.split("\n")
    |> Enum.reduce(
      {[], true},
      fn
        line, {file, _keep} when line == match_expression_begin ->
          {file, false}
        line, {file, keep} when line == match_expression_end and not keep ->
          {file, true}
        line, {file, keep} when keep ->
          {file ++ [line], keep}
        _line, {file, keep} ->
          {file, keep}
      end
    )
    |> elem(0)
    |> Enum.join("\n")
    |> String.trim()
    |> (&File.write!(@etc_hosts_file, &1)).()

  end

  def include_hosts_section(hosts) do
    File.read!(@etc_hosts_file) <>
    EEx.eval_string(@etc_hosts_section_template, [hosts: hosts])
    |> (&File.write!(@etc_hosts_file, &1)).()
  end

end
