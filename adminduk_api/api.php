<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$conn = new mysqli('localhost', 'root', '', 'adminduk_db');

if ($conn->connect_error) {
    die(json_encode(['success' => false, 'error' => 'Connection failed: ' . $conn->connect_error]));
}

$action = $_POST['action'] ?? '';

switch($action) {
    case 'login':
        $email = $conn->real_escape_string($_POST['email']);
        $password = $conn->real_escape_string($_POST['password']);
        
        // Debug log
        error_log("Login attempt - Email: $email");
        
        $result = $conn->query("SELECT * FROM users WHERE email='$email' AND password='$password'");
        
        if($result && $result->num_rows > 0) {
            $user = $result->fetch_assoc();
            
            // Debug log
            error_log("User found - ID: " . $user['id_user']);
            
            echo json_encode([
                'success' => true,
                'user' => [
                    'id_user' => (int)$user['id_user'],
                    'email' => $user['email'],
                    'nama' => $user['nama'],
                    'alamat' => $user['alamat'],
                    'nomor_telepon' => $user['nomor_telepon']
                ]
            ]);
        } else {
            echo json_encode([
                'success' => false,
                'error' => 'Invalid credentials'
            ]);
        }
        break;
        
    case 'register':
        $email = $conn->real_escape_string($_POST['email']);
        $password = $conn->real_escape_string($_POST['password']);
        $nama = $conn->real_escape_string($_POST['nama']);
        $alamat = $conn->real_escape_string($_POST['alamat']);
        $nomorTelepon = $conn->real_escape_string($_POST['nomor_telepon']);
        
        // Check if email already exists
        $checkEmail = $conn->query("SELECT id_user FROM users WHERE email='$email'");
        if($checkEmail->num_rows > 0) {
            echo json_encode([
                'success' => false,
                'error' => 'Email sudah terdaftar'
            ]);
            break;
        }
        
        $result = $conn->query("INSERT INTO users (email, password, nama, alamat, nomor_telepon) 
                               VALUES ('$email', '$password', '$nama', '$alamat', '$nomorTelepon')");
        
        if($result) {
            $userId = $conn->insert_id;
            echo json_encode([
                'success' => true,
                'message' => 'Registrasi berhasil',
                'user_id' => $userId
            ]);
        } else {
            echo json_encode([
                'success' => false,
                'error' => 'Registrasi gagal: ' . $conn->error
            ]);
        }
        break;
        
    default:
        echo json_encode([
            'success' => false,
            'error' => 'Invalid action'
        ]);
}

$conn->close();
?> 