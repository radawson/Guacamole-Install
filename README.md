<div align="center">

![GitHub release version](https://img.shields.io/github/v/release/itiligent/Easy-Guacamole-Installer?style=flat-square&color=orange&labelColor=black)
![GitHub stars](https://img.shields.io/github/stars/itiligent/Easy-Guacamole-Installer?style=flat-square&color=yellow&labelColor=black)
![GitHub forks](https://img.shields.io/github/forks/itiligent/Easy-Guacamole-Installer?style=flat-square&color=blue&labelColor=black)

# 🥑 Easy Guacamole Installer



</div>

<p align="center">
<a href="https://www.paypal.com/donate/?business=PSZ878JBJDMB8&amount=10&no_recurring=0&item_name=Thankyou+for+your+support+in+maintaining+this+project&currency_code=AUD">
  <img src="https://github.com/itiligent/Guacamole-Install/raw/main/.github/ISSUE_TEMPLATE/paypal-donate-button.png" width="125" />
</a>
</p>

## Introduction

#### v1.6.0 is working. Issues and notes are tracked in https://github.com/itiligent/Easy-Guacamole-Installer/issues/78

This install script automatically sets up a Guacamole jump-host with optional for TLS reverse proxy (self-signed or Let's Encrypt), Active Directory integration, multi-factor authentication, Quick Connect & History Recording Storage UI enhancements. Other options also include a custom UI dark themed template, auto database backups, email alerts and internal hardening options including fail2ban for defence against brute force attacks. There is also faciltiy for enterprise deployments similar to [Amazon's Guacamole Bastion Cluster](http://netcubed-ami.s3-website-us-east-1.amazonaws.com/guaws/v2.3.1/cluster/).

## Automatic Installation

🚀 Paste the below link into a terminal & follow the prompts (**do NOT run as root, the script will prompt for sudo**): 

```shell
wget https://raw.githubusercontent.com/radawson/Guacamole-Install/main/1-setup.sh && chmod +x 1-setup.sh && ./1-setup.sh
```
---

## Prerequisites

📋 **You will need:**
  - **Supported OS: Debian 12 or 13** | **Ubuntu LTS 22.x or 24.x** | **Raspbian**
  - **1 CPU core + 2GB RAM for every 25 users (plus minimum RAM & disk space for your selected OS).**
- **Open TCP ports: 22, 80, and 443 (no other services using 80, 8080 & 443)**
- **For both TLS reverse proxy options you will need a PRIVATE DNS record for the internal proxy site, and an additional PUBLIC DNS record for the Let's Encrypt option.**
- **Sudo & wget packages installed**
- **The user running `1-setup.sh` must have sudo permissions**

---

## Setup Script Menu

🔧 **The main `1-setup.sh` script guides the installation with the following steps:**

1. Setup the system hostname & local DNS name (Local DNS must be consistent for TLS proxy).
2. Select either a local MySQL install or use a pre-existing local or remote MySQL instance.
3. Pick an authentication extension: DUO, TOTP, LDAP/Active Directory, OpenID Connect (SSO), or none.
4. Select optional console features: Quick Connect & History Recorded Storage UI integrations.
5. Select the Guacamole front end: Nginx reverse proxy (HTTP or HTTPS) or use the native Guacamole interface on port 8080.
   - If you opt to install Nginx with self-signed TLS:
     - New server & client browser certificates are saved to `$HOME/guac-setup/tls-certs/[date-time]/`.
     - Optionally follow on-screen instructions for client certificate import to avoid https browser warnings.

---

## Customising The Build

⚙️ **To customise the many available script options:**

- Exit `1-setup.sh` at the first prompt.
- All configurable script options are shown under **Silent setup options** at the start of `1-setup.sh`. 
- Certain combinations of the **Silent setup options** will allow for a fully unattended install supporting mass deployment or highly customised docker builds.
- Re-run your edited script locally after making changes (do not re-run the automatic install web link - see below). 

**Other custom install notes:**
- **Caution:** Re-running the auto-installer link re-downloads the suite of scripts which will overwrite any custom script edits. You must run 1-setup.sh LOCALLY after editing. If any child scripts are edited, their corresponding download links in 1-setup.sh script must also be commented out.
- Upgrade scripts are **automatically customised with your specifc installation settings** for consistent future updates.
- Nginx reverse proxy is configured to default to at least TLS 1.2. For ancient systems, see commented sections of the `/etc/nginx/nginx.conf` file after install.
- A daily MySQL backup job is automatically configured under the script owner's crontab.
- The Quick Connect option brings some extra security implications, be aware of potential risks in your environment.

**Post-install manual hardening options:**

- `add-fail2ban.sh`: Adds a lockdown policy for Guacamole to guard against brute force password attacks.
- `add-tls-guac-daemon.sh`: Wraps internal traffic between the guac server & guac application in TLS.
- `add-auth-ldap.sh`: Template script for simplified Active Directory integration.
- `add-auth-sso.sh`: OpenID Connect (SSO) extension installer (can be run post-install if not selected during setup).
- `add-smtp-relay-o365.sh`: Template script for email alert integration with MSO65 (BYO app password).

---

## Branding The Guacamole UI Theme

🎨 **Follow the theme and branding instructions** [here](https://github.com/itiligent/Guacamole-Install/tree/main/guac-custom-theme-builder). To revert to the default theme, simply delete the branding.jar file from `/etc/guacamole/extensions`, clear your browser cache and restart.

---

## Managing Self-Signed TLS Certs With Nginx

**To renew self-signed certificates or change the reverse proxy local DNS name/IP address:** 
- Re-run `4a-install-tls-self-signed-nginx.sh` to create a new Nginx certificate (new browser client certificates will also be created for re-import). Always clear your browser cache after changing certificates.

---

## Active Directory Integration

🔑 See [here](https://github.com/itiligent/Guacamole-Install/blob/main/ACTIVE-DIRECTORY-HOW-TO.md).

---

## OpenID Connect (SSO) Authentication

🔐 **Single Sign-On (SSO) support via OpenID Connect** allows users to authenticate using their existing identity provider (e.g., Azure AD, Okta, Google Workspace, etc.).

### Installation

During the main installation, you can select **"Install OpenID Connect (SSO)"** when prompted, or install it later using:

```shell
cd $HOME/guac-setup
sudo ./add-auth-sso.sh
```

### Configuration

After installation, you **must** configure OpenID Connect properties in `/etc/guacamole/guacamole.properties`. The script adds a configuration template with the following required properties:

```properties
# Required OpenID properties:
openid-authorization-endpoint: https://your-provider.com/authorize
openid-jwks-endpoint: https://your-provider.com/.well-known/jwks.json
openid-issuer: https://your-provider.com
openid-client-id: your-client-id
openid-redirect-uri: http://your-guacamole-server:8080/guacamole/

# Optional OpenID properties:
openid-username-claim-type: preferred_username
openid-scope: openid email profile
openid-allowed-clock-skew: 300
```

**Configuration Steps:**

1. **Get your OpenID provider details:**
   - Authorization endpoint URL
   - JWKS (JSON Web Key Set) endpoint URL
   - Issuer identifier
   - Client ID (from your identity provider)
   - Redirect URI (must match what's registered with your provider)

2. **Edit `/etc/guacamole/guacamole.properties`:**
   ```bash
   sudo nano /etc/guacamole/guacamole.properties
   ```

3. **Uncomment and fill in the OpenID properties** with your provider's values.

4. **Restart Guacamole services:**
   ```bash
   TOMCAT=$(ls /etc/ | grep tomcat)
   sudo systemctl restart guacd && sudo systemctl restart ${TOMCAT}
   ```

### Additional SSO Options

For other SSO methods (SAML, CAS, RADIUS), see the [SSO Extensions documentation](https://github.com/itiligent/Guacamole-Installer/blob/main/SSO-EXTENSIONS-HOW-TO.md).

**Note:** OpenID Connect cannot be used simultaneously with database authentication. Users will authenticate exclusively through your OpenID provider once configured.

---

## Adding Users to Guacamole

👥 **After installation, you can add users through the Guacamole web interface:**

### Initial Login

1. **Access Guacamole:**
   - If using Nginx reverse proxy: `http://your-server` or `https://your-server`
   - If using direct access: `http://your-server:8080/guacamole`

2. **Default credentials:**
   - Username: `guacadmin`
   - Password: `guacadmin`
   - **⚠️ IMPORTANT: Change this password immediately after first login!**

### Adding New Users

1. **Log in as `guacadmin`** (or another user with administrator privileges).

2. **Navigate to Settings:**
   - Click the **Settings** icon (gear) in the top menu
   - Select **Users** from the left sidebar

3. **Create a new user:**
   - Click **New User** button
   - Enter the username
   - Set a password (or leave blank if using LDAP/SSO authentication)
   - Configure user permissions:
     - **System permissions:** Administer, Create users, Create connections, etc.
     - **Object permissions:** Read, Update, Delete, Administer for specific connections/groups
   - Click **Save**

### User Management Tips

- **For LDAP/Active Directory users:** Create passwordless Guacamole accounts that match AD usernames. Authentication will be handled by AD.
- **For OpenID Connect (SSO):** Users are automatically created on first login. You can then assign permissions in the Guacamole interface.
- **For database authentication:** Users must have passwords set in Guacamole.
- **User groups:** Create groups to manage permissions for multiple users at once.

### Granting Connection Access

1. **Navigate to Settings → Connections**
2. **Select a connection** or create a new one
3. **Click on the connection** to edit it
4. **Go to the "Sharing" tab**
5. **Add users or groups** and set their permissions (Read, Update, Delete, Administer)

---

## Upgrading Guacamole

🌐 To upgrade Guacamole, edit `upgrade-guacamole.sh` to reflect the latest versions of Guacamole & MySQL connector/J before running. This script will automatically update TOTP, DUO, LDAP, OpenID Connect (SSO), Quick Connect, and History Recorded Storage extensions if present.

---

## High Availability Deployment

- 👔 **For a separate DATABASE layer:** Use the `install-mysql-backend-only.sh` [here](https://github.com/itiligent/Guacamole-Install/tree/main/guac-enterprise-build) to install a standalone instance of the Guacamole MySQL database.
- 👔 **For a separate APPLICATION layer:** Run `1-setup.sh` and point new installations to your separate database instance. Just say **no** to the "Install MySQL locally" option and any other local reverse proxy install options.
- 👔 **For a separate FRONT END layer:** Use the included Nginx installer scripts to build out a separate Nginx front end layer, and then apply your preferred TLS load balancing technique. Alternatively, AWS/Azure/GCP load balancers or [HA Proxy](https://www.haproxy.org/) may provide superior session persistence & affinity compared to [Open Source Nginx](https://www.nginx.com/products/nginx/compare-models/).

---

### Script Download Manifest

📦 **The autorun link downloads these files into `$HOME/guac-setup`:**

- `1-setup.sh`: The parent setup script.
- `2-install-guacamole.sh`: Guacamole source build & installer script.
- `3-install-nginx.sh`: Nginx installation script.
- `4a-install-tls-self-signed-nginx.sh`: Install/refresh self-signed TLS certificates script.
- `4b-install-tls-letsencrypt-nginx.sh`: Let's Encrypt for Nginx installer script.
- `add-auth-duo.sh`: Duo MFA extension install script.
- `add-auth-ldap.sh`: Active Directory extension installer template script.
- `add-auth-sso.sh`: OpenID Connect (SSO) extension installer script.
- `add-auth-totp.sh`: TOTP MFA extension installer script.
- `add-xtra-quickconnect.sh`: Quick Connect console extension installer script.
- `add-xtra-histrecstore.sh`: History Recorded Storage extension installer script.
- `add-smtp-relay-o365.sh`: Script for O365 SMTP auth relay setup (BYO app password).
- `add-tls-guac-daemon.sh`: Wrap internal traffic between guacd server & Guacamole web app in TLS.
- `add-fail2ban.sh`: Fail2ban (& Guacamole protection policy) installer script.
- `backup-guacamole.sh`: MySQL backup setup script.
- `upgrade-guacamole.sh`: Guacamole application, extension, and MySQL connector upgrade script.
- `branding.jar`: Base template for customizing Guacamole's UI theme.

😄🥑
