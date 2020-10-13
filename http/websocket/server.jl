using HTTP

#WebSocket Examples
@async HTTP.WebSockets.listen("127.0.0.1", UInt16(8081)) do ws
    while !eof(ws)
        data = readavailable(ws)
        write(ws, data[end:-1:begin])
    end
end

