#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;

use Getopt::Long;
use JSON;
use WWW::Mechanize;

INIT {
    # Read vault settings from environment.
    my $vault_addr = $ENV{VAULT_ADDR};
    my $vault_kv_secret = $ENV{VAULT_KV_SECRET};
    my $vault_role_id = $ENV{VAULT_ROLE_ID};
    my $vault_secret_id = $ENV{VAULT_SECRET_ID};

    delete $ENV{VAULT_ADDR};
    delete $ENV{VAULT_KV_SECRET};
    delete $ENV{VAULT_ROLE_ID};
    delete $ENV{VAULT_SECRET_ID};

    my $ua = WWW::Mechanize->new;

    my $vault_url = sprintf '%s/v1/auth/approle/login', $vault_addr;
    my $content = encode_json {role_id => $vault_role_id, secret_id => $vault_secret_id};
    my $res = $ua->post($vault_url, 'Content-Type' => 'application/json', Content => $content);

    my $token = decode_json($res->content)->{auth}->{client_token};
    $ua->default_header('X-Vault-Token' => $token);

    $vault_url = sprintf '%s/v1/kv/data/%s', $vault_addr, $vault_kv_secret;
    $res = $ua->get($vault_url);

    # Pollute variables to our environment.
    my $data = decode_json($res->content)->{data}->{data};
    while (my ($k, $v) = each %$data) {
        $ENV{$k} = $v;
    }

    # Run the process.
    GetOptions();
    exec @ARGV;
}

__END__
