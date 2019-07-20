using Sockets
conn = Sockets.connect(8080)
write(conn,"Do you Hear me?\n")
