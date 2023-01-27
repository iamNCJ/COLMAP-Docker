# COLMAP Toolkit Docker

Full [COLMAP](https://github.com/colmap/colmap) toolkit with latest [HLOC](https://github.com/cvg/Hierarchical-Localization) and [Pixel Perfect SfM](https://github.com/cvg/pixel-perfect-sfm) plugins included.

Python bindings ([pycolmap](https://github.com/colmap/pycolmap) & [pyceres](https://github.com/cvg/pyceres)) are included too.

## Direct Use

```bash
docker run -it --rm -u $(id -u):$(id -g) --ipc="host" ghcr.io/iamncj/colmap_toolkit:latest bash
```

## Build

```bash
docker build . -t ghcr.io/iamncj/colmap_toolkit:latest
```

## Environment

- Python: 3.8
- PyTorch: 1.13.1
- COLMAP: 3.8-dev
- Ceres: 2.1.0
