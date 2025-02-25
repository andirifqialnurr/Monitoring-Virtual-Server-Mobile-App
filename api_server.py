from audioop import mul
import json
from flask import Flask, render_template, request, jsonify, redirect, url_for
import requests
import paramiko
import mysql.connector
import hashlib
import time
import threading


def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="123",
        database="db_test",
        auth_plugin="mysql_native_password"
    )

app = Flask(__name__)


# -----------------------------------------------------------------------------------


# Fungsi helper untuk mengukur waktu
def measure_time():
    return time.time()


def is_admins_exists(identifier):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        query = "SELECT COUNT(*) FROM admins WHERE username = %s OR email = %s"
        cursor.execute(query, (identifier, identifier))
        count = cursor.fetchone()[0]
        return count > 0
    finally:
        cursor.close()
        conn.close()


def is_hosts_exists(identifier):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        query = f"SELECT COUNT(*) FROM hosts WHERE ip_address = '{identifier}'"
        cursor.execute(query)
        count = cursor.fetchone()[0]
        return count > 0
    finally:
        cursor.close()
        conn.close()


def verify_password(hashed_password, password):
    algorithm = "sha256"
    hashed_input_password = hashlib.new(algorithm, password.encode()).hexdigest()
    return hashed_password == hashed_input_password


def generate_password_hash(password):
    algorithm = "sha256"
    hashed_password = hashlib.new(algorithm, password.encode()).hexdigest()
    return hashed_password


# Route untuk register
@app.route("/registerAdmin", methods=["POST"])
def registerAdmin():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()

    try:

        if request.method == "POST":
            name = request.form.get("name")
            username = request.form.get("username")
            email = request.form.get("email")
            password = request.form.get("password")

            hash_pass = generate_password_hash(password)

            if not name or not username or not email or not password:
                return jsonify({"message": "Missing required fields"}), 400
            if is_admins_exists(username):
                return jsonify({"message": "Username already exists"}), 400
            if is_admins_exists(email):
                return jsonify({"message": "Email already exists"}), 400

            query = "SELECT * FROM admins WHERE username = %s OR email = %s"
            values = (username, email)
            cursor.execute(query, values)
            result = cursor.fetchall()
            if len(result) > 0:
                return jsonify({"message": "Username or email already exists"}), 400

            query = "INSERT INTO admins (name, username, email, password) VALUES (%s, %s, %s, %s)"
            values = (name, username, email, hash_pass)
            cursor.execute(query, values)
            conn.commit()

            querys = "SELECT * FROM admins WHERE email = %s"
            values = (email,)
            cursor.execute(querys, values)
            admins = cursor.fetchone()

            response = {
                "data": {
                    "admin": {
                        "id": admins[0],
                        "name": admins[1],
                        "username": admins[2],
                        "email": admins[3],
                        "profile_photo": admins[5],
                    },
                }
            }

            # Menghitung waktu respons
            end_time = measure_time()
            response_time = end_time - start_time

            # Mencetak waktu respons di konsol
            print(
                f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
            )
            return jsonify(response), 200
        return jsonify({"message": "Invalid request method"}), 405
    finally:
        conn.close()
        cursor.close()


@app.route("/loginAdmin", methods=["POST"])
def loginAdmin():
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        if request.method == "POST":
            # Mulai mengukur waktu sebelum operasi dimulai
            start_time = measure_time()

            email = request.form.get("email")
            password = request.form.get("password")

            queryss = "SELECT * FROM admins WHERE LOWER(email) = LOWER(%s)"
            valuess = (email,)
            cursor.execute(queryss, valuess)
            result = cursor.fetchone()
            if result is None:
                return jsonify({"message": "Invalid weh"}), 401

            admins = {
                "id": result[0],
                "name": result[1],
                "username": result[2],
                "email": result[3],
                "password": result[4],
                "profile_photo": result[5],
            }

            if not verify_password(admins["password"], password):
                return (
                    jsonify({"message": "Invalid araan", "password": admins["password"]}),
                    401,
                )

            # Menghitung waktu respons
            end_time = measure_time()
            response_time = end_time - start_time

            # Mencetak waktu respons di konsol
            print(
                f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
            )

            response = {
                "data": {
                    "admin": {
                        "id": admins["id"],
                        "name": admins["name"],
                        "username": admins["username"],
                        "email": admins["email"],
                        "profile_photo": admins["profile_photo"],
                    },
                }
            }
            return jsonify(response), 200
    finally:
        cursor.close()
        conn.close()


