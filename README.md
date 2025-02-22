# Gandi DNS Auto-Updater for Home Assistant

This repository provides an automation to update your Gandi DNS records based on your public IP address. It can be triggered periodically or when a specified IP address entity changes in Home Assistant.

---

## **Setup Instructions**

Follow these steps to automate the update of your Gandi DNS records using Home Assistant.

### 1. **Generate a Personal Access Token (PAT) at Gandi**

To interact with Gandi’s DNS API, you will need a Personal Access Token (PAT).

#### Steps:
1. **Log in to Gandi:**
   Go to [Gandi.net](https://www.gandi.net/) and log into your account.
   
2. **Create a PAT:**
   - Navigate to **User Settings / Personal Access Token** in the Gandi dashboard (Click on your username).
   - Create a new **Personal Access Token (PAT)** for use in automation.
   
3. **Copy the Token:**
   Copy the generated token to use in the next step.

### 2. **Add Your Gandi API Token to Home Assistant Secrets**

For security reasons, we’ll store the Gandi API token in Home Assistant’s `secrets.yaml`.

#### Steps:
1. **Edit `secrets.yaml`:**
   Open your `secrets.yaml` file located in `/config/`.

2. **Add the API Token:**
   Add the following line, replacing `<your_token>` with your actual PAT:
   ```yaml
   gandi_api_token: "<your_token>"
   ```

---

### 3. **Create the Shell Script to Update DNS Records**

This script fetches your current IP address and updates the A record in Gandi’s DNS service.

#### Steps:
1. **Create the Script File:**
   - Go to your Home Assistant's `config` directory.
   - Create a new directory for scripts (if not already there):
     ```bash
     mkdir -p /config/scripts
     ```
   - Create the shell script `update_gandi_dns.sh` in `/config/scripts/`:
     ```bash
     touch /config/scripts/update_gandi_dns.sh
     ```

2. **Copy the Script:**
   Open `update_gandi_dns.sh` in a text editor and edit the domain and subdomain lines:

   ```bash
   # Set your domain and subdomain
   DOMAIN="YOUR_DOMAIN"
   SUBDOMAIN="YOUR_SUBDOMAIN"
   TTL=10800
   ```

3. **Make the Script Executable:**
   Run the following command to make the script executable:
   ```bash
   chmod +x /config/scripts/update_gandi_dns.sh
   ```

---

### 4. **Configure Home Assistant to Run the Script**

Now, we will set up Home Assistant to execute the script periodically and when the IP changes.

#### 1. **Add Shell Command to `configuration.yaml`:**

In `configuration.yaml`, add the following lines to create a shell command that runs the script:

```yaml
shell_command:
  update_gandi_dns: '/bin/bash /config/scripts/update_gandi_dns.sh'
```

#### 2. **Create the Automation:**

You can set up the automation to trigger the script either periodically. Change the duration to suit.

```yaml
alias: Update Gandi DNS
description: ""
triggers:
  - entity_id: YOUR_SENSOR
    trigger: state
  - trigger: time_pattern
    minutes: /15
conditions: []
actions:
  - action: shell_command.update_gandi_dns
    data: {}
mode: single
```

Replace `YOUR_SENSOR` with the entity ID of the sensor that monitors your external IP address.

---

### 5. **Restart Home Assistant**

Once you have made these changes, restart Home Assistant to apply them.

---

### 6. **Verify the Setup**

After restarting, check the following:

1. **Test the Shell Command Manually:**
   Run the shell command from the Home Assistant UI to verify it works:
   - Go to *Developer Tools* → *Actions*.
   - Select `shell_command.update_gandi_dns` and press *Perform Action*.

2. **Check Logs:**
   Check the log at `/config/gandi-dns-update.log` to verify updates to the DNS records.

---

If you need additional help, feel free to create an issue in this repository.
```
