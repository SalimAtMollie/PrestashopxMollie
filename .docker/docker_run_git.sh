#!/bin/sh

YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
NC=$(tput sgr0)

if [ "${DISABLE_MAKE}" != "1" ]; then
  echo "\n* ${YELLOW}[!] Running composer ...${NC}";
  runuser -g www-data -u www-data -- /usr/local/bin/composer install --no-interaction

  echo "\n* ${YELLOW}[!] Build assets ...${NC}";
  runuser -g www-data -u www-data -- /usr/bin/make assets
fi

if [ "$DB_SERVER" = "<to be defined>" -a $PS_INSTALL_AUTO = 1 ]; then
    echo >&2 "${RED}[!] Error: You requested automatic PrestaShop installation but MySQL server address is not provided ${NC}"
    echo >&2 "${RED}           You need to specify DB_SERVER in order to proceed${NC}"
    exit 1
elif [ "$DB_SERVER" != "<to be defined>" -a $PS_INSTALL_AUTO = 1 ]; then
    RET=1
    while [ $RET -ne 0 ]; do
        echo "\n* ${YELLOW}[!] Checking if $DB_SERVER is available...${NC}"
        mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "status" > /dev/null 2>&1
        RET=$?

        if [ $RET -ne 0 ]; then
            echo "\n* ${YELLOW}[!] Waiting for confirmation of MySQL service startup${NC}";
            sleep 5
        fi
    done
        echo "\n* ${GREEN}[!] DB server $DB_SERVER is available, let's continue !${NC}"
fi

# From now, stop at error
set -e

if [ $PS_DEV_MODE -ne 1 ]; then
  echo "\n* ${YELLOW}[!] Disabling DEV mode ...${NC}";
  sed -ie "s/define('_PS_MODE_DEV_', true);/define('_PS_MODE_DEV_',\ false);/g" /var/www/html/config/defines.inc.php
fi

if [ ! -f ./config/settings.inc.php ]; then
    if [ $PS_INSTALL_AUTO = 1 ]; then

        echo "\n* ${YELLOW}[!] Installing PrestaShop, this may take a while ...${NC}";

        if [ $PS_ERASE_DB = 1 ]; then
            echo "\n* ${YELLOW}[!] Drop & recreate mysql database...${NC}";
            if [ $DB_PASSWD = "" ]; then
                echo "\n* ${YELLOW}[!] Dropping existing database $DB_NAME...${NC}"
                mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -e "drop database if exists $DB_NAME;"
                echo "\n* ${YELLOW}[!] Creating database $DB_NAME...${NC}"
                mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER create $DB_NAME --force;
            else
                echo "\n* ${YELLOW}[!] Dropping existing database $DB_NAME...${NC}"
                mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "drop database if exists $DB_NAME;"
                echo "\n* ${YELLOW}[!] Creating database $DB_NAME...${NC}"
                mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD create $DB_NAME --force;
            fi
        fi

        if [ "$PS_DOMAIN" = "<to be defined>" ]; then
            export PS_DOMAIN=$(hostname -i)
        fi

        echo "\n* ${YELLOW}[!] Launching the installer script...${NC}"
        runuser -g www-data -u www-data -- php /var/www/html/$PS_FOLDER_INSTALL/index_cli.php \
        --domain="$PS_DOMAIN" --db_server=$DB_SERVER:$DB_PORT --db_name="$DB_NAME" --db_user=$DB_USER \
        --db_password=$DB_PASSWD --prefix="$DB_PREFIX" --firstname="Marc" --lastname="Beier" \
        --password="$ADMIN_PASSWD" --email="$ADMIN_MAIL" --language=$PS_LANGUAGE --country=$PS_COUNTRY \
        --all_languages=$PS_ALL_LANGUAGES --newsletter=0 --send_email=0 --ssl=$PS_ENABLE_SSL

        if [ $? -ne 0 ]; then
            echo "${RED}[!] Error: PrestaShop installation failed.${NC}"
        fi
    fi
else
    echo "\n* ${GREEN}[!] PrestaShop Core already installed...${NC}";
fi

if [ $PS_DEMO_MODE -ne 0 ]; then
    echo "\n* ${YELLOW}[!] Enabling DEMO mode ...${NC}";
    sed -ie "s/define('_PS_MODE_DEMO_', false);/define('_PS_MODE_DEMO_',\ true);/g" /var/www/html/config/defines.inc.php
fi


echo "${GREEN}############################################################################"
echo "${GREEN}##### Installation Complete! Please activate Mollie in Extensions Page #####"
echo "${GREEN}############################################################################"
echo "${YELLOW}[!] Website Url 		 :${NC} http://localhost:8001"
echo "${YELLOW}[!] Website Admin Url :${NC} http://localhost:8001/admin-dev"
echo "${YELLOW}[!] Admin Username    :${NC} demo@prestashop.com"
echo "${YELLOW}[!] Admin Password    :${NC} mollie"

exec apache2-foreground