# -------------------------------------------------------------------------------


# register hosts API 2
@app.route("/registerHosts", methods=["GET", "POST"])
def registerHosts():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()

    try:

        global ip_address, cookie, node_name, username, password, ports

        if request.method == "POST":
            ip_address = request.form.get("ip_address")
            username = request.form.get("username")
            password = request.form.get("password")
            ports = request.form.get("port")

            if ports is None or not ports.strip():
                ports = "8006"

            url = f"https://{ip_address}:{ports}/api2/json/access/ticket?username={username}@pam&password={password}"

            # get the node data
            x = requests.post(url, verify=False)
            result = x.json()

            usernameFromProxmox = result["data"]["username"]

            if not ip_address or not username or not password:
                return jsonify({"message": "Missing required fields"}), 400
            if is_hosts_exists(ip_address):
                return jsonify({"message": "IP Address already exists"}), 400

            query = "SELECT * FROM hosts WHERE ip_address = %s"
            values = (ip_address,)
            cursor.execute(query, values)
            db_result = cursor.fetchall()
            if len(db_result) > 0:
                return jsonify({"message": "IP Address already exists"}), 400

            # Insert data login into database
            sql = "INSERT INTO hosts (ip_address, port, username, password, usernameFromProxmox) VALUES (%s, %s, %s, %s, %s)"
            val = (
                ip_address,
                ports,
                username,
                password,
                usernameFromProxmox,
            )
            cursor.execute(sql, val)
            conn.commit()

            # Get All Data
            querys = "SELECT * FROM hosts WHERE ip_address = %s"
            values = (ip_address,)
            cursor.execute(querys, values)
            hosts = cursor.fetchone()

            # Cookie for login
            cookie = {
                "PVEAuthCookie": result["data"]["ticket"],
                "Path": "/",
                "Domain": ip_address,
            }

            # Menghitung waktu respons
            end_time = measure_time()
            response_time = end_time - start_time

            # Mencetak waktu respons di konsol
            print(
                f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
            )

            # Return the Response
            response = {
                "data": {
                    "host": {
                        "id": hosts[0],
                        "ip_address": hosts[1],
                        "port": hosts[2],
                        "username": hosts[3],
                        "usernameFromProxmox": hosts[5],
                    },
                },
            }

        return jsonify(response)
    finally:
        conn.close()
        cursor.close()
    


# login hosts API
@app.route("/loginHosts", methods=["POST"])
def loginHosts():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()
    global ip_address, cookie, node_name, username, password, ports

    try:

        if request.method == "POST":
            data = request.get_json()
            ip_address = data.get("ip_address")
            ports = data.get("port")
            username = data.get("username")
            password = data.get("password")

            # Validasi parameter
            if not ip_address or not username or not password:
                return (
                    jsonify(
                        {"message": "IP address, username, and password are required."}
                    ),
                    400,
                )

            # Melakukan pengecekan login
            query = "SELECT * FROM hosts WHERE ip_address = %s"
            values = (ip_address,)
            cursor.execute(query, values)
            hosts = cursor.fetchone()

            if hosts is None:
                return (
                    jsonify({"message": "Host is missing"}),
                    400,
                )

            # login ke server
            url = f"https://{ip_address}:{ports}/api2/json/access/ticket?username={username}@pam&password={password}"

            x = requests.post(url, verify=False)
            result = x.json()
            cookie = {
                "PVEAuthCookie": result["data"]["ticket"],
                "Path": "/",
                "Domain": ip_address,
            }

            # Menghitung waktu respons
            end_time = measure_time()
            response_time = end_time - start_time

            # Mencetak waktu respons di konsol
            print(
                f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
            )

            response = {
                "data": {
                    "host": {
                        "id": hosts[0],
                        "ip_address": hosts[1],
                        "port": hosts[2],
                        "username": hosts[3],
                        "usernameFromProxmox": hosts[5],
                    },
                    "token": {
                        "ticket": result["data"]["ticket"],
                    },
                },
            }

            return jsonify(response), 200
    finally:
        cursor.close()
        conn.close()
    


