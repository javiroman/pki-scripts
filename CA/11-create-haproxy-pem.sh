# PEM format, in order:
#
#-----BEGIN RSA PRIVATE KEY-----
# (Your private key which was used to request the primary ssl cert)
#-----END RSA PRIVATE KEY-----
#
#-----BEGIN MY CERTIFICATE-----
# (Your Primary SSL certificate: your_domain_name.crt) 
#-----END MY CERTIFICATE-----
#
#-----BEGIN INTERMEDIATE CERTIFICATE-----
# (Intermediate certificate:Let's Encrypt Authority X3 xxCA.crt) 
#-----END INTERMEDIATE CERTIFICATE-----
#
#-----BEGIN ROOT CERTIFICATE-----
# (Root certificate: DST Root CA X3) 
#-----END ROOT CERTIFICATE-----

pushd CA-Intermediate
cat private/admin.microserviceslab.com.key.pem \
    certs/admin.microserviceslab.com.cert.pem \
    certs/ca-chain.cert.pem | sudo tee certs/haproxy-joint.pem
popd


