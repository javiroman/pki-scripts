# When an application (eg, a web browser) tries to verify a certificate signed
# by the intermediate CA, it must also verify the intermediate certificate
# against the root certificate. To complete the chain of trust, create a CA
# certificate chain to present to the application.

# To create the CA certificate chain, concatenate the intermediate and root
# certificates together. We will use this file later to verify certificates
# signed by the intermediate CA.

cat CA-Intermediate/certs/intermediate.cert.pem \
    CA-Root/certs/ca.cert.pem > CA-Intermediate/certs/ca-chain.cert.pem

echo "Creating certificate chain bundle ..."
# Our certificate chain file must include the root certificate because no
# client application knows about it yet. A better option, particularly if
# you’re administrating an intranet, is to install your root certificate on
# every client that needs to connect. In that case, the chain file need only
# contain your intermediate certificate.
