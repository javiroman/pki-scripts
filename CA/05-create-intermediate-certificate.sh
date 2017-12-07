# Use the intermediate key to create a certificate signing request (CSR). The
# details should generally match the root CA. The Common Name, however, must be
# different.

# Warning: Make sure you specify the intermediate CA configuration file
# (CA-Intermediate/openssl-intermediate.cnf)

pushd CA-Intermediate

openssl req -config openssl-intermediate.cnf -new -sha256 \
    -key private/intermediate.key.pem \
    -out csr/intermediate.csr.pem

popd 
