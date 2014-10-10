curl -XDELETE 'http://localhost:9200/soupdates/'
curl -XDELETE 'http://localhost:9200/subscriptions/'

curl -XPUT 'http://localhost:9200/soupdates/' -d '{
    "mappings": {
        "couchbaseCheckpoint": {
            "dynamic": "true",
            "_source": {
                "includes": [
                    "doc.*"
                ]
            },
            "dynamic_templates": [
                {
                    "store_no_index": {
                        "match": "*",
                        "mapping": {
                            "store": "no",
                            "index": "no",
                            "include_in_all": false
                        }
                    }
                }
            ]
        },
        "couchbaseDocument": {
            "_all": {
                "enabled": false
            },
            "dynamic": "true",
            "_source": {
                "includes": [
                    "meta.*"
                ]
            },
            "dynamic_templates": [
                {
                    "lastUpdates_are_date": {
                        "path_match": "doc.lastUpdate",
                        "mapping": {
                            "index": "not_analyzed",
                            "type": "date"
                        }
                    }
                },
                {
                    "locations_are_geojson": {
                        "path_match": "doc.channels.location.current-value",
                        "mapping": {
                            "store": "no",
                            "index": "not_analyzed",
                            "type": "geo_point"
                        }
                    }
                },
                {
                    "current-value_are_strings": {
                        "path_match": "doc.channels.*.current-value",
                        "mapping": {
                            "store": "no",
                            "index": "not_analyzed",
                            "type": "string"
                        }
                    }
                }
            ],
            "properties": {
                "meta": {
                    "properties": {
                        "id": {
                            "type": "string",
                            "analyzer": "whitespace"
                        }
                    }
                }
            }
        }
    }
}'

curl -XPUT 'http://localhost:9200/subscriptions/' -d '{
   "mappings": {
        "couchbaseCheckpoint": {
            "dynamic": "true",
            "_source": {
                "includes": [
                    "doc.*"
                ]
            },
            "dynamic_templates": [
                {
                    "store_no_index": {
                        "match": "*",
                        "mapping": {
                            "store": "no",
                            "index": "no",
                            "include_in_all": false
                        }
                    }
                }
            ]
        },
        "couchbaseDocument": {
            "_all": {
                "enabled": false
            },
            "dynamic": "true",
            "_source": {
                "includes": [
                    "meta.*"
                ]
            },
            "dynamic_templates": [
                {
                    "all_strings_to_avoid_collisions": {
                        "match": "*",
                        "mapping": {
                            "store": "no",
                            "index": "not_analyzed",
                            "include_in_all": false,
                            "type": "string",
                            "analyzer": "whitespace"
                        }
                    }
                }
            ],
            "properties": {
                "doc": {
                    "properties": {
                        "callback": {
                            "type": "string"
                        },
                        "source": {
                            "type": "string"
                        },
                        "destination": {
                            "type": "string"
                        },
                        "stream": {
                            "type": "string"
                        },
                        "customFields": {
                            "enabled": false
                        }
                    }
                },
                "meta": {
                    "properties": {
                        "id": {
                            "type": "string",
                            "analyzer": "whitespace"
                        }
                    }
                }
            }
        }
    }
}'