@app.route("/updateHosts/<int:id>", methods=["PUT", "POST"])
def updateHost(id):
    conn = get_db_connection()
    cursor = conn.cursor()

    try:

        if request.method == "PUT":
            print("Received data:", request.get_json())

            # Mengambil data baru dari request body
            data = request.get_json()
            ip_address = data.get("ip_address")
            port = data.get("port")
            username = data.get("username")
            password = data.get("password")

            print("Parsed data:", ip_address, port, username, password)

            query = "UPDATE hosts SET ip_address = %s, port = %s, username = %s, password = %s WHERE id = %s"
            values = (ip_address, port, username, password, id)

            cursor.execute(query, values)
            conn.commit()

            # Mengambil data host setelah update
            cursor.execute("SELECT * FROM hosts WHERE id = %s", (id,))
            updated_host = cursor.fetchone()

            if updated_host:
                host_data = {
                    "id": updated_host[0],
                    "ip_address": updated_host[1],
                    "port": updated_host[2],
                    "username": updated_host[3],
                    "password": updated_host[4],
                    "usernameFromProxmox": updated_host[5],
                }
                return jsonify({"data": host_data}), 200
            else:
                return jsonify({"message": "Host not found"}), 404
    except Exception as e:
        print(str(e))
        return jsonify({"message": "Internal server error"}), 500
    finally:
        cursor.close()
        conn.close()


# get all host hosts into list
@app.route("/getHosts", methods=["GET"])
def get_host():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()

    try:
        if request.method == "GET":
            try:
                query = "SELECT * FROM hosts"
                cursor.execute(
                    query,
                )
                hosts = cursor.fetchall()
                if len(hosts) == 0:
                    return jsonify({"message": "Host not found"}), 404

                # Create a list to store host data
                host_list = []

                # Iterate through the hosts and convert each host to a dictionary
                for host in hosts:
                    host_data = {
                        "id": host[0],
                        "ip_address": host[1],
                        "port": host[2],
                        "username": host[3],
                        "usernameFromProxmox": host[5],
                    }
                    host_list.append(host_data)

                # Menghitung waktu respons
                end_time = measure_time()
                response_time = end_time - start_time

                # Mencetak waktu respons di konsol
                print(
                    f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
                )

                # Create a response JSON containing the list of hosts
                response = {"data": host_list}

                return jsonify(response), 200
            except Exception as e:
                print(str(e))
                return jsonify({"message": "Internal server error"}), 500
    finally:
        cursor.close()
        conn.close()
    
@app.route("/hosts/<int:id>", methods=["GET"])
def getHostById(id):
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        query = "SELECT * FROM hosts WHERE id = %s"
        cursor.execute(query, (id,))
        host = cursor.fetchone()
        
        if host:
            host_data = {
                "id": host[0],
                "ip_address": host[1],
                "port": host[2],
                "username": host[3],
                "usernameFromProxmox": host[5],
            }
            return jsonify({"data": host_data}), 200
        else:
            return jsonify({"message": "Host not found"}), 404
    except Exception as e:
        print(str(e))
        return jsonify({"message": "Internal server error"}), 500
    finally:
        cursor.close()
        conn.close()


# Get Node
@app.route("/getNode", methods=["GET"])
def get_node():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()
    global ip_address, ports, cookie

    try:
        if not ip_address or not cookie:
            return jsonify({"message": "Unauthorized"}), 401

        # Mendapatkan daftar node
        get_node_url = f"https://{ip_address}:{ports}/api2/json/nodes"
        node_response = requests.get(get_node_url, verify=False, cookies=cookie)
        nodes = node_response.json()

        # Menambahkan index ke setiap node dalam daftar
        for index, node in enumerate(nodes["data"]):
            node["index"] = index

        # Menghitung waktu respons
        end_time = measure_time()
        response_time = end_time - start_time

        # Mencetak waktu respons di konsol
        print(
            f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
        )

        response = {
            "nodes": {
                "data": nodes["data"],
            },
        }
        return jsonify(response)
    finally:
        cursor.close()
        conn.close()


