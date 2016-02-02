def mw_server_base_relayhost(relayhost, port)
  if port
    "[#{relayhost}]:#{port}"
  else
    "[#{relayhost}]"
  end
end
