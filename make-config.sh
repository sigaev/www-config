cat <<END
sudo yum -y update
sudo yum -y install git httpd
chmod 755 .
mkdir www
sudo git apply --directory=/ <<EOF
`git diff master...patch`
EOF
sudo /sbin/chkconfig httpd on
sudo /sbin/service httpd start
END
