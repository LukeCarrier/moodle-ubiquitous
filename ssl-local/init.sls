#
# Ubiquitous Saml
#
# @author Sascha Peter <sascha.o.peter@gmail.com>
# @copyright 2017 Sascha Peter
#

ssl-local.self-signed:
  module.run:
    tls.create_self_signed_cert:
      - bits: 2048
      - days: 3652
      - cacert_path: /etc/ssl/private
      - tls_dir: saml
      - CN: saml.test.moodle
