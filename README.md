# PKI Helper Scripts
public key infrastructure (PKI) helper scripts

# Setting Up a Certification Authority

We will set up a CA using OpenSSL's command line tools:

* create a self-signed root certificate for use by your CA
* build a configuration file that OpenSSL can use for your CA
* issue certificates and CRLs with your CA

# Setup root directory for our CA

Acting as a certificate authority (CA) means dealing with cryptographic pairs
of **private keys** and **public certificates** (with the **public key** part within).

The very first cryptographic pair we’ll create is the root pair. This consists 
of the **root key (ca.key.pem)** and **root certificate (ca.cert.pem)**. 

This pair forms the Identity of your CA.

* Note: PEM format, The standard format for OpenSSL and many other SSL tools.
This format is designed to be safe for inclusion in ascii or even rich-text
documents, such as emails. This means that you can simple copy and paste the
content of a pem file to another document and back. The name is from Privacy
Enhanced Mail (PEM), Defined in RFCs 1421 through 1424,

Typically, the root CA does not sign server or client certificates directly.
The root CA is only ever used to create one or more **Intermediate CAs**, which
are trusted by the root CA to sign certificates on their behalf. This is best
practice. It allows the root key to be kept offline and unused as much as
possible, as any compromise of the root key is disastrous.

# 00-create-environment.sh

* Create the Root CA configuration file and folders
* Create the Intermediate CA configuration file and folders

```
CA-Root/
├──── openssl.cnf ==> OpenSSL configuration file
├──── index.txt ==> database that keeps track of the certificates that have been issued by the CA
├──── serial ==> serial number that was used to issue a certificate. Initializated to 1.
├── certs/ ==> keep copies of all of the certificates that we issue with our CA.
├── crl/
├── csr/
├── newcerts/
└── private/ ==> keep a copy of the CA certificate's private key.

CA-Intermediate/
├──── openssl-intermediate.cnf
├──── index.txt
├──── serial
├── certs/
├── crl/
├── csr/
├── newcerts/
└── private/
```

# 01-create-root-key.sh

This is the first step for creating our root certificate. We have to create our
root key.

Create the root key (**ca.key.pem**) and keep it absolutely secure. Anyone in
possession of the root key can issue trusted certificates. Encrypt the root
key with AES 256-bit encryption and a strong password.

* Note: Use 4096 bits for all root and intermediate certificate authority keys. You’ll
still be able to sign server and client certificates of a shorter length.

```
openssl genrsa -aes256 -out private/ca.key.pem 4096

CA-Root/
├── openssl.cnf
├── index.txt
├── serial
├── certs/
├── crl/
├── csr/
├── newcerts/
└── private
    └── ca.key.pem
```

* Note: When you run the command, OpenSSL prompts you twice to enter a
passphrase to encrypt your private key. Remember that this private key is a
very important key, so choose your passphrase accordingly.

# 02-create-root-certificate

Before we can begin issuing certificates with our CA, it needs a certificate of
its own with which to sign the certificates that it issues. This certificate
will also be used to sign any CRLs that are published. Any certificate that has
the authority to sign certificates and CRLs will do. 

Use the root key (ca.key.pem) to create a root certificate (ca.cert.pem).
Give the root certificate a long expiry date, such as twenty years. Once the
root certificate expires, all certificates signed by the CA become invalid.

* Note: Whenever you use the req tool, you must specify a configuration file to use
with the -config option, otherwise OpenSSL will default to /etc/pki/tls/openssl.cnf.

```
openssl req -config openssl.cnf \
    -key private/ca.key.pem \
    -new -x509 -days 7300 -sha256 -extensions v3_ca \
    -out certs/ca.cert.pem

CA-Root/
├── openssl.cnf
├── index.txt
├── serial
├── certs/
│   └── ca.cert.pem
├── crl/
├── csr/
├── newcerts/
└── private
    └── ca.key.pem
```

# 03-verify-root-certicate.sh

For textual dump of the resulting certificate.

The output shows:

- the Signature Algorithm used
- the dates of certificate Validity
- the Public-Key bit length
- the Issuer, which is the entity that signed the certificate
- the Subject, which refers to the certificate itself

* Note: The Issuer and Subject are identical as the certificate is self-signed,
also note that all root certificates are self-signed.

Note: The output also shows the X509v3 extensions. We applied the 
v3_ca extension, so the options from [ v3_ca  ] should be reflected 
in the output.

```
openssl x509 -noout -text -in certs/ca.cert.pem
```

# 04-create-intermediate-key.sh

An intermediate certificate authority (CA) is an entity that can sign
certificates on behalf of the root CA. The root CA signs the intermediate
certificate, forming a chain of trust.

The purpose of using an intermediate CA is primarily for security. The root key
can be kept offline and used as infrequently as possible. If the intermediate
key is compromised, the root CA can revoke the intermediate certificate and
create a new intermediate cryptographic pair.

We have to create the root-intermediate key, in a similar way of root-key of
our root-CA.

