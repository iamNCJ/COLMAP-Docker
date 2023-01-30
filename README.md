# COLMAP Toolkit Docker

Full [COLMAP](https://github.com/colmap/colmap) toolkit with latest [HLOC](https://github.com/cvg/Hierarchical-Localization) and [Pixel Perfect SfM](https://github.com/cvg/pixel-perfect-sfm) plugins included.

Python bindings ([pycolmap](https://github.com/colmap/pycolmap) & [pyceres](https://github.com/cvg/pyceres)) are included too.

## Direct Use

```bash
docker run -it --rm -u $(id -u):$(id -g) --ipc="host" ghcr.io/iamncj/colmap_toolkit:latest bash
```

## Use For VSCode Dev Container

```bash
cp -r example-devcontainer /PATH/TO/YOUR/WORKSPACE/.devcontainer
```

Then reopen your workspace in container.

## Build

```bash
docker build . -t ghcr.io/iamncj/colmap_toolkit:latest
```

## Environment

### Tag 230128 / latest

- CUDA Runtime: 11.6.2
- Python: 3.8.10
- PyTorch: 1.13.1
- Torchvision: 0.14.1
- COLMAP: 3.8-dev@[1f31e94](https://github.com/colmap/colmap/tree/1f31e94)
- pycolmap: 0.4.0@[391a1c2](https://github.com/colmap/pycolmap/tree/391a1c28110fd6c61b4c6550e1e19bc4295398a5)
- Ceres: 2.1.0
