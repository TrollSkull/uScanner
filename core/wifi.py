from socket import gethostbyname, create_connection, error

def writeFile_1():
    file = open(".wifi_connection.sh", "w")
    file.write("""#!/bin/bash
export wifi='1'""")

def writeFile_0():
    file = open(".wifi_connection.sh", "w")
    file.write("""#!/bin/bash
export wifi='0'""")

def checkWifi():
    try:
        gethostbyname("google.com")
        conexion = create_connection(("google.com", 80), 1)
        conexion.close()
        writeFile_1

    except error:
        writeFile_0

checkWifi