```
openssl genrsa -aes256 -out private/intermediate.key.pem 4096

CA-Intermediate/
├── certs
├── crl
├── csr
├── index.txt
├── newcerts
├── openssl-intermediate.cnf
├── private
│   └── intermediate.key.pem
└── serial
```

# 05-create-intermediate-certificate.sh

The first step in requesting a certificate from a Certificate Authority (CA)
usually requires creating what is called a Certificate Signing Request (CSR).
Use the intermediate key to create a certificate signing request (CSR). The
details should generally match the root CA. The Common Name, however, must be
different. Before you can create a certificate you must generate a Certięcate
Signing Request (CSR) and obtain a valid, signed certificate from the CA.

* Warning: Make sure you specify the intermediate CA configuration file
(CA-Intermediate/openssl-intermediate.cnf)

```
openssl req -config openssl-intermediate.cnf -new -sha256 \
    -key private/intermediate.key.pem \
    -out csr/intermediate.csr.pem

CA-Intermediate/
├── certs
├── crl
├── csr
│   └── intermediate.csr.pem
├── index.txt
├── newcerts
├── openssl-intermediate.cnf
├── private
│   └── intermediate.key.pem
└── serial
```

# 06-sign-the-intermediate-CSR.sh

To create an intermediate certificate, use the root CA with the
v3_intermediate_ca extension to sign the intermediate CSR. The intermediate
certificate should be valid for a shorter period than the root certificate.
Ten years would be reasonable.

* Warning: This time, specify the root CA configuration file 
(CA-Root/openssl.cnf).

```
openssl ca -config openssl.cnf -extensions v3_intermediate_ca \
    -days 3650 -notext -md sha256 \
    -in ../CA-Intermediate/csr/intermediate.csr.pem \
    -out ../CA-Intermediate/certs/intermediate.cert.pem

A-Intermediate/
├── certs
│   └── intermediate.cert.pem
├── crl
├── csr
│   └── intermediate.csr.pem
├── index.txt
├── newcerts
├── openssl-intermediate.cnf
├── private
│   └── intermediate.key.pem
└── serial
```

# 07-verify-intermediate-certificate.sh

```
openssl x509 -noout -text \
    -in certs/intermediate.cert.pem 
```

Verify the intermediate certificate against the root certificate. An OK
indicates that the chain of trust is intact.

```
openssl verify \
    -CAfile ../CA-Root/certs/ca.cert.pem \
    certs/intermediate.cert.pem
```

# 08-create-certificate-chain-file.sh

When an application (eg, a web browser) tries to verify a certificate signed
by the intermediate CA, it must also verify the intermediate certificate
against the root certificate. To complete the chain of trust, create a CA
certificate chain to present to the application.

To create the CA certificate chain, concatenate the intermediate and root
certificates together. We will use this file later to verify certificates
signed by the intermediate CA.

```
cat CA-Intermediate/certs/intermediate.cert.pem \
    CA-Root/certs/ca.cert.pem > \
       CA-Intermediate/certs/ca-chain.cert.pem

CA-Intermediate/
├── certs
│   ├── ca-chain.cert.pem
│   └── intermediate.cert.pem
├── crl
├── csr
│   └── intermediate.csr.pem
├── index.txt
├── newcerts
├── openssl-intermediate.cnf
├── private
│   └── intermediate.key.pem
└── serial
```

Our certificate chain file must include the root certificate because no
client application knows about it yet. A better option, particularly if
you’re administrating an intranet, is to install your root certificate on
every client that needs to connect. In that case, the chain file need only
contain your intermediate certificate.

# 09-signing-server-cert.sh

We will be signing certificates using our intermediate CA. You can use these
signed certificates in a variety of situations, such as to secure connections
to a web server or to authenticate clients connecting to a service.

The steps below are from your perspective as the certificate authority. A
third-party, however, can instead create their own private key and
certificate signing request (CSR) without revealing their private key to you.
They give you their CSR, and you give back a signed certificate. In that
scenario, skip the genrsa and req commands.

- Create a key

Our root and intermediate pairs are 4096 bits. Server and client certificates
normally expire after one year, so we can safely use 2048 bits instead.

Note: Although 4096 bits is slightly more secure than 2048 bits, it slows
down TLS handshakes and significantly increases processor load during
handshakes. For this reason, most websites use 2048-bit pairs.

Note: If you’re creating a cryptographic pair for use with a web server (eg,
Apache), you’ll need to enter this password every time you restart the web
server. You may want to omit the -aes256 option to create a key without a
password.

```
openssl genrsa -aes256 -out intermediate/private/www.example.com.key.pem 2048
or
openssl genrsa -out private/admin.microserviceslab.com.key.pem 2048
```

- Create the certificate

Use the private key to create a certificate signing request (CSR). The CSR
details don’t need to match the intermediate CA. 

1. For server certificates, the Common Name must be a fully qualified 
   domain name (eg, www.example.com),
2. whereas for client certificates it can be any unique identifier (eg, an
   e-mail address). 

* WARNING: that the Common Name cannot be the same as either your root or 
intermediate certificate.