# Get Node By ID
@app.route("/getNodeByIndex/<int:index>", methods=["GET"])
def get_node_by_name(index):
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()

    global ip_address, ports, cookie, node_name

    try:
        if not ip_address or not cookie:
            return jsonify({"message": "Unauthorized"}), 401

        # Mendapatkan detail node berdasarkan nama
        get_node_url = f"https://{ip_address}:{ports}/api2/json/nodes"
        node_response = requests.get(get_node_url, verify=False, cookies=cookie)
        nodes = node_response.json()["data"]

        if index < 0 or index >= len(nodes):
            return jsonify({"message": "Invalid index"}), 400

        node = nodes[index]
        node["index"] = index

        node_name = node["node"]

        # Menghitung waktu respons
        end_time = measure_time()
        response_time = end_time - start_time

        # Mencetak waktu respons di konsol
        print(
            f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
        )

        response = {
            "data": node,
        }

        return jsonify(response)
    
    finally:
        cursor.close()
        conn.close()


# -------------------------------------------------------------------------------


@app.route("/vm", methods=["GET"])
def vm():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()
    global cookie

    try:
        if request.method == "GET":
            # Check if the cookie and node_name are available
            if cookie is None or node_name is None:
                return jsonify({"message": "Unauthorized"}), 401

            vm = f"https://{ip_address}:{ports}/api2/json/nodes/{node_name}/qemu"
            vmResult = requests.get(vm, verify=False, cookies=cookie)
            sourceVM = vmResult.json()

            # Menghitung waktu respons
            end_time = measure_time()
            response_time = end_time - start_time

            # Mencetak waktu respons di konsol
            print(
                f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
            )

            response = {
                "node_name": node_name,
                "vms": {
                    "data": sourceVM["data"],
                },
            }

            return jsonify(response)
    finally:
        cursor.close()
        conn.close()


@app.route("/virtualmachines/<int:id>", methods=["GET"])
def virtualmachines(id):
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()
    global cookie

    try:
        if request.method == "GET":
            url = f"https://{ip_address}:{ports}/api2/json/nodes/{node_name}/qemu/{id}/status/current"
            x = requests.get(url, verify=False, cookies=cookie)
            result = x.json()

            # Menghitung waktu respons
            end_time = measure_time()
            response_time = end_time - start_time

            # Mencetak waktu respons di konsol
            print(
                f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
            )

            return jsonify(result)
    finally:
        cursor.close()
        conn.close()


@app.route("/container", methods=["GET"])
def container():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()
    global cookie

    try:
        if request.method == "GET":
            # Check if the cookie and node_name are available
            if cookie is None or node_name is None:
                return jsonify({"message": "Unauthorized"}), 401

            container = f"https://{ip_address}:{ports}/api2/json/nodes/{node_name}/lxc"
            conResult = requests.get(container, verify=False, cookies=cookie)
            sourceContainer = conResult.json()

            for container_data in sourceContainer["data"]:
                container_data["vmid"] = int(container_data["vmid"])

            # Menghitung waktu respons
            end_time = measure_time()
            response_time = end_time - start_time

            # Mencetak waktu respons di konsol
            print(
                f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
            )

            response = {
                "node_name": node_name,
                "containers": {
                    "data": sourceContainer["data"],
                },
            }

            return jsonify(response), 200
    finally:
        cursor.close()
        conn.close()


@app.route("/containerview/<int:id>")
def containerview(id):
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()

    try:
        url = f"https://{ip_address}:{ports}/api2/json/nodes/{node_name}/lxc/{id}/status/current"
        x = requests.get(url, verify=False, cookies=cookie)
        result = x.json()

        # Menghitung waktu respons
        end_time = measure_time()
        response_time = end_time - start_time

        # Mencetak waktu respons di konsol
        print(
            f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
        )

        return jsonify(result)
    finally:
        cursor.close()
        conn.close()


# -------------------------------------------------------------------------------


@app.route("/editmemvm", methods=["GET", "POST"])
def editmemvm():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()
    
    try:
        if request.method == "POST":
            memory = request.form.get("mem")
            id = request.form.get("id")
            command = f"qm set {id} --memory {memory} && qm stop {id} && qm start {id}"
            client = paramiko.client.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect(ip_address, username=username, password=password)
            _stdin, _stdout, _stderr = client.exec_command(command)

            # Menghitung waktu respons
            end_time = measure_time()
            response_time = end_time - start_time

            # Mencetak waktu respons di konsol
            print(
                f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
            )

            data = {
                "id": id,
                "mem": memory,
            }

            return json.dumps(data)
    finally:
        cursor.close()
        conn.close()


