--[[pod_format="raw",created="2024-03-23 22:45:10",modified="2024-03-25 09:52:04",revision=30]]
include("./dynInclude.lua")
dynInclude("basexx")

string = "hello worldaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
print("Raw: " .. string)
print("Bit (Base2)" .. basexx.to_bit(string))
print("Hex (Base16) " .. basexx.to_hex(string))
print("Base32 " .. basexx.to_base32(string))
print("Base64 " .. basexx.to_base64(string))
print("Crockford " .. basexx.to_crockford(string))
