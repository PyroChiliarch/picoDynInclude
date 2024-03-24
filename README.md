DynInclude
==========

Script to dynamically include libraries, use `dynInclude()` instead of `include()`<br>
You only need to specify the library name and it will be auto downloaded and installed if not currently installed then included automatically.

A simple and easy way to include libraries in your cart without the hassle.

Will try to load libaries from the following locations in this order:<br>
1 - './lib'<br>
2 - '/appdata/system/lib'<br>
3 - '/system/lib'<br>
4 - The BBS system (Will attempt to download and install the library to `/appdata.system/lib`<br>

Usage:<br>
The below code will include the `basexx` library, automatically downloading and installing it if necessary

```lua
include("./dynInclude.lua")
dynInclude("basexx")

string = "hello world"
print("Raw: " .. string)
print("Bit (Base2)" .. basexx.to_bit(string))
print("Hex (Base16) " .. basexx.to_hex(string))
print("Base32 " .. basexx.to_base32(string))
print("Base64 " .. basexx.to_base64(string))
print("Crockford " .. basexx.to_crockford(string))
```

See the example folder for a cart that uses `dynInclude()`<br>
See https://github.com/PyroChiliarch/picoBasexx/blob/main/src/main.lua for an example installer.
