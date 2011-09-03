cat <<END
sudo yum -y update
sudo yum -y install git httpd patch
chmod 755 .
mkdir www
sudo patch -d/ -p1 <<EOF
`git diff master...patch`
EOF
sudo /sbin/chkconfig httpd on
sudo /sbin/service httpd start
END
