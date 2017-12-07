# To create an intermediate certificate, use the root CA with the
# v3_intermediate_ca extension to sign the intermediate CSR. The intermediate
# certificate should be valid for a shorter period than the root certificate.
# Ten years would be reasonable.

# Warning: This time, specify the root CA configuration file 
# (CA-Root/openssl.cnf).

pushd CA-Root

openssl ca -config openssl.cnf -extensions v3_intermediate_ca \
    -days 3650 -notext -md sha256 \
    -in ../CA-Intermediate/csr/intermediate.csr.pem \
    -out ../CA-Intermediate/certs/intermediate.cert.pem

popd