```
openssl req \
    -config openssl-intermediate.cnf \
    -key private/admin.microserviceslab.com.key.pem \
    -new -sha256 -out csr/admin.microserviceslab.com.csr.pem
```

To create a certificate, use the intermediate CA to sign the CSR. If the
certificate is going to be used 

1. on a server, use the server_cert extension.
2. If the certificate is going to be used for user authentication, use the
   usr_cert extension. 

Certificates are usually given a validity of one year,
though a CA will typically give a few days extra for convenience.


Creating the Server Cerfificate:

```
openssl ca \
    -config openssl-intermediate.cnf \
    -extensions server_cert \
    -days 375 \
    -notext \
    -md sha256 \
    -in csr/admin.microserviceslab.com.csr.pem \
    -out certs/admin.microserviceslab.com.cert.pem
```

Finally we get:


```
CA-Intermediate/
├── certs
│   ├── admin.microserviceslab.com.cert.pem
│   ├── ca-chain.cert.pem
│   └── intermediate.cert.pem
├── crl
├── csr
│   ├── admin.microserviceslab.com.csr.pem
│   └── intermediate.csr.pem
├── index.txt
├── index.txt.attr
├── index.txt.old
├── newcerts
│   └── 1000.pem
├── openssl-intermediate.cnf
├── private
│   ├── admin.microserviceslab.com.key.pem
│   └── intermediate.key.pem
├── serial
└── serial.old
```

# 10-signing-client-cert.sh

- Creating a Client cerfificate signing request (CSR):

The private key:

```
openssl genrsa -out private/client1.key 2048
```

The CSR:

```
openssl req \
    -config openssl-intermediate.cnf \
    -key private/client1.key \
    -new -sha256 -out csr/client1.csr
```

- Creating the Client Cerfificate:

```
openssl ca \
    -config openssl-intermediate.cnf \
    -extensions usr_cert \
    -days 375 \
    -notext \
    -md sha256 \
    -in csr/client1.csr \
    -out certs/client1.cert.pem
```

# 12-prepare-client-cert.sh

Convert Client Key to PKCS, so that it may be installed in most browsers.

```
openssl pkcs12 \
    -export \
    -clcerts \
    -in certs/client1.cert.pem \
    -inkey private/client1.key \
    -out certs/client.p12
```

Convert Client Key to (combined) PEM: Combines client.crt and client.key into 
a single PEM file for programs using openssl.

```
openssl pkcs12 \
    -in certs/client.p12 \
    -out certs/client.pem \
    -clcerts
```

# Updating expired certificates

We are creating certificates with 1 year of validation. When the
certificate expire we have to update the expired certificated.

## 01-check-expiration-date-certificate.sh

```
for i in $(ls *.cert*); do echo $i && openssl x509 -in $i -noout -enddate; done

admin.microserviceslab.com.cert.pem
notAfter=Jun 23 18:39:12 2027 GMT

client1.cert.pem
notAfter=Jul  5 18:52:04 2018 GMT

intermediate.cert.pem
notAfter=Jun 23 18:34:24 2027 GMT

ca-chain.cert.pem
notAfter=Jun 23 18:34:24 2027 GMT
```

The HAProxy bundle:

```
openssl x509 -in haproxy-joint.pem -noout -enddate

notAfter=Jul  5 18:35:23 2018 GMT
```

## 02-generate-new-certificate.sh

Generate a new Certificate Signing Request using the existing
ssl/testingcert.key private key

```
openssl req -config openssl-intermediate.cnf \
    -new -key private/admin.microserviceslab.com.key.pem \
    -out csr/admin.microserviceslab.com.csr.pem
```

## 03-check-certificate-signing-request-information.sh

```
openssl req -in csr/admin.microserviceslab.com.csr.pem -noout -text
```

## 04-new-certificate-with-the-csr.sh

Generate a new certificate using the new certificate signing request. The new
signing request is good for 1 year (365 days)

```
openssl x509 -req -days 365 \
    -in csr/admin.microserviceslab.com.csr.pem \
    -signkey private/admin.microserviceslab.com.key.pem \
    -out certs/admin.microserviceslab.com.cert.pem
```

## Verify the expiration date of new certificate

```
openssl x509 -in admin.microserviceslab.com.cert.pem -noout -enddate                                                                              
notAfter=Dec  1 09:11:13 2019 GMT
```

## Create the HAProxy bundle with the new certificate

```
sh 11-create-haproxy-pem.sh

openssl x509 -in haproxy-joint.pem -noout -enddate

notAfter=Dec  1 09:11:13 2019 GMT
```

## Create the new client certificates

## Importing in browser:

Importing the CA with the Root and the Intermediate
in a chain:

```
Settings -> Certificates -> Authorities -> 
Import tmp/CA/CA-Intermediate/certs/ca-chain.cert.pem
```

Importing the client certificate for the browser:

```
Settings -> Certificates -> Your Certificates -> 
Import tmp/CA/CA-Intermediate/certs/client.p12
```
Settings -> Certificates -> Your Certificates -> 




