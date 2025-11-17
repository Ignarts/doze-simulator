<h1 align="center">
  <span style="
    background: linear-gradient(90deg,#00C6FF,#0072FF);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    font-weight: 900;
    font-size: 3rem;">
    doze-simulator
  </span>
</h1>

<p align="center">
  <strong style="
    background: linear-gradient(90deg,#FF8A00,#E52E71);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;">
    Android Doze & App Standby Simulation CLI
  </strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Android-Doze%20Simulator-3DDC84?style=for-the-badge&logo=android&logoColor=white"/>
  <img src="https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white"/>
  <img src="https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-lightgrey?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge"/>
</p>

<br/>

---

## 📌 Overview

**doze-simulator** is a command-line tool that automates and accelerates the process of testing how Android applications behave under:

* **Doze mode**
* **App Standby**
* **Standby Buckets**
* **Idle restrictions**
* **Background execution limits**
* **Network restrictions applied during deep idle**

Under normal circumstances, these conditions require *hours* of device inactivity.
This tool replicates most of the internal Android behavior **in seconds**, enabling fast and reliable testing.

The tool is useful for:

* Android developers (Kotlin / Java)
* React Native developers
* QA Engineers
* Automation / CI pipelines
* Anyone testing how their app behaves in background or idle conditions

---

## ✨ Features

* Simulates deep **Doze mode**
* Forces a target app into **App Standby**
* Supports **short & long flags**
* Optional app reactivation step
* Device and package validation
* Verbose mode for debugging
* Color and no-color modes (CI-friendly)
* Dynamic steps depending on flags
* Works on macOS, Linux and WSL

---

## 🎯 Motivation

Testing Android’s idle behavior normally requires:

1. Hours of inactivity
2. The device staying still
3. No charging
4. No user interaction
5. App not opened recently

This affects:

* Notifications
* WorkManager / Jobs
* Alarms
* Background services
* Network scheduling
* Sync processes

Instead of waiting 6–8 hours, **doze-simulator** allows developers to quickly reproduce these conditions for debugging and continuous integration.

---

## 📦 Installation

### 1. Make the script executable

```bash
chmod +x doze-simulator
```

### 2. Install it globally

```bash
sudo mv doze-simulator /usr/local/bin/
```

### 3. Confirm installation

```bash
doze-simulator --help
```

---

## 🚀 Usage

### Basic simulation (Doze + Standby)

```bash
doze-simulator --package=com.example.app --wait=30
```

### Enable verbose output

```bash
doze-simulator -p com.example.app -w 30 -v
```

### Disable colors (CI/CD)

```bash
doze-simulator --package=com.example.app --wait=60 --no-colors
```

### Reactivate the app at the end

```bash
doze-simulator -p com.example.app -w 20 -a
```

---

## 🎛 Flags

| Short | Long               | Description                        |
| ----- | ------------------ | ---------------------------------- |
| `-p`  | `--package <name>` | Target app package name (required) |
| `-w`  | `--wait <seconds>` | Idle simulation time (required)    |
| `-a`  | `--activate`       | Reactivate the app when finished   |
| `-v`  | `--verbose`        | Show detailed logs                 |
| `-n`  | `--no-colors`      | Disable ANSI colors (CI-safe)      |
| `-h`  | `--help`           | Show help menu                     |

---

## 📱 Requirements

* ADB installed
* Android device connected via USB
* Developer mode + USB debugging enabled
* The target package installed on the device

---

## ⚠️ Limitations

This tool **simulates** most of the internal logic of Doze / Standby, but does **not** replicate:

* OEM-specific battery killers (Samsung, Xiaomi, Huawei…)
* True 6–8 hours of device motion inactivity
* Long-term OS-level learning patterns

It provides a **fast and reliable approximation**, ideal for development and CI.

---

## 📄 License

This project is licensed under the **MIT License**.

---

## 🤝 Contributing

Pull requests and feature suggestions are welcome!

Ideas you can contribute:

* Custom Standby Bucket selection
* Doze timeline inspector
* Integration with logcat filters
* Saving session logs to file
* Dockerized environment for CI
