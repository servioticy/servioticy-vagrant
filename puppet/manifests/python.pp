class { 'python' :
    version    => 'system',
    pip        => true,
    dev        => false,
    virtualenv => true,
    gunicorn   => false    
}

