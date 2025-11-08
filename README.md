![Demo](images/demo.webp)

- [Introduction](#introduction)
  - [Scanner](#scanner)
  - [Web panel](#web-panel)
- [Features](#features)
  - [Multi-Band Recording](#multi-band-recording)
  - [AI-Powered Audio Tagging](#ai-powered-audio-tagging)
  - [Satellite Tracking](#satellite-tracking)
  - [Scheduled Recording with Crontab](#scheduled-recording-with-crontab)
  - [Gain comparison](#gain-comparison)
- [Info](#info)
  - [YouTube](#youtube)
  - [Community](#community)
  - [Wiki](#wiki)
- [Screens](#screens)
  - [Data](#data)
  - [Configuration](#configuration)
- [Quickstart](#quickstart)
  - [Install docker](#install-docker)
  - [Run](#run)
  - [Web panel](#web-panel-1)
  - [Configuration](#configuration-1)
- [Advanced](#advanced)
  - [Update](#update)
  - [Build from sources](#build-from-sources)
  - [Debug](#debug)
- [Disclaimer](#disclaimer)
- [Contributing](#contributing)
- [Donations](#donations)
- [License](#license)

# Introduction

This project is **all in one** type, it combines two subprojects into one to allow easy launch them.

## Scanner

[sdr-scanner](https://github.com/shajen/rtl-sdr-scanner-cpp)

This project is a `C++` based SDR scanner designed to detect, record, and analyze multiple radio signals simultaneously across different frequency bands. It combines **high performance** with **flexibility**, supporting a **wide range of SDR devices** via [Soapy SDR](https://github.com/pothosware/SoapySDR) and [GNU Radio](https://github.com/gnuradio/gnuradio). Full list of supported devices/drivers [here](https://github.com/pothosware/SoapyOsmo/wiki).

## Web panel

[sdr-monitor](https://github.com/shajen/sdr-monitor)

Very powerful **web panel** to explore transmissions, spectrograms and configure sdr device.

# Features

## Multi-Band Recording

The scanner can **simultaneously scan and record multiple frequencies** (e.g., `108 MHz`, `144 MHz`, `440 MHz`, etc.) by rapidly switching between frequency ranges. This makes it possible to monitor wide portions of the spectrum in real time.

It can also **record several transmissions within the same band** - for example, if one signal is at `145.200 MHz` and another at `145.600 MHz`, both will be automatically captured and saved. Perfect for monitoring busy amateur or public service bands.

## AI-Powered Audio Tagging

The scanner now includes an **AI-based audio classifier** that automatically tags your recordings - distinguishing between noise, human speech, and other signal types. The model runs entirely locally for full privacy and performance. This makes it effortless to browse, filter, and replay.

## Satellite Tracking

The scanner now includes **automatic satellite tracking**! Simply enter your location coordinates and an API key (from [n2y0.com](https://n2yo.com/api/)) and the scanner will fetch upcoming satellite passes over your area. When a satellite is in range, it will **automatically tune, track, and record** the transmission - no manual setup needed. Perfect for capturing real-time signals from weather satellites, ISS, and more!

Keep in mind that **receiving satellite signals requires a good-quality antenna, precise radio calibration, and minimal interference** for best results. With proper setup, you can effortlessly capture real-time signals from weather satellites, the ISS, and more!

## Scheduled Recording with Crontab

You can now schedule automatic recordings using simple crontab-style entries. Define exact times or recurring intervals to start recording transmissions - ideal for capturing periodic signals, beacon transmissions. Once configured, the scanner handles everything automatically, so you’ll never miss an interesting signal again!

## Gain comparison

The scanner can now **automatically test all available gain settings** for your SDR device and **capture short spectrogram samples** for each configuration. These results are then displayed in a **side-by-side visual view**, making it easy to compare signal quality and noise levels across different gain values. With just one scan, you can instantly **identify the optimal gain settings** for your hardware and environment - no more tedious manual tuning.

# Info

## YouTube

Video [here](https://www.youtube.com/watch?v=YzQ2N0VkKvE), thanks to **Tech Minds**!

## Community

Join our [discord server](https://discord.gg/f2cqeMh6Dh) to get help, share ideas, or contribute.

## Wiki

Many useful instructions and information are on the [wiki](https://github.com/shajen/sdr-hub/wiki).

# Screens

## Data

| Spectrogram                        | Transmission                        |
| ---------------------------------- | ----------------------------------- |
| ![](images/spectrograms.png?raw=1) | ![](images/transmissions.png?raw=1) |
| ![](images/spectrogram.png?raw=1)  | ![](images/transmission.png?raw=1)  |

## Configuration

| Scanner                      | Groups                       |
| ---------------------------- | ---------------------------- |
| ![](images/config.png?raw=1) | ![](images/groups.png?raw=1) |

# Quickstart

## Install docker

If you do not have `docker` installed, follow the instructions [here](https://docs.docker.com/desktop/) to install `docker`.

## Run

```
docker run --rm -p 8000:80 -v ./data:/app/data -v ./log:/var/log/sdr --device /dev/bus/usb:/dev/bus/usb shajen/sdr-hub
```

All collected data and config will be permanently saved in the local `data` directory.

All logs will be permanently saved in the local `log` directory.

## Web panel

Default web panel address is [http://127.0.0.1:8000/](http://127.0.0.1:8000/), default login: `admin`, password: `password`.

## Configuration

Customize and save settings to `.env` file:

```
TZ=Europe/Warsaw
SECRET_KEY=0123456789012345678901234567890123456789
```

where:

- `TZ` - your time zone
- `SECRET_KEY` - enter your randomly selected key

Then run by:
```
docker run --rm --env-file .env -p 8000:80 -v ./data:/app/data -v ./log:/var/log/sdr --device /dev/bus/usb:/dev/bus/usb shajen/sdr-hub
```

# Advanced

## Update

To update to the latest version just pull docker image `docker pull shajen/sdr-hub` and run again.

## Build from sources

Clone repository and run:

```
export SDR_MONITOR_IMAGE=shajen/sdr-monitor:latest # enter the selected image
export SDR_SCANNER_IMAGE=shajen/sdr-scanner:latest # enter the selected image

docker build -t shajen/sdr-hub --build-arg SDR_MONITOR_IMAGE --build-arg SDR_SCANNER_IMAGE .
```
## Debug

All logs are stored in the `/var/log/sdr/` directory in the docker container.

You can [download](http://127.0.0.1:8000/sdr/logs/) the archive with all `logs` in the `Debug` tab.

Please attach the `logs` when reporting a bug. **Issues without logs will be closed quickly!**

# Disclaimer

This software may receive and record radio signals. Use it legally — the authors take no responsibility for misuse or unlawful recording.

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
