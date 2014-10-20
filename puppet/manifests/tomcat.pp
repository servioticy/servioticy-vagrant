file_line { 'change_tomcat_port':
  path  => '/etc/tomcat7/server.xml',
  line  => '    <Connector port="8081" protocol="HTTP/1.1"',
  match => '^    <Connector port="8081"*',
  require => Package['tomcat7']
}

exec{ 'change-tomcat-port'":
    command = 'set /etc/tomcat7/server.xml/Server/Service/Connector[#attribute/name='port']/#text 8081',
}