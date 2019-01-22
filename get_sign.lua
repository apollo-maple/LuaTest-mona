-- httpで外部から未署名txをGETしてきて署名発信する
-- GET unsigned txs from outside by using http and sign, broadcast them.


local ltn12 = require("ltn12")
local socket = require("socket")
local http = require("socket.http")
local cjson = require("cjson")

local get_response_body = {}

local get_res, get_code, get_response_headers = http.request{
  url = "YOUR_USING_URL",
  sink = ltn12.sink.table( get_response_body ),
}

if get_code == 200 then

    get_decoded_json = cjson.decode(table.concat(response_body))
    for key, val in pairs( get_decoded_json["rawtransaction"] ) do
        if key == "false" then
            sign_ret, sign_value = coind.signrawtransaction(val)
        end
        if sign_ret == true then
            print "---  succeeded in signing  ---"
            send_ret, send_value = coind.sendrawtransaction(sign_value["hex"], true)
        end
        if send_ret == true then
            print "---  succeeded in broadcasting  ---"
        end
    end

end


--[[
    json format
{
    "rawtransaction" : [
        {
            "signed" : "false"
            "hex" : "UNSIGNED_RAWTRANSACTION_HEX"
        }
    ]
}
]]