@app.route("/editdiskvm", methods=["GET", "POST"])
def editdiskvm():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()
    
    try:
        if request.method == "POST":
            disk = request.form.get("disk")
            id = request.form.get("id")
            command = f"qm resize {id} ide0 +{disk}G"
            client = paramiko.client.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect(ip_address, username=username, password=password)
            _stdin, _stdout, _stderr = client.exec_command(command)

            # Menghitung waktu respons
            end_time = measure_time()
            response_time = end_time - start_time

            # Mencetak waktu respons di konsol
            print(
                f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
            )

            data = {
                "id": id,
                "disk": disk,
            }
            return json.dumps(data)
    finally:
        cursor.close()
        conn.close()


@app.route("/editcpuvm", methods=["GET", "POST"])
def editcpuvm():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()
    
    try:
        if request.method == "POST":
            cpu = request.form.get("cpu")
            id = request.form.get("id")

            id_type = str(type(id))

            command = f"qm set {id} --cores {cpu} && qm stop {id} && qm start {id}"
            client = paramiko.client.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect(ip_address, username=username, password=password)
            _stdin, _stdout, _stderr = client.exec_command(command)

            # Menghitung waktu respons
            end_time = measure_time()
            response_time = end_time - start_time

            # Mencetak waktu respons di konsol
            print(
                f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
            )

            data = {
                "id": id,
                "cpu": cpu,
            }
            return json.dumps(data)
    finally:
        cursor.close()
        conn.close()


# -------------------------------------------------------------------------------


@app.route("/editmemcontainer", methods=["GET", "POST"])
def editmemcont():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()

    try:
        if request.method == "POST":
            id = request.form.get("id")
            memory = request.form.get("mem")

            try:
                command = f"pct set {id} --memory {memory}"
                client = paramiko.client.SSHClient()
                client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                client.connect(ip_address, username=username, password=password)
                _stdin, _stdout, _stderr = client.exec_command(command)

                # # Capture _stdin and _stdout as strings
                # stdin_output = _stdin.read().decode("utf-8")
                # stdout_output = _stdout.read().decode("utf-8")

                # Menghitung waktu respons
                end_time = measure_time()
                response_time = end_time - start_time

                # Mencetak waktu respons di konsol
                print(
                    f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
                )

                data = {
                    "data": {
                        "id": id,
                        "mem": memory,
                    },
                    "stdout": _stdout.read().decode("utf-8"),  # Membaca stdout
                }
                return json.dumps(data)
            except Exception as e:
                return jsonify({"error": str(e)}), 500
            finally:
                client.close()
    finally:
        cursor.close()
        conn.close()


@app.route("/editcpucontainer", methods=["GET", "POST"])
def editcpucontainer():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()

    try:
        if request.method == "POST":
            id = request.form.get("id")
            cpu = request.form.get("cpu")

            try:
                command = f"pct set {id} --cores {cpu}"
                client = paramiko.client.SSHClient()
                client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                client.connect(ip_address, username=username, password=password)
                _stdin, _stdout, _stderr = client.exec_command(command)

                # # Capture _stdin and _stdout as strings
                # stdin_output = _stdin.read().decode("utf-8")
                # stdout_output = _stdout.read().decode("utf-8")

                # Menghitung waktu respons
                end_time = measure_time()
                response_time = end_time - start_time

                # Mencetak waktu respons di konsol
                print(
                    f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
                )

                data = {
                    "data": {
                        "id": id,
                        "cpu": cpu,
                    },
                    "stdout": _stdout.read().decode("utf-8"),  # Membaca stdout
                }
                return json.dumps(data)
            except Exception as e:
                return jsonify({"error": str(e)}), 500
            finally:
                client.close()
    finally:
        cursor.close()
        conn.close()


@app.route("/editdiskcontainer", methods=["GET", "POST"])
def edithddcontainer():
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Mulai mengukur waktu sebelum operasi dimulai
        start_time = measure_time()

        if request.method == "POST":
            id = request.form.get("id")
            disk = request.form.get("disk")

            try:
                command = f"pct resize {id} rootfs +{disk}G"
                client = paramiko.client.SSHClient()
                client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                client.connect(ip_address, username=username, password=password)
                _stdin, _stdout, _stderr = client.exec_command(command)

                # Menghitung waktu respons
                end_time = measure_time()
                response_time = end_time - start_time

                data = {
                    "data": {
                        "id": id,
                        "disk": disk,
                    },
                }

                # Mencetak waktu respons di konsol
                print(
                    f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
                )
                return json.dumps(data)  # Success

            except Exception as e:
                return jsonify({"error": str(e)}), 500
            finally:
                client.close()
    finally:
        cursor.close()
        conn.close()


