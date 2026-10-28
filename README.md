# Generative AI Driver Update Toolkit & Windows Diagnostics Suite

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Platform: Windows](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078D6.svg)
![Language: Batchfile](https://img.shields.io/badge/Language-Batchscript-C1F12E.svg)
![Maintenance: Active](https://img.shields.io/badge/Maintained%3F-Yes-green.svg)
![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-brightgreen.svg)

An automated, lightweight, and safe Windows system maintenance batch toolkit designed to trigger native Windows Update driver scans, run system repair tools (SFC/DISM), diagnose disk errors, and collect graphics hardware diagnostics without installing third-party bloatware.

---

## 📋 Table of Contents

- [Project Purpose](#-project-purpose)
- [Key Features](#-key-features)
- [Pros & Cons](#-pros--cons)
- [Data Flow Diagram (DFD)](#-data-flow-diagram-dfd)
- [Entity-Relationship (ER) Diagram](#-entity-relationship-er-diagram)
- [Installation & Setup](#-installation--setup)
- [Usage Instructions](#-usage-instructions)
- [Limitations](#-limitations)
- [Known Bugs & Vulnerabilities](#-known-bugs--vulnerabilities)
- [Precautions & Safety Guidelines](#-precautions--safety-guidelines)
- [Contributing](#-contributing)
- [Star & Support](#-star--support)
- [Special Thanks](#-special-thanks)

---

## 🎯 Project Purpose

Many third-party driver update tools install unwanted adware, bundled applications, or untested display drivers that can cause system instability and BSODs (Blue Screen of Death). 

This project provides a clean, open-source native batch interface that leverages official Windows services (`UsoClient`, `wuauserv`, `DISM`, `SFC`, and `WMIC`) to safely scan, update, and repair system files and drivers—completely free of third-party bloatware.

---

## ✨ Key Features

- **Automated Windows Update Driver Search:** Uses `UsoClient` to trigger official background driver updates.
- **System File & Component Repair:** Integrates `sfc /scannow` and `DISM /RestoreHealth` repair workflows.
- **Hardware & Graphics Diagnostics:** Extracts GPU specs, display driver versions, and DirectX logs.
- **Drive Health Check:** Runs `chkdsk` and PowerShell physical disk queries.
- **Quick Settings Access:** Direct shortcuts to Device Manager, Display Settings, and Windows Update.

---

## ⚖️ Pros & Cons

### Pros
- **100% Safe & Native:** Uses built-in Windows binary services (`wuauserv`, `DISM`, `sfc`). No external executables required.
- **Zero Memory Footprint:** Executes entirely in command prompt and terminates cleanly.
- **Open Source:** Complete transparency—you can inspect every line of batch code before running.

### Cons
- **Windows Only:** Compatible strictly with Windows 10 and Windows 11.
- **Requires Admin Privileges:** Must be run as Administrator for DISM and SFC operations.
- **Dependent on Official Repositories:** Will not fetch non-WHQL or custom modded drivers.

---

## 📊 Data Flow Diagram (DFD)

### Level 0 DFD (System Overview)

```
 [ User ] ---> ( 1.0 Admin Check ) ---> [ Privilege Granted ]
                                                |
                                                v
                                   ( 2.0 Menu Selection )
                                                |
            +-------------------+---------------+-------------------+
            |                   |               |                   |
            v                   v               v                   v
   ( 3.0 Driver Engine ) ( 4.0 Repair Engine ) ( 5.0 Diagnostic ) ( 6.0 Exit )
            |                   |               |
            v                   v               v
  [ UsoClient/wuauserv ]    [ DISM / SFC ]    [ WMIC / DxDiag ]
            |                   |               |
            +-------------------+---------------+
                                |
                                v
                       [ Reports / System ]
```

---

## 🗂️ Entity-Relationship (ER) Diagram

While batch scripts do not use a SQL database, the operational entities and their functional relationships are mapped below:

```
+------------------------+             +------------------------+
|          USER          |             |     SYSTEM SCRIPT      |
+------------------------+             +------------------------+
| - User_ID (PK)         |  Executes   | - Script_Name (PK)     |
| - Admin_Privilege (BOOL)| ----------->| - Execution_Mode       |
+------------------------+             | - Target_Drive         |
            |                          +------------------------+
            | Operates                             |
            v                                      | Triggers
+------------------------+                         v
|    DIAGNOSTIC LOG      |             +------------------------+
+------------------------+             |    WINDOWS SERVICES    |
+ - Log_ID (PK)          |<------------+------------------------+
| - Timestamp            | Writes Logs | - Service_Name (PK)    |
| - Target_Path          |             | - Service_Status       |
| - Output_Content       |             +------------------------+
+------------------------+
```

---

## 🚀 Installation & Setup

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/alok-kumar8765/Generative-AI-Driver-Update-Toolkit.git
   cd Generative-AI-Driver-Update-Toolkit
   ```

2. **Manual Setup (Without Git):**
   - Copy the batch code from the repo file.
   - Open **Notepad**.
   - Paste the code.
   - Save the file as `GenerativeAI_Update_Drivers.bat`.
   - Change **Save as type** to **All Files (\*.\*)**.

---

## 💻 Usage Instructions

1. Right-click on `GenerativeAI_Update_Drivers.bat`.
2. Select **Run as Administrator**.
3. Choose the desired menu item (1–4):
   - `1` – Trigger Windows Update Driver Search & Installation
   - `2` – Open Windows Update Settings
   - `3` – Open Device Manager
   - `4` – Exit
4. Follow the on-screen prompts.

---

## ⚠️ Limitations

- **UsoClient Variations:** On certain custom Windows builds (e.g., LTSC or stripped editions), `UsoClient` commands may be suppressed by policy.
- **Offline Mode:** Requires an active Internet connection to download driver packages from Microsoft servers.

---

## 🐛 Known Bugs & Vulnerabilities

- **Vulnerabilities:** None identified. Script strictly executes built-in Windows commands without raw string execution vulnerabilities or third-party web downloads.
- **Bugs:** If the `wuauserv` (Windows Update) service is permanently disabled via Group Policy, option 1 will output an error until the service is enabled.

---

## 🛡️ Precautions & Safety Guidelines

- **Backup Data:** Always create a System Restore point before running repair operations on drives or Windows system components.
- **Failing Hardware Warning:** Do not run deep disk scans (`chkdsk /r`) on hard drives exhibiting physical clicking or grinding sounds.
- **Run as Admin:** Without elevated administrator permissions, commands such as DISM and SFC will fail to acquire necessary system file locks.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/NewFeature`).
3. Commit your Changes (`git commit -m 'Add new repair feature'`).
4. Push to the Branch (`git push origin feature/NewFeature`).
5. Open a Pull Request.

---

## ⭐ Star & Support

If you found this script helpful, please consider giving the repository a **⭐ Star** on GitHub! It helps more users discover safe, open-source Windows diagnostic tools.

---

## 🙌 Thanks

Special thanks to the open-source community, Windows system administration contributors, and modern PC diagnostic communities for documenting standard batch automation workflows.

---

**Maintained by:** [@alok-kumar8765](https://github.com/alok-kumar8765)