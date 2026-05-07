# 🛡️ Kali + Splunk SOC Lab — SSH Brute Force Detection

A simple SOC home lab that detects SSH brute force attacks using Kali Linux and Splunk SIEM.

---

## 📌 Project Overview

- **Kali Linux** acts as the monitored machine
- **Splunk Universal Forwarder** ships logs from Kali to Splunk
- **Shell script** simulates SSH brute force attacks
- **Splunk Dashboard** visualizes the attacks in real time

---

## 🧰 Tools Used

| Tool | Purpose |
|------|---------|
| Kali Linux | Target machine / log source |
| Splunk Enterprise | SIEM / Log analysis |
| Splunk Universal Forwarder | Log shipping from Kali to Splunk |
| Bash Shell Script | Simulate brute force attack |
| OpenSSH | Service being monitored |

---

## 📁 Files

| File | Description |
|------|-------------|
| `fake_ssh_brute.sh` | Shell script that simulates SSH brute force by attempting 10 failed logins |
| `dashboard.xml` | Splunk dashboard XML to visualize the attacks |

---

## 🏗️ Setup

### 1. Install Splunk Universal Forwarder on Kali
Download from: https://www.splunk.com/en_us/download/universal-forwarder.html

```bash
cd ~/Downloads
dpkg -i splunkforwarder*.deb
sudo /home/kali/Downloads/splunkforwarder/bin/splunk start --accept-license
sudo /home/kali/Downloads/splunkforwarder/bin/splunk enable boot-start
```

### 2. Monitor Auth Logs

```bash
sudo nano /home/kali/Downloads/splunkforwarder/etc/system/local/inputs.conf
```

Add:
```ini
[monitor:///var/log/auth.log]
index = main
sourcetype = linux_secure
```

Restart forwarder:
```bash
sudo systemctl restart SplunkForwarder
```

---

## 🔴 Simulate Attack

```bash
sudo apt install sshpass -y
chmod +x fake_ssh_brute.sh
sudo bash fake_ssh_brute.sh
```

Verify logs:
```bash
grep -a "Failed password" /var/log/auth.log | tail -20
```

---

## 📊 Splunk Dashboard

1. Go to **Dashboards** → **Create New Dashboard**
2. Name it `SSH Brute Force Monitor`
3. Click **Edit** → **Source**
4. Paste contents of `dashboard.xml`
5. Click **Save**

---

## 🔎 Splunk SPL Query

```spl
index=* host=kali "Failed password" earliest=@d
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| stats count as FailedAttempts by src_ip
| where FailedAttempts >= 10
| sort -FailedAttempts
```

---

## 📸 Dashboard

![Dashboard](dashboard.png)

---

## ⚠️ Disclaimer

This lab is for **educational purposes only**.
Only test on systems you own or have permission to test.