# -------------------------------------------------------------------------------

automation_running = {}


def convert_to_mb(value_in_bytes):
    return value_in_bytes / (1024**2)  # Convert bytes to megabytes


def start_automation(vmid):
    conn = get_db_connection()
    cursor = conn.cursor()

    global automation_running

    try:
        while automation_running.get(vmid, False):
            url = f"https://{ip_address}:8006/api2/json/nodes/{node_name}/qemu/{vmid}/status/current"
            x = requests.get(url, verify=False, cookies=cookie)
            result = x.json()

            result_data = result.get("data")
            if result_data is not None:  # Check if result_data is not None
                a = result_data.get("maxmem")
                b = result_data.get("mem")

                if a is not None and b is not None:
                    a_mb = convert_to_mb(a)
                    b_mb = convert_to_mb(b)

                # Calculate the thresholds
                mem_threshold = a_mb * 40 / 100  # 60% of maxmem
                maxmem_threshold = a_mb * 90 / 100  # Maxmem threshold

                if mem_threshold < b_mb and b_mb < maxmem_threshold:
                    new_memory = int(a_mb + 128)
                    cmd = f"qm set {vmid} --memory {new_memory} && qm stop {vmid} && qm start {vmid}"
                    client = paramiko.client.SSHClient()
                    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                    client.connect(ip_address, username=username, password=password)
                    _stdin, _stdout, _stderr = client.exec_command(cmd)

                    cmd_output = _stdout.read().decode("utf-8")
                    cmd_error = _stderr.read().decode("utf-8")

                    print(f"Command Output: {cmd_output}")
                    print(f"Command Error: {cmd_error}")

                    print(f"Updated maxmem to {new_memory} for VM {vmid}")

                else:
                    print(
                        f"Memory is not yet 60% full or maxmem threshold exceeded for VM {vmid}"
                    )
                time.sleep(60)
    finally:
        cursor.close()
        conn.close()
    


@app.route("/memoryautovm", methods=["GET", "POST"])
def memoryauto():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()
    global cookie, node_name, automation_running

    try:
        if request.method == "POST":
            if cookie is None or node_name is None:
                return jsonify({"message": "Unauthorized"}), 401

            vmid = request.form.get("vmid")
            is_automation_running = request.form.get("isAutomationRunning")

            if id is None:
                return "Invalid request"

            if is_automation_running == "true":
                if automation_running.get(vmid, False):
                    return "Automation is already running"
                else:
                    automation_running[vmid] = True
                    automation_thread = threading.Thread(
                        target=start_automation, args=(vmid,)
                    )
                    automation_thread.start()

                    # Menghitung waktu respons
                    end_time = measure_time()
                    response_time = end_time - start_time

                    # Mencetak waktu respons di konsol
                    print(
                        f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
                    )
                    return f"Started automation for VM {vmid}"
            else:
                if automation_running.get(vmid, False):
                    # Stop automation for the given VM
                    automation_running[vmid] = False

                    automation_thread.start()
                    return f"Stopped automation for VM {vmid}"
                else:
                    return f"Automation is not running for VM {vmid}"
    finally:
        cursor.close()
        conn.close()


# -------------------------------------------------------------------------------

automation_running_con = {}


def convert_to_mb_con(value_in_bytes):
    return value_in_bytes / (1024**2)  # Convert bytes to megabytes


def start_automation_con(vmid):
    conn = get_db_connection()
    cursor = conn.cursor()

    global automation_running_con

    try:
        while automation_running_con.get(vmid, False):
            url = f"https://{ip_address}:8006/api2/json/nodes/{node_name}/lxc/{vmid}/status/current"
            x = requests.get(url, verify=False, cookies=cookie)
            result = x.json()

            result_data = result.get("data")
            if result_data is not None:  # Check if result_data is not None
                a = result_data.get("maxmem")
                b = result_data.get("mem")

                if a is not None and b is not None:
                    a_mb = convert_to_mb_con(a)
                    b_mb = convert_to_mb_con(b)

                # Calculate the thresholds
                mem_threshold = a_mb * 40 / 100  # 40% of maxmem
                maxmem_threshold = a_mb * 90 / 100  # Maxmem threshold

                if mem_threshold < b_mb and b_mb < maxmem_threshold:
                    new_memory = int(a_mb + 50)
                    cmd = f"pct set {vmid} --memory {new_memory}"
                    client = paramiko.client.SSHClient()
                    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                    client.connect(ip_address, username=username, password=password)
                    _stdin, _stdout, _stderr = client.exec_command(cmd)

                    cmd_output = _stdout.read().decode("utf-8")
                    cmd_error = _stderr.read().decode("utf-8")

                    print(f"Command Output: {cmd_output}")
                    print(f"Command Error: {cmd_error}")

                    print(f"Updated maxmem to {new_memory} for Container {vmid}")

                else:
                    print(
                        f"Memory is not yet 40% full or maxmem threshold exceeded for Container {vmid}"
                    )
                time.sleep(60)  # Wait for 20 seconds before checking again
    finally:
        cursor.close()
        conn.close()


