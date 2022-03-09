# Comprehensive compiling info: [MOM6-examples wiki](https://github.com/NOAA-GFDL/MOM6-examples/wiki/Getting-started#compiling-the-models)

The following example is for the NEP regional model (as of 6-23-2021) and may not be relevant for all computing systems

## Clone MOM6-examples respository

```rust
git clone git@github.com:NOAA-GFDL/MOM6-examples.git
git clone git@github.com:CICE-Consortium/Icepack.git
```

## General repository/ compile script compatibility instructions:

```rust
cd MOM6-examples
git submodule update --init --recursive
cd ../Icepack
git submodule update --init --recursive
```
if using the gregorian calendar to initialize (as with demo), make the following changes:
	
- MOM6-examples/src/coupler/coupler_main.F90:
```python
- Line 319: use time_manager_mod,        only: operator (*), THIRTY_DAY_MONTHS, JULIAN
+ Line 319: use time_manager_mod,        only: operator (*), THIRTY_DAY_MONTHS, JULIAN, GREGORIAN

+ Line 1290: case( 'GREGORIAN' )
+ Line 1291:   calendar_type = GREGORIAN
```
