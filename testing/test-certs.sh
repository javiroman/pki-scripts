# OpenSSL comes with a client tool that you can use to connect to a secure
# server. The tool is similar to telnet or nc, in the sense that it handles the
# SSL/TLS layer but allows you to fully control the layer that comes next.

# To connect to a server, you need to supply a hostname and a port:
openssl s_client -connect hello.microserviceslab.com:443

# more information here:
# https://www.feistyduck.com/library/openssl-cookbook/online/ch-testing-with-openssl.html


