<h1 align="center">
  <img alt="mollie Prestashop logo" src="./PrestashopxMollie.png" width="488px"/><br/>
  Docker container with Prestashop 🐧 (including Mollie plugin)
</h1>
<p align="center">Create a new test-ready Prestashop webshop with <b>database</b> (MySql) and <b>frontend</b> (PHP) by running a few CLI commands.

## 🐳 Docker-way to ⚡️ Quick start

First, [download](https://docs.docker.com/engine/install/) and install the **Docker Engine**. Version `4.9.1` is recommended.

Installation is done by downloading this repo with the **[`git clone`](https://git-scm.com/docs/git-clone)** command in terminal:

```bash
git clone https://github.com/SalimAtMollie/PrestashopxMollie MolliePrestashop
```

Let's enter that new downloaded project via the **cd** command:

```bash
cd MolliePrestashop
```

Next, we will run the command which will use the **[`docker-compose`](https://docs.docker.com/compose/)** file to set up the containers needed for the website. If you're ready, we can **start the installation** with:

```bash
docker-compose up --build
```

That's all you need to do to start! 🎉

> 🔔 Please note: Once the **installation is complete**, you will have to **add the live/test keys** in the Mollie plugin settings and **activate it**.

## 🔓 Backend Access

To access the backend of the webshop you need to access the admin page. The admin page is the domain of the website followed by the name of the admin folder.
The default links and credentials can be found here:

**[`Website`](http://localhost:8001)**: 
  - http://localhost:8001

**[`Admin Page`](http://localhost:8001/admin)**: 
  - http://localhost:8001/admin
  - Email: `prestashop@demo.com`
  - Password: `MollieWithPrestaShop`

## 🔓 Compatibility with different versions

You are able to change the version number of any component that is needed to run this container. This includes the PHP, Prestashop and Mollie plugin versions.

### 🐘 PHP

  To change the php version, you need to change the variable for the option `PS_VERSION` in the .env file. This option also loads all the dependencies (rather than just PHP) needed for the prestashop version. Here you can see what the options are:

  | Prestashop Version | PHP Version | Option|
  |--------|-------|------------------| 
  | `1.7`  | `7.3` | `1.7-7.3-apache` |
  | `1.7`  | `7.2` | `1.7-7.2-apache` |
  | `1.7`  | `7.1` | `1.7-7.1-apache` |
  | `1.7`  | `7.0` | `1.7-7.0-apache` |
  | `1.6`  | `7.2` | `1.6-7.2-apache` |
  | `1.6`  | `7.1` | `1.6-7.1-apache` |
  | `1.6`  | `7.0` | `1.6-7.0-apache` |

### 🐧 Prestashop

  To change the prestashop version, you need to change the variable for the option `PS_VERSION_DF` in the .env file. This variable has to match any tag with a version number which can be found [here](https://github.com/PrestaShop/PrestaShop/tags). When running the container for the first time, it will download and install the prestashop webshop with that version number.
  
  Take into consideration that you will also need to change the `PS_VERSION` so that the container can load up the correct dependencies needed to run Prestashop correctly. You can find the compatible Prestashop and PHP versions [here](https://devdocs.prestashop-project.org/1.7/basics/installation/system-requirements/#:~:text=PrestaShop%20needs%20the%20following%20server,recommend%20PHP%207.1%20or%20later.).

## ⚙️ .env Options

This shows the options you may change in the .env file.


| Option | Description                                              | Type   | Default |
|--------|----------------------------------------------------------|--------|---------|
| `PS_VERSION_DF`   | Version number of Prestashop. Either '1.7' or '1.6-7.0-apache'. | `string` | `1.7` |
| `PS_VERSION`   | Version number of [Prestashop](https://github.com/PrestaShop/PrestaShop/tags). | `string` | `1.7.8.7` |
| `MOLLIE_VERSION`   | Version of the Mollie plugin. | `string` | `V5.2.1` |
| `DB_NAME`   | Username for MySql databse. | `string` | `prestashop` |
| `DB_PASSWD`   | Password for MySql databse. | `string` | `prestashop` |
| `DB_SERVER`   | Name for MySql databse. | `string` | `mysql` |
| `DB_PREFIX`   | Prefix for MySql database | `string` | `ps_` |
| `PS_INSTALL_AUTO`   | Set to 0, if you do not want prestashop to autoinstall. | `string` | `-1` |
| `PS_DOMAIN`   | Domain of the Prestashop website. | `string` | `localhost:8001` |
| `PS_FOLDER_INSTALL`   | Set name of the installation folder. | `string` | `install` |
| `PS_FOLDER_ADMIN`   | Set name of the admin folder. | `string` | `admin` |
| `PS_COUNTRY`   | Country of origin of Prestashop website. | `string` | `en` |
| `PS_LANGUAGE`   | Language of Prestashop website. | `string` | `en` |
| `PS_DEV_MODE`   | Set to 1, if you want to activate dev mode. | `string` | `0` |
| `ADMIN_PASSWD`   | Password to access admin page of Prestashop webiste. | `string` | `MollieWithPrestaShop` |
