## FPFIS Varnish image [![Build Status](https://drone.fpfis.eu/api/badges/fpfis/varnish/status.svg?branch=master)](https://drone.fpfis.eu/fpfis/varnish)


Image is named `fpfis/varnish` and are based on Ubuntu.

## Supported version

 - 4.1 [![Docker Image](https://images.microbadger.com/badges/image/fpfis/varnish:4.1.svg)](https://microbadger.com/images/fpfis/varnish) 
 - 6 [![Docker Image](https://images.microbadger.com/badges/image/fpfis/varnish:6.svg)](https://microbadger.com/images/fpfis/varnish) 

## VMOD included

The following vmods have been included :

 - [Varnish extra vmods](https://github.com/varnish/varnish-modules)
 - [Drupal 7](https://git.kindwolf.org/libvmod-drupal7/)

## Configuration

### Environment configuration


| env                        | Description                        |  Default          |
|----------------------------|------------------------------------|-------------------|
|`HTTP_PORT`                 | Port to listen on                  | `8086` 
|`MAX_MEMORY`                | Maximum memory to use for caching  | `1G  ` 
|`YAML_CONF`                 | YAML file to read backend config   | `/config.yaml` 


The backend must be defined in a YAML file mounted as a volume.

The syntax is as follow :

### Simple configuration

```yaml 
varnish:
  sites:
    default:
    nodes:
      - host: web
        port: 8080
```

### Load balancer with routing

```yaml
varnish:
  sites:
    site1:
      path: /site1
      base64auth: pxosizjpiweqw
      nodes:
        - host: web01
          port: 8888
        - host: web02
          port: 8888
    site1static:
      path: /site1/static
      base64auth: pxosizjpiweqw
      nodes:
        - host: web01
          port: 8889
        - host: web02
          port: 8889
    site2:
      path: /site2
      base64auth: pxosizjpiweqw
      nodes:
        - host: web03
          port: 8888
        - host: web04
          port: 8888
    site2static:
      path: /site2/static
      base64auth: pxosizjpiweqw
      nodes:
        - host: web03
          port: 8889
        - host: web04
          port: 8889
```

## Mouting VCL volume

VCL must be mounted in `/etc/varnish` and a `default.vcl` should be present.
You should also make sure to include `/tmp/directors.vcl` in your VCL to setup the backends.

## Example

Assuming you have a working VCL with `default.vcl` in your local `varnish` folder :

```bash
docker run -p 8086:8086 -ti --rm -e YAML_CONF=/yaml.conf -v $(pwd)/config.yaml:/config.yaml -v $(pwd)/varnish:/etc/varnish fpfis/varnish:4.1 
```

___

