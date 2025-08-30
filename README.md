# Introduction

This project is **all in one** type, it combines two subprojects into one to allow easy launch them.

## Scanner

[https://github.com/shajen/rtl-sdr-scanner-cpp](https://github.com/shajen/rtl-sdr-scanner-cpp)

This project contains sdr scanner written in `c++` to **scan and record multiple interesting frequencies bandwidth in the same time** (eg. `108 MHz`, `144 MHz`, `440 Mhz`,  etc). This is possible by switching quickly between frequencies bandwidth.

Scanner also allows you to record multiple transmissions simultaneously (if they are transmitted on the same band). For example, if one transmission is on `145.200` MHz and the other is on `145.600 MHz`, the scanner will record and save both!

Scanner use [Soapy SDR](https://github.com/pothosware/SoapySDR) and [GNU Radio](https://github.com/gnuradio/gnuradio) to get data so it support all devices that are supported by `Soapy SDR`. Full list of supported devices [here](https://github.com/shajen/rtl-sdr-scanner-cpp/wiki/Supported-devices).

## Web panel

[https://github.com/shajen/sdr-monitor](https://github.com/shajen/sdr-monitor)

Very powerful **web panel** to explore transmissions, spectrograms and configure sdr device.

# Screens

## Data

| Spectrogram | Transmission |
| - | - |
| ![](images/spectrograms.png?raw=1) | ![](images/transmissions.png?raw=1) |
| ![](images/spectrogram.png?raw=1) | ![](images/transmission.png?raw=1) |

## Configuration

| Scanner | Groups |
| - | - |
| ![](images/config.png?raw=1) | ![](images/groups.png?raw=1) |

# Quickstart

## Install docker

If you do not have `docker` installed, follow the instructions [here](https://docs.docker.com/desktop/) to install `docker`.

## Run

```
docker run --rm -p 8000:80 -v ./data:/app/data --device /dev/bus/usb:/dev/bus/usb shajen/sdr-hub
```

All collected data will be permanently saved in the local `data` directory.

## Web panel

Default web panel address is [http://127.0.0.1:8000/](http://127.0.0.1:8000/), default login: `admin`, password: `password`.

## Advanced configuration

Customize and save settings to `.env` file:

```
TZ=Europe/Warsaw                                     # enter your time zone
SPECTROGRAMS_TOTAL_SIZE_GB=20                        # keep only the last n GB of spectrograms, 0 for unlimited
TRANSMISSIONS_TOTAL_SIZE_GB=20                       # keep only the last n GB of transmissions, 0 for unlimited
SECRET_KEY=0123456789012345678901234567890123456789  # enter your randomly selected key
```

Then run by:
```
docker run --rm --env-file .env -p 8000:80 -v ./data:/app/data --device /dev/bus/usb:/dev/bus/usb shajen/sdr-hub
```

## Debug

All logs are stored in the `/var/log/sdr/` directory in the docker container. Please attach the entire directory when reporting a bug.

# Wiki

Many useful instructions and information are on the [wiki](https://github.com/shajen/sdr-hub/wiki).

# Contributing

In general don't be afraid to send pull request. Use the "fork-and-pull" Git workflow.

1. **Fork** the repo
2. **Clone** the project to your own machine
3. **Commit** changes to your own branch
4. **Push** your work back up to your fork
5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the **latest** from **upstream** before making a pull request!

# Donations

If you enjoy this project and want to thanks, please use follow link:

- [PayPal](https://www.paypal.com/donate/?hosted_button_id=6JQ963AU688QN)
- [Revolut](https://revolut.me/borysm2b)
- BTC address: 18UDYg9mu26K2E3U479eMvMZXPDpswR7Jn

# License

[![License](https://img.shields.io/:license-GPLv3-blue.svg?style=flat-square)](https://www.gnu.org/licenses/gpl.html)

- *[GPLv3 license](https://www.gnu.org/licenses/gpl.html)*
