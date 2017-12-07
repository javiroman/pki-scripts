pushd CA-Intermediate

openssl x509 -noout -text \
    -in certs/intermediate.cert.pem 

# Verify the intermediate certificate against the root certificate. An OK
# indicates that the chain of trust is intact.

echo
echo "Verifing the Intermediate cert with the Root cert: "
echo 
openssl verify \
    -CAfile ../CA-Root/certs/ca.cert.pem \
    certs/intermediate.cert.pem

popd
