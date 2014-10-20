augeas { 'change-tomcat-port' :
  incl    => '/etc/tomcat7/server.xml',
  lens    => 'Xml.lns',
  context => '/etc/tomcat7/server.xml/Server/Service/',
  changes => [
    "set Connector/#attribute/port 8081"
  ],
}