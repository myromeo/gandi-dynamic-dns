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
   - Navigate to **API & Webhooks** in the Gandi dashboard.
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
