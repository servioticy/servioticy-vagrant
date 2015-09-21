elasticsearch::plugin{ 'transport-couchbase':
  module_dir => 'transport-couchbase',
  url        => 'http://packages.couchbase.com.s3.amazonaws.com/releases/elastic-search-adapter/2.1.1/elasticsearch-transport-couchbase-2.1.1.zip',
  instances  => 'serviolastic',
  require  => [ Package["git"], Package['oracle-java7-installer']]
}
