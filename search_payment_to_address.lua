local address = "YOUR_ADDRESS"

function SearchTransaction(txid)
    tx_ret, tx_value = coind.getrawtransaction(txid,true)
    exist = false
    mona_val = 0

    if tx_ret == true then
        for j, tx_val in pairs(tx_value["vout"]) do
            if (tx_val["scriptPubKey"]["addresses"][0] == address) then
                exist = true
                mona_val = tx_val["value"]
            end
        end
    end
    return exist,mona_val,tx_value["confirmations"]
end

function OnInit()
    print ("search_payment_to_address loaded !!")
end

function OnBlockNotify(initioalsync, hash)
    block_ret, block_value = coind.getblock(hash)

    if block_ret == true then
        for i, block_val in pairs(block_value["tx"]) do
            exist,mona_val,n_conf = SearchTransaction(block_val)
            if (exist==true) then
                print (string.format("new tx has entered into block! %f MONA.", mona_val))
            end
        end
    end
end

function OnWalletNotify(txid)
    exist,mona_val,n_conf = SearchTransaction(txid)
    if (exist==true) and (n_conf==nil) then
            print (string.format("new transaction! %f MONA.",  mona_val))
    end
    if (exist==true) and (n_conf==1) then
            print (string.format("1 confirmation! %f MONA.", mona_val))
    end
end
