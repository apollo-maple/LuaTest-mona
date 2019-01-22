local address = "YOUR_ADDRESS"

function SearchTransaction(txid, message)
    tx_ret, tx_value = coind.gettransaction(txid)

    if tx_ret == true then
        for j, tx_val in pairs(tx_value["details"]) do
            if(tx_val["address"] == address && tx_val["category"] == "receive")) then
                print "---------------------------------------------------\n"
                print (string.format(message." %f MONA.", val["amount"]))
                print "\n---------------------------------------------------"
            end
        end
    end
end



function OnBlockNotify(initioalsync, hash)
    block_ret, block_value = coind.getblock(hash)

    if block_ret == true then
        for i, block_val in pairs(block_value["tx"]) then
            SearchTransaction(txid, "1 confirmation.")
        end
    end

end


function OnWalletNotify(txid)
    SearchTransaction(txid, "new transaction has come.")

end


