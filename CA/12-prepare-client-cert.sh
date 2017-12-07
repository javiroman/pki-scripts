pushd CA-Intermediate

# Convert Client Key to PKCS, so that it may be installed in most browsers.
openssl pkcs12 \
    -export \
    -clcerts \
    -in certs/client1.cert.pem \
    -inkey private/client1.key \
    -out certs/client.p12

# Convert Client Key to (combined) PEM: Combines client.crt and client.key into 
# a single PEM file for programs using openssl.

openssl pkcs12 \
    -in certs/client.p12 \
    -out certs/client.pem \
    -clcerts

popd

