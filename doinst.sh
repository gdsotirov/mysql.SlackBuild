# Bash colors
C_GREEN=$'\e[32;01m'
C_YELLOW=$'\e[33;01m'
C_RED=$'\e[31;01m'
C_NORMAL=$'\e[0m'

config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

# Install the info files for this package
if [ -x /usr/bin/install-info ]
then
   echo -n "Installing info pages... "
   /usr/bin/install-info --info-dir=/usr/info /usr/info/mysql.info.gz 2>/dev/null
   if [ $? -eq 0 ]; then
     echo "${C_GREEN}DONE${C_NORMAL}"
   else
     echo "${C_RED}FAILURE${C_NORMAL}"
   fi
fi

# Keep same perms on rc.mysqld.new:
if [ -e etc/rc.d/rc.mysqld ]; then
  cp -a etc/rc.d/rc.mysqld etc/rc.d/rc.mysqld.new.incoming
  cat etc/rc.d/rc.mysqld.new > etc/rc.d/rc.mysqld.new.incoming
  mv etc/rc.d/rc.mysqld.new.incoming etc/rc.d/rc.mysqld.new
fi

config etc/rc.d/rc.mysqld.new

