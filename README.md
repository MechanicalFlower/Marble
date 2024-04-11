
<div align="center">

# ⚽ Marble

![Godot Badge](https://img.shields.io/badge/godot-4.2-blue?logo=Godot-Engine&logoColor=white)
![license](https://img.shields.io/badge/license-MIT-green?logo=open-source-initiative&logoColor=white)
![reuse](./.reuse/REUSE-compliant.svg)

A marble race minigame, made with [Godot Engine](https://godotengine.org/).

<a href="https://github.com/mechanicalflower/Marble/releases/" target="_blank"><img src="public/publishing/store/github.webp" alt="Download on Github" height="40px" ></a>
<a href="https://mechanical-flower.itch.io/marble" target="_blank"><img src="public/publishing/store/itchio.webp" alt="Download on itch.io" height="40px" ></a>
<a href="https://snapcraft.io/marble-race"><img alt="Get it from the Snap Store" src="https://snapcraft.io/static/images/badges/en/snap-store-black.svg" height="40px"/></a>
<a href="https://github.com/mechanicalflower/Marble/releases/"><img alt="Download as AppImage" src="https://docs.appimage.org/_images/download-appimage-banner.svg" height="40px"/></a>
<!-- <a href="https://flathub.org/apps/details/org.mechanicalflower.Marble" target="_blank"><img src="https://flathub.org/assets/badges/flathub-badge-en.png" alt="Download on Flathub"  height="40px"></a> -->

</div>

## About

Marble is an open source mini-game about marble racing.

### Controls

- `Tab` to follow an other marble.
- `ESC` to open and close menu.

### Features

- Name your marbles.
- Start procedural races.
- Watch the real-time ranking.

There are two racing modes: **normal** and **explosion**.

In **explosion**, a timer starts, and when it reaches zero the last marble explodes.
The race is infinite, and the game ends when only one marble remains.

### Screenshots

<div align="center">

<img src="public/publishing/screenshots/screenshot1.png" width="30%"> <img src="public/publishing/screenshots/screenshot2.png" width="30%"> <img src="public/publishing/screenshots/screenshot3.png" width="30%"> <img src="public/publishing/screenshots/screenshot4.png" width="30%"> <img src="public/publishing/screenshots/screenshot5.png" width="30%"> <img src="public/publishing/screenshots/screenshot6.png" width="30%">

</div>

## Installation

### From a release

Released binaries are available on Itch.io and
on the Github repository, in the release section.

Download the zip archive, accordingly to your OS, and unzip it.

- **Windows**: Double click on `Marble.exe`.
- **MacOS**: Double click on `Marble.app`.
- **Linux**: In a terminal, run `./Marble.x86_64`.

### From Snap

With the [Snap command line](https://manpages.ubuntu.com/manpages/focal/en/man8/snap.8.html), run:
```
snap install marble-race
```

To run the game:
```
marble-race.marble
```

### From an AppImage

The AppImage is available on the Github
 repository, in the release section.

More details on how to run an AppImage, on the
 [official documentation](https://docs.appimage.org/introduction/quickstart.html#how-to-run-an-appimage).

### From source

> [!IMPORTANT]
> For this installation, you need to have
> the Godot Editor installed.

Clone the source locally:
```
git clone https://github.com/MechanicalFlower/Marble.git
```

You need to install addons first:
```
godot --headless --script plug.gd install
```

And simply run the game as any Godot project:
```
godot
```

## Development

The project use:
- [`just`](https://just.systems/man/en/) as command runner,
- [`pre-commit`](https://pre-commit.com/) to run formatters, this requires [Python 3](https://docs.python.org/3/).

> [!IMPORTANT]
> Actually, `just` recipes only support Linux.

To check all available recipes, run:
```
just
```

To run formatters:
```
just fmt
```

To install, and run the game:
```
just install-addons
just godot
```

> [!TIP]
> In `just` recipes, the Godot Editor is installed
> automatically. This ensure that you
> use the right version of the engine.

## Contributing

![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)

We welcome community contributions to this project.

Please read our [Contributor Guide](CONTRIBUTING.md) for more information on how to get started.

## Releasing

Please read our [Release Guide](RELEASING.md) for more information on how we manage our releases.
