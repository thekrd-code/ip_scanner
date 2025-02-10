use strict;
use warnings;
use LWP::UserAgent;
use JSON;
use Socket;
use Net::DNS;



my $ip = shift || 'ipinfo.io';



my $ua  = LWP::UserAgent->new();
my $url = "http://ipinfo.io/$ip/json";




my $response = $ua->get($url);


if ($response->is_success) {
    my $json = decode_json($response->decoded_content);
    
    print "[+] IP Address  : $json->{ip}\n" if $json->{ip};
    print "[+] Hostname    : $json->{hostname}\n" if $json->{hostname};
    print "[+] City        : $json->{city}\n" if $json->{city};
    print "[+] Region      : $json->{region}\n" if $json->{region};
    print "[+] Country     : $json->{country}\n" if $json->{country};
    print "[+] Location    : $json->{loc}\n" if $json->{loc};
    print "[+] ISP         : $json->{org}\n" if $json->{org};
    print "[+] Postal Code : $json->{postal}\n" if $json->{postal};
    print "[+] Timezone    : $json->{timezone}\n" if $json->{timezone};
    print "[+] ASN         : $json->{asn}->{asn}\n" if $json->{asn}->{asn};
    print "[+] ASN Org     : $json->{asn}->{name}\n" if $json->{asn}->{name};
    print "[+] Carrier     : $json->{carrier}->{name}\n" if $json->{carrier}->{name};
    print "[+] Abuse Email : $json->{abuse}->{email}\n" if $json->{abuse}->{email};
    print "[+] Abuse Phone : $json->{abuse}->{phone}\n" if $json->{abuse}->{phone};

   

    my $hostname = gethostbyaddr(inet_aton($json->{ip}), AF_INET);

    print "[+] Reverse DNS : $hostname\n" if $hostname;
    


    my $resolver = Net::DNS::Resolver->new;
    my $query = $resolver->query("$json->{ip}.zen.spamhaus.org", "A");
    if ($query) {
        print "[+] Blacklist   : Detected on Spamhaus!\n";
    } else {
        print "[+] Blacklist   : Not found on Spamhaus.\n";
    }
    
} else {
    die "Failed to fetch IP info: " . $response->status_line . "\n";
}
