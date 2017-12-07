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
echo "Creating the Server Cerfificate .... "
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
