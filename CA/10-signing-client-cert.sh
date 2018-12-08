# Use the private key to create a certificate signing request (CSR). The CSR
# details don’t need to match the intermediate CA. For server certificates, the
# Common Name must be a fully qualified domain name (eg, www.example.com),
# whereas for client certificates it can be any unique identifier (eg, an
# e-mail address). Note that the Common Name cannot be the same as either your
# root or intermediate certificate.

pushd CA-Intermediate

openssl genrsa -out private/client1.key 2048

echo
echo "Creating a Client cerfificate signing request (CSR).... "
echo

openssl req \
    -config openssl-intermediate.cnf \
    -key private/client1.key \
    -new -sha256 -out csr/client1.csr

echo
echo "Creating the Client Cerfificate [you have to change the information!!!].... "
echo

openssl ca \
    -config openssl-intermediate.cnf \
    -extensions usr_cert \
    -days 375 \
    -notext \
    -md sha256 \
    -in csr/client1.csr \
    -out certs/client1.cert.pem

popd
