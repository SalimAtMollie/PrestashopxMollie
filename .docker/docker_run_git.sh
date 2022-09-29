#!/bin/sh

if [ "$DB_SERVER" = "<to be defined>" -a $PS_INSTALL_AUTO = 1 ]; then
    echo >&2 "[!] Error: You requested automatic PrestaShop installation but MySQL server address is not provided "
    echo >&2 "           You need to specify DB_SERVER in order to proceed"
    exit 1
elif [ "$DB_SERVER" != "<to be defined>" -a $PS_INSTALL_AUTO = 1 ]; then
    RET=1
    while [ $RET -ne 0 ]; do
        echo "\n* [!] Checking if $DB_SERVER is available..."
        mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "status" > /dev/null 2>&1
        RET=$?

        if [ $RET -ne 0 ]; then
            echo "\n* [!] Waiting for confirmation of MySQL service startup";
            sleep 5
        fi
    done
        echo "\n* [!] DB server $DB_SERVER is available, let's continue !"
fi

# From now, stop at error
set -e

if [ ! -f ./config/settings.inc.php ]; then
    # Get the PrestaShop sources and unzip
    echo "\n* [!] Download PrestaShop ${PS_VERSION}"
    wget -c -q -O prestashop_${PS_VERSION}.zip "https://github.com/PrestaShop/PrestaShop/releases/download/${PS_VERSION}/prestashop_${PS_VERSION}.zip"
    echo "\n* [!] Unzipping PrestaShop ${PS_VERSION}"
    unzip -q -o prestashop_${PS_VERSION}.zip -d prestashop_${PS_VERSION}
    if [ ! -d ./prestashop_${PS_VERSION}/prestashop ]; then
        unzip -q -o prestashop_${PS_VERSION}/prestashop.zip -d .
    else #it is 1.6 presta
        mv -v ./prestashop_${PS_VERSION}/prestashop/* ./
        rm -rf ./prestashop_${PS_VERSION}
        #Fix PHP Fatal error:  Cannot use result of built-in function in write context in /var/www/html/tools/tar/Archive_Tar.php on line 693
        sed -ie 's/$v_att_list = & func_get_args();/$v_att_list = func_get_args();/' ./tools/tar/Archive_Tar.php
    fi
    rm -rf *.zip prestashop_${PS_VERSION}/
    mkdir -p var/cache/prod
    chown -R www-data /var/www/html
    echo "\n* [!] files are ready"

    if [ $PS_DEV_MODE -ne 1 ]; then
        echo "\n* [!] Disabling DEV mode ...";
        sed -ie "s/define('_PS_MODE_DEV_', true);/define('_PS_MODE_DEV_',\ false);/g" /var/www/html/config/defines.inc.php
    fi

    if [ $PS_INSTALL_AUTO = 1 ]; then

        echo "\n* [!] Installing PrestaShop, this may take a while ...";

        if [ $PS_ERASE_DB = 1 ]; then
            echo "\n* [!] Drop & recreate mysql database...";
            if [ $DB_PASSWD = "" ]; then
                echo "\n* [!] Dropping existing database $DB_NAME..."
                mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -e "drop database if exists $DB_NAME;"
                echo "\n* [!] Creating database $DB_NAME..."
                mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER create $DB_NAME --force;
            else
                echo "\n* [!] Dropping existing database $DB_NAME..."
                mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "drop database if exists $DB_NAME;"
                echo "\n* [!] Creating database $DB_NAME..."
                mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD create $DB_NAME --force;
            fi
        fi

        if [ "$PS_DOMAIN" = "<to be defined>" ]; then
            export PS_DOMAIN=$(hostname -i)
        fi

        echo "\n* [!] Launching the installer script..."
        runuser -g www-data -u www-data -- php /var/www/html/$PS_FOLDER_INSTALL/index_cli.php \
        --domain="$PS_DOMAIN" --db_server=$DB_SERVER:$DB_PORT --db_name="$DB_NAME" --db_user=$DB_USER \
        --db_password=$DB_PASSWD --prefix="$DB_PREFIX" --firstname="Marc" --lastname="Beier" \
        --password="$ADMIN_PASSWD" --email="$ADMIN_MAIL" --language=$PS_LANGUAGE --country=$PS_COUNTRY \
        --all_languages=$PS_ALL_LANGUAGES --newsletter=0 --send_email=0 --ssl=$PS_ENABLE_SSL

        if [ $? -ne 0 ]; then
            echo "[!] Error: PrestaShop installation failed."
        else
            echo "\n* [!] Downloading Mollie plugin..."
            wget -q --no-check-certificate --content-disposition "https://github.com/mollie/PrestaShop${PS_VERSION_DF}/releases/download/${MOLLIE_VERSION}/mollie.zip"           
            unzip  -q ./mollie.zip
            mv ./mollie ./modules
        fi
        rm -rf ./install
    fi
else
    echo "\n* [!] PrestaShop Core already installed...";
fi

if [ $PS_DEMO_MODE -ne 0 ]; then
    echo "\n* [!] Enabling DEMO mode ...";
    sed -ie "s/define('_PS_MODE_DEMO_', false);/define('_PS_MODE_DEMO_',\ true);/g" /var/www/html/config/defines.inc.php
fi


echo "############################################################################"
echo "##### Installation Complete! Please activate Mollie in Extensions Page #####"
echo "############################################################################"
echo "[!] Website Url 		 : http://${PS_DOMAIN}"
echo "[!] Website Admin Url : http://${PS_DOMAIN}/${PS_FOLDER_ADMIN}"
echo "[!] Admin Username    : demo@prestashop.com"
echo "[!] Admin Password    : ${ADMIN_PASSWD}"

exec apache2-foreground
