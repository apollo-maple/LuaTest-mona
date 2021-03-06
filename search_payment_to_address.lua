--特定のアドレスに対する入金を監視する
--watch payments into spcific address

local address = "YOUR_ADDRESS"

--txidを受け取ったトランザクションの中にaddress宛のtxoutがあればtableにそのモナの量と承認数を入れて返す関数
--If there are txouts for address in received txid's transaction, return table containing mona value and confirmation number.
function SearchTransaction(txid)
    tx_ret, tx_value = coind.getrawtransaction(txid,true)
    result = {}
    
    if tx_ret ~= true then
        return
    end
    for i, tx_val in pairs(tx_value["vout"]) do
        if tx_val["scriptPubKey"]["addresses"][0] == address then
            table.insert(result,{mona_val=tx_val["value"],n_conf=tx_value["confirmations"]})
        end
    end
    return result
end

function OnInit()
    print "search_payment_to_address loaded !!"
end

function OnBlockNotify(initioalsync, hash)
    if initialsync == true then
        return
    end
    block_ret, block_value = coind.getblock(hash)
    if block_ret ~= true then
        return
    end
    for i, block_val in pairs(block_value["tx"]) do
        result = SearchTransaction(block_val)
        for j, table in pairs(result) do
            print (string.format("new tx has entered into block! %f MONA.", table["mona_val"]))
        end
    end
end

function OnWalletNotify(txid)
    result = SearchTransaction(txid)
    for i, table in pairs(result) do
        if table["n_conf"]==nil then
                print (string.format("new transaction! %f MONA.",  table["mona_val"]))
        end
        if table["n_conf"]==1 then
                print (string.format("1 confirmation! %f MONA.", table["mona_val"]))
        end
    end
end