@app.route("/memoryautocon", methods=["GET", "POST"])
def memoryautocon():
    conn = get_db_connection()
    cursor = conn.cursor()
    # Mulai mengukur waktu sebelum operasi dimulai
    start_time = measure_time()

    global cookie, node_name, automation_running_con

    try:
        if request.method == "POST":
            if cookie is None or node_name is None:
                return jsonify({"message": "Unauthorized"}), 401

            vmid = request.form.get("vmid")
            is_automation_running = request.form.get("isAutomationRunning")

            if id is None:
                return "Invalid request"

            if is_automation_running == "true":
                if automation_running_con.get(vmid, False):
                    return "Automation is already running"
                else:
                    automation_running_con[vmid] = True
                    automation_thread = threading.Thread(
                        target=start_automation_con, args=(vmid,)
                    )
                    automation_thread.start()
                    # Menghitung waktu respons
                    end_time = measure_time()
                    response_time = end_time - start_time

                    # Mencetak waktu respons di konsol
                    print(
                        f"Start Time: {start_time:.4f}\nEnd Time: {end_time:.4f}\nResponse Time: {response_time:.4f} seconds"
                    )
                    return f"Started automation for Container {vmid}"
            else:
                if automation_running_con.get(vmid, False):
                    # Stop automation for the given VM
                    automation_running_con[vmid] = False

                    automation_thread.start()

                    return f"Stopped automation for Container {vmid}"
                else:
                    return f"Automation is not running for Container {vmid}"
    finally:
        cursor.close()
        conn.close()


# @app.route("/startVM", methods=["GET", "POST"])
# def startVM():
#     if request.method == "POST":
#         data = request.get_json()
#         id = data.get("id")

#         command = f"qm start {id}"
#         client = paramiko.client.SSHClient()
#         client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
#         client.connect(ip_address, username=username, password=password)
#         _stdin, _stdout, _stderr = client.exec_command(command)
#         data = {
#             "id": id,
#             "status": "running",
#         }
#         return json.dumps(data)


# @app.route("/stopVM", methods=["GET", "POST"])
# def stopVM():
#     if request.method == "POST":
#         data = request.get_json()
#         id = data.get("id")

#         command = f"qm stop {id}"
#         client = paramiko.client.SSHClient()
#         client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
#         client.connect(ip_address, username=username, password=password)
#         _stdin, _stdout, _stderr = client.exec_command(command)
#         data = {
#             "id": id,
#             "status": "stopped",
#         }
#         return json.dumps(data)


# @app.route("/startContainer", methods=["GET", "POST"])
# def startContainer():
#     if request.method == "POST":
#         data = request.get_json()
#         id = data.get("id")

#         command = f"pct start {id}"
#         client = paramiko.client.SSHClient()
#         client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
#         client.connect(ip_address, username=username, password=password)
#         _stdin, _stdout, _stderr = client.exec_command(command)
#         data = {
#             "id": id,
#             "status": "started",
#         }
#         return json.dumps(data)


# @app.route("/stopContainer", methods=["GET", "POST"])
# def stopContainer():
#     if request.method == "POST":
#         data = request.get_json()
#         id = data.get("id")

#         command = f"pct stop {id}"
#         client = paramiko.client.SSHClient()
#         client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
#         client.connect(ip_address, username=username, password=password)
#         _stdin, _stdout, _stderr = client.exec_command(command)
#         data = {
#             "id": id,
#             "status": "stopped",
#         }
#         return json.dumps(data)


if __name__ == "__main__":
    app.run(debug=True)
