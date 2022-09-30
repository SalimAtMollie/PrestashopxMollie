<h1 align="center">
  <img alt="mollie Oxid logo" src="./PrestashopxMollie.png" width="224px"/><br/>
  Docker container with Prestashop (including Mollie plugin)
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